import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/app/utils.dart';
import 'package:shared_ledger/models/ledger_model.dart';
import 'package:shared_ledger/views/ledgers/ledger_create_or_edit/ledger_create_or_edit_viewmodel.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:shared_ledger/widgets/text_field_widget.dart';

class LedgerCreateOrEditView extends StatefulWidget {
  const LedgerCreateOrEditView({super.key, this.ledgerOrId});

  final ModelOrId<Ledger>? ledgerOrId;

  @override
  State<LedgerCreateOrEditView> createState() => _LedgerCreateOrEditViewState();
}

class _LedgerCreateOrEditViewState extends State<LedgerCreateOrEditView> {
  LedgerCreateOrEditViewModel? _model;
  LedgerCreateOrEditViewModel get model => _model!;

  static String tr(String key) => ez.tr('ledger_create_or_edit_view.$key');

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model != null) return;
    _model = LedgerCreateOrEditViewModel(
      router: GoRouter.of(context),
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
            title: Text(
              widget.ledgerOrId == null
                  ? tr('appbar_title.create')
                  : tr('appbar_title.edit'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: slPaddingHorizontal),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: model.isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return CircularProgressIndicator();
                    }

                    return Form(
                      key: model.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SLTextField(
                            initialValue: model.name,
                            label: tr('name_label'),
                            textInputAction: TextInputAction.next,
                            onSaved: (value) {
                              if (value == null) return;
                              model.name = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return ez.tr('error_msg.required');
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          SLTextField(
                            initialValue: model.description,
                            label: tr('description_label'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            maxLines: 3,
                            onSaved: (value) {
                              if (value == null) return;
                              model.description = value;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: model.save,
                            child: Text(
                              widget.ledgerOrId == null
                                  ? tr('save_btn.create')
                                  : tr('save_btn.edit'),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
