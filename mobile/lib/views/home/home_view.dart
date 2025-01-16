import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/views/home/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.child});

  final StatefulNavigationShell child;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel? _model;
  HomeViewModel get model => _model!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model != null) return;
    _model = HomeViewModel(authService: context.app.authService);
  }

  @override
  Widget build(BuildContext context) {
    context.locale;

    model.user.addListener(() {
      if (!context.mounted) return;
      if (model.user.value.isEmpty) {
        context.go('/');
      }
    });

    final size = MediaQuery.sizeOf(context);
    final showRail = size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          if (showRail) ...[
            NavigationRail(
              selectedIndex: widget.child.currentIndex,
              onDestinationSelected: (index) {
                widget.child.goBranch(index);
              },
              labelType: NavigationRailLabelType.all,
              indicatorColor: Theme.of(context).focusColor,
              elevation: 2,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.receipt),
                  label: Text(tr('bottom_nav.ledgers')),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.contacts),
                  label: Text(tr('bottom_nav.contacts')),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text(tr('bottom_nav.settings')),
                ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1),
          ],
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: showRail
          ? null
          : BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: tr('bottom_nav.ledgers'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.contacts),
                  label: tr('bottom_nav.contacts'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: tr('bottom_nav.settings'),
                ),
              ],
              onTap: (index) {
                widget.child.goBranch(index);
              },
              currentIndex: widget.child.currentIndex,
            ),
    );
  }
}
