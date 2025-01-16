import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/views/settings/delete_account_viewmodel.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  static String tr(String key) => ez.tr('delete_account_view.$key');

  DeleteAccountViewModel? _model;
  DeleteAccountViewModel get model => _model!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model != null) return;
    _model = DeleteAccountViewModel(
      authService: context.app.authService,
    );
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(tr('appbar_title')),
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: slPaddingHorizontal),
            sliver: SliverFillRemaining(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr('warning_msg'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(tr('confirm_delete_title')),
                          content: Text(tr('confirm_delete_msg')),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(tr('cancel_btn')),
                            ),
                            TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  model.deleteAccount();
                                  Navigator.pop(context);
                                },
                                child: Text(tr('delete_btn'))),
                          ],
                        ),
                      );
                    },
                    child: ValueListenableBuilder(
                        valueListenable: model.isDeletingAccount,
                        builder: (context, isDeletingAccount, child) =>
                            isDeletingAccount
                                ? const SizedBox.square(
                                    dimension: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : Text(tr('delete_btn'))),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(tr('go_back_btn')),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
