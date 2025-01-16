import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/models/contact_model.dart';
import 'package:shared_ledger/views/contacts/contact_create_or_edit/contact_create_or_edit_viewmodel.dart';
import 'package:shared_ledger/widgets/text_field_widget.dart';

class ContactCreateOrEditView extends StatefulWidget {
  final Contact? contact;

  const ContactCreateOrEditView({super.key, this.contact});

  @override
  State<ContactCreateOrEditView> createState() =>
      _ContactCreateOrEditViewState();

  static String tr(String key) => ez.tr('contact_create_or_edit_view.$key');
}

class _ContactCreateOrEditViewState extends State<ContactCreateOrEditView> {
  CreateOrEditContactViewModel? _model;
  CreateOrEditContactViewModel get model => _model!;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_model != null) return;
    _model = CreateOrEditContactViewModel(
      contactsService: context.app.contactsService,
      router: GoRouter.of(context),
      contact: widget.contact,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null
              ? tr('appbar_title.create')
              : tr('appbar_title.edit'),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: slEdgePadding,
          child: Form(
            key: model.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SLTextField(
                  label: tr('name_label'),
                  initialValue: model.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ez.tr('error_msg.required');
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == null) return;
                    model.name = value;
                  },
                ),
                SizedBox(height: 10),
                SLTextField(
                  label: tr('email_label'),
                  initialValue: model.email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value != null &&
                        value.isNotEmpty &&
                        !EmailValidator.validate(value)) {
                      return ez.tr('error_msg.invalid_email');
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (value == null) return;
                    model.email = value;
                  },
                ),
                SizedBox(height: 10),
                SLTextField(
                  label: tr('phone_number_label'),
                  initialValue: model.phoneNumber,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.phone,
                  onSaved: (value) {
                    if (value == null) return;
                    model.phoneNumber = value;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: model.saveContact,
                  child: ValueListenableBuilder(
                    valueListenable: model.isLoading,
                    builder: (context, isLoading, child) {
                      if (isLoading) {
                        return const CircularProgressIndicator(strokeWidth: 2);
                      }
                      return Text(widget.contact == null
                          ? tr('save_btn.create')
                          : tr('save_btn.edit'));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String tr(String key) => ContactCreateOrEditView.tr(key);
}
