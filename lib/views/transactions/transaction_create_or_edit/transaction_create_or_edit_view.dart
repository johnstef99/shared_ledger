import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/models/transaction_model.dart';
import 'package:shared_ledger/views/transactions/transaction_create_or_edit/transaction_create_or_edit_viewmodel.dart';
import 'package:shared_ledger/widgets/date_time_field_widget.dart';
import 'package:shared_ledger/widgets/select_contact_field_widget.dart';
import 'package:shared_ledger/widgets/text_field_widget.dart';

class TransactionCreateOrEditView extends StatefulWidget {
  const TransactionCreateOrEditView({
    super.key,
    this.transaction,
    required this.ledgerId,
  });

  final int ledgerId;
  final Transaction? transaction;

  @override
  State<TransactionCreateOrEditView> createState() =>
      _TransactionCreateOrEditViewState();
}

class _TransactionCreateOrEditViewState
    extends State<TransactionCreateOrEditView> {
  late TransactionCreateOrEditViewModel model;

  static String tr(String key) => ez.tr('transaction_create_or_edit_view.$key');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = TransactionCreateOrEditViewModel(
      transactionsRepo: context.app.transactionsRepo,
      contactsService: context.app.contactsService,
      ledgerId: widget.ledgerId,
      transaction: widget.transaction,
      router: GoRouter.of(context),
    );
    model.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              widget.transaction == null
                  ? tr('appbar_title.create')
                  : tr('appbar_title.edit'),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: slPaddingHorizontal),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Form(
                  key: model.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SelectContactField(
                        contact: model.contact,
                        onContactSelected: (contact) {
                          model.contact.value = contact;
                        },
                      ),
                      SizedBox(height: 10),
                      SLTextField(
                        initialValue: model.amount == null
                            ? null
                            : NumberFormat('0.###').format(model.amount!.abs()),
                        label: tr('amount_label'),
                        keyboardType: TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        textInputAction: TextInputAction.next,
                        prefixIcon: Icon(Icons.payments_outlined),
                        onSaved: (value) {
                          if (value == null) return;
                          final number = double.tryParse(value);
                          if (number == null) return;
                          model.amount = number.abs();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an amount';
                          }
                          final isNumber = double.tryParse(value);
                          if (isNumber == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5),
                      ValueListenableBuilder(
                          valueListenable: model.isIncome,
                          builder: (context, isIncome, child) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 350),
                              child: SizedBox(
                                width: double.infinity,
                                child: SegmentedButton<bool>(
                                  showSelectedIcon: false,
                                  style: SegmentedButton.styleFrom(
                                    selectedBackgroundColor: isIncome
                                        ? Colors.lightGreen.shade200
                                        : Colors.red.shade200,
                                  ),
                                  selected: {isIncome},
                                  onSelectionChanged: (value) {
                                    model.isIncome.value = value.first;
                                  },
                                  segments: [
                                    ButtonSegment(
                                      value: true,
                                      label: Text(tr('income')),
                                    ),
                                    ButtonSegment(
                                      value: false,
                                      label: Text(tr('expense')),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      SizedBox(height: 10),
                      DateTimeField(
                        label: tr('date_label'),
                        dateTime: model.dateTime,
                        onDateTimeSelected: model.onDateTimeSelected,
                      ),
                      SizedBox(height: 10),
                      SLTextField(
                        initialValue: model.comment,
                        label: tr('comment_label'),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: 3,
                        onSaved: (value) {
                          if (value == null) return;
                          model.comment = value;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: model.save,
                        child: Text(
                          widget.transaction == null
                              ? tr('save_btn.create')
                              : tr('save_btn.edit'),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
