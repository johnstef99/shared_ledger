import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/repositories/ledger_repository.dart';
import 'package:shared_ledger/views/ledgers/ledgers_viewmodel.dart';
import 'package:shared_ledger/widgets/ledger_list_tile_widget.dart';
import 'package:shared_ledger/widgets/view_model_provider_widget.dart';

class LedgersView extends StatefulWidget {
  const LedgersView({super.key});

  @override
  State<LedgersView> createState() => _LedgersViewState();

  static String tr(String key) => ez.tr('ledgers_view.$key');
}

class _LedgersViewState extends State<LedgersView> {
  late final LedgersViewModel model;

  @override
  Widget build(BuildContext context) {
    context.locale;
    return ViewModelProvider(
      viewModel: model,
      child: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: RefreshIndicator(
            onRefresh: model.onRefresh,
            notificationPredicate: (notification) {
              return notification.depth == 2;
            },
            child: NestedScrollView(
              headerSliverBuilder: (context, isInnerBoxScrolled) => [
                SliverAppBar(
                  forceElevated: isInnerBoxScrolled,
                  title: Text(
                    tr('appbar_title'),
                  ),
                  bottom: TabBar(
                    tabs: [
                      Tab(text: tr('my_ledgers')),
                      Tab(text: tr('shared_with_me')),
                    ],
                  ),
                ),
              ],
              body: ValueListenableBuilder(
                valueListenable: model.isLoading,
                builder: (context, isLoading, child) {
                  if (isLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return TabBarView(
                    children: [
                      _MyLedgersList(),
                      _SharedLedgersList(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = LedgersViewModel(
      ledgerRepository: locator<LedgerRepository>(),
      router: GoRouter.of(context),
    );
    model.init();
  }

  static String tr(String key) => LedgersView.tr(key);
}

class _MyLedgersList extends StatelessWidget {
  const _MyLedgersList();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LedgersViewModel>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_ledger_button',
        onPressed: () async {
          await model.createNewLedgerTapped();
        },
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: model.userLedgers,
        builder: (context, ledgers, child) {
          if (ledgers.isEmpty) {
            return Center(
              child: Text(ez.tr('ledgers_view.no_ledgers_msg')),
            );
          }

          return AnimatedList(
            padding: const EdgeInsets.only(bottom: 100),
            key: model.animatedListKey,
            initialItemCount: ledgers.length,
            itemBuilder: (context, i, animation) {
              final ledger = ledgers[i];
              return LedgerListTile(
                key: ValueKey('ledger_${ledger.id}'),
                ledger: ledger,
                animation: animation,
                onDelete: () {
                  model.deleteLedgerTapped(ledger, i);
                },
                onEdit: () {
                  model.onEditLedgerTapped(ledger);
                },
                onTap: () => model.onLedgerTapped(ledger),
              );
            },
          );
        },
      ),
    );
  }
}

class _SharedLedgersList extends StatelessWidget {
  const _SharedLedgersList();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LedgersViewModel>(context);
    return ValueListenableBuilder(
      valueListenable: model.sharedLedgers,
      builder: (context, ledgers, child) {
        if (ledgers.isEmpty) {
          return Center(
            child: Text(ez.tr('ledgers_view.no_ledgers_msg')),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: ledgers.length,
          itemBuilder: (context, i) {
            final ledger = ledgers[i];
            return LedgerListTile(
              key: ValueKey('ledger_${ledger.id}'),
              ledger: ledger,
              animation: const AlwaysStoppedAnimation(1),
              onTap: () => model.onLedgerTapped(ledger),
            );
          },
        );
      },
    );
  }
}
