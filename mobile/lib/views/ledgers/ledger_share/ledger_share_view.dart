import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/views/ledgers/ledger_share/ledger_share_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class LedgerShareView extends StatefulWidget {
  const LedgerShareView({super.key, required this.ledgerOrId});

  final ModelOrId<Ledger> ledgerOrId;

  @override
  State<LedgerShareView> createState() => _LedgerShareViewState();
}

class _LedgerShareViewState extends State<LedgerShareView> {
  LedgerShareViewModel? _model;
  LedgerShareViewModel get model => _model!;

  static String tr(String key) => ez.tr('ledger_share_view.$key');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model != null) return;
    _model = LedgerShareViewModel(
      ledgerOrId: widget.ledgerOrId,
      ledgerRepo: context.app.ledgerRepo,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                tr('share_msg'),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: OutlinedButton(
                onPressed: () async {
                  final email = await showDialog<String>(
                    context: context,
                    builder: (context) => _EmailDialog(),
                  );
                  if (email == null) return;
                  if (!context.mounted) return;
                  model.addSharedEmail(
                    email: email,
                    context: context,
                  );
                },
                child: Text(tr('add_email_btn')),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: model.isLoading,
            builder: (context, isLoading, child) {
              if (isLoading) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              }
              return child!;
            },
            child: ValueListenableBuilder(
              valueListenable: model.sharedEmails,
              builder: (context, emails, _) {
                if (emails.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Center(child: Text(tr('share_with_noone_msg'))),
                    ),
                  );
                }
                return SliverList.separated(
                  itemCount: emails.length,
                  separatorBuilder: (context, i) => Divider(),
                  itemBuilder: (context, i) {
                    final email = emails[i];
                    return ListTile(
                      title: Text(email),
                      trailing: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          model.removeSharedEmail(email);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailDialog extends StatefulWidget {
  const _EmailDialog();

  static String tr(String key) => ez.tr('ledger_share_view.$key');

  @override
  State<_EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<_EmailDialog> {
  late final TextEditingController controller;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_EmailDialog.tr('add_email_dialog_title')),
      content: Form(
        key: formKey,
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          controller: controller,
          validator: (value) {
            if (value == null || EmailValidator.validate(value) == false) {
              return ez.tr('error_msg.invalid_email');
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: _EmailDialog.tr('add_email_dialog_hint')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(_EmailDialog.tr('cancel_btn')),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate() != true) return;
            Navigator.of(context).pop(controller.text);
          },
          child: Text(_EmailDialog.tr('add_btn')),
        ),
      ],
    );
  }
}
