import 'package:easy_localization/easy_localization.dart' as ez;
import 'package:flutter/material.dart';
import 'package:shared_ledger/app/locator.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/services/auth_service.dart';
import 'package:shared_ledger/views/settings/change_password_viewmodel.dart';
import 'package:shared_ledger/widgets/text_field_widget.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  late final ChangePasswordViewModel model;
  late final TextEditingController newPasswordController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(tr('appbar_title')),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: slPaddingHorizontal,
            ),
            sliver: SliverFillRemaining(
              child: Form(
                key: model.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SLTextField(
                      controller: newPasswordController,
                      label: tr('new_password_label'),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      onSaved: (value) => model.password = value!,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ez.tr('error_msg.invalid_password');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    SLTextField(
                      label: tr('confirm_password_label'),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value != newPasswordController.text) {
                          return ez.tr('error_msg.password_mismatch');
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => model.changePassword(),
                      child: ValueListenableBuilder(
                        valueListenable: model.isChangingPassword,
                        builder: (context, isChangingPassword, child) =>
                            isChangingPassword
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(tr('submit_btn')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    model.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    model = ChangePasswordViewModel(authService: locator<AuthService>());
    newPasswordController = TextEditingController();
  }

  static String tr(String key) => ez.tr('change_password_view.$key');
}
