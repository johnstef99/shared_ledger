import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_ledger/app/app.dart';
import 'package:shared_ledger/app/theme.dart';
import 'package:shared_ledger/views/login/login_viewmodel.dart';
import 'package:shared_ledger/widgets/text_field_widget.dart';
import 'package:shared_ledger/widgets/view_model_provider_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel model;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    model = LoginViewModel(authService: context.app.authService);
  }

  @override
  void dispose() {
    model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.user.addListener(() {
      if (!context.mounted) return;
      if (model.user.value.isNotEmpty) {
        context.go('/');
      }
    });

    return ViewModelProvider(
      viewModel: model,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: slEdgePadding,
              child: Form(
                key: model.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Shared Ledger',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 40),
                    SLTextField(
                      key: const Key('email'),
                      textFieldKey: model.emailKey,
                      label: tr('login_view.email_label'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !EmailValidator.validate(value)) {
                          return tr('error_msg.invalid_email');
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (value == null) return;
                        model.email = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: ValueListenableBuilder(
                        valueListenable: model.loginType,
                        builder: (context, loginType, child) => Padding(
                          padding: loginType == null
                              ? EdgeInsets.zero
                              : const EdgeInsets.only(bottom: 20),
                          child: switch (loginType) {
                            LoginType.password => const _PasswordField(),
                            LoginType.magic => const _TokenField(),
                            _ => const SizedBox.shrink(),
                          },
                        ),
                      ),
                    ),
                    ValueListenableBuilder(
                      valueListenable: model.loginType,
                      builder: (context, loginType, child) => AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: MatrixTransition(
                              animation: animation,
                              onTransform: (animationValue) {
                                final value = 1 - animationValue;
                                return Matrix4.identity()
                                  ..setEntry(3, 2, 0.001)
                                  ..rotateY(value * 3.14 / 2);
                              },
                              child: child,
                            ),
                          );
                        },
                        child: switch (loginType) {
                          LoginType.password =>
                            const _LoginWithPasswordButtons(),
                          LoginType.magic => const _MaginLoginButtons(),
                          _ => _SelectLoginType(
                              onLoginTypeSelected: (type) {
                                model.setLoginType(type);
                                if (type == LoginType.magic) {
                                  model.sendMagicCode();
                                }
                              },
                            ),
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectLoginType extends StatelessWidget {
  const _SelectLoginType({required this.onLoginTypeSelected});

  final void Function(LoginType) onLoginTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('select_login_type'),
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 48),
            maximumSize: const Size(350, 48),
          ),
          onPressed: () => onLoginTypeSelected(LoginType.password),
          child: Text(
            tr('login_view.login_type.password'),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 48),
            maximumSize: const Size(350, 48),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: () => onLoginTypeSelected(LoginType.magic),
          child: Text(
            tr('login_view.login_type.magic'),
          ),
        ),
      ],
    );
  }
}

class _LoginWithPasswordButtons extends StatelessWidget {
  const _LoginWithPasswordButtons();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LoginViewModel>(context);
    return Column(
      key: const Key('login_with_password_buttons'),
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 48),
            maximumSize: const Size(350, 48),
          ),
          onPressed: model.login,
          child: ValueListenableBuilder(
            valueListenable: model.isLogginIn,
            builder: (context, isLoading, child) => isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  )
                : Text(tr('login_view.login_btn')),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => model.setLoginType(null),
          child: Text(tr('login_view.back_btn')),
        ),
      ],
    );
  }
}

class _MaginLoginButtons extends StatelessWidget {
  const _MaginLoginButtons();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LoginViewModel>(context);
    return Column(
      key: const Key('magic_login_buttons'),
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 48),
            maximumSize: const Size(350, 48),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: model.loginWithToken,
          child: ValueListenableBuilder(
            valueListenable: model.isLogginIn,
            builder: (context, isLoading, child) => isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : Text(tr('login_view.magic_login_btn')),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => model.setLoginType(null),
          child: Text(tr('login_view.back_btn')),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LoginViewModel>(context);
    return ValueListenableBuilder(
      valueListenable: model.isPasswordVisible,
      builder: (context, isPasswordVisible, child) {
        return SLTextField(
          key: const Key('password'),
          label: tr('login_view.password_label'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return tr('error_msg.invalid_password');
            }
            return null;
          },
          obscureText: !isPasswordVisible,
          suffixIcon: IconButton(
            onPressed: model.togglePasswordVisibility,
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          onSaved: (value) {
            if (value == null) return;
            model.password = value;
          },
          onFieldSubmitted: (_) => model.login(),
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
        );
      },
    );
  }
}

class _TokenField extends StatelessWidget {
  const _TokenField();

  @override
  Widget build(BuildContext context) {
    final model = ViewModelProvider.of<LoginViewModel>(context);
    return SLTextField(
      key: const Key('token'),
      label: tr('login_view.token_label'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return tr('error_msg.invalid_token');
        }
        return null;
      },
      onSaved: (value) {
        if (value == null) return;
        model.token = value;
      },
      onFieldSubmitted: (_) => model.loginWithToken(),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      suffixIcon: IconButton(
        onPressed: () => model.sendMagicCode(),
        icon: ValueListenableBuilder(
            valueListenable: model.isMagicCodeSending,
            builder: (context, isSending, child) {
              if (isSending) {
                return const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 1,
                  ),
                );
              }

              return StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  if (model.lastSentMagicLink == null) {
                    return const Icon(Icons.refresh);
                  }
                  final now = DateTime.now();
                  final cooldown = model.lastSentMagicLink!.add(
                    LoginViewModel.magicLinkCooldown,
                  );
                  final diff = cooldown.difference(now);
                  if (diff.isNegative) {
                    return const Icon(Icons.refresh);
                  }
                  return Text(
                    '${diff.inSeconds}',
                  );
                },
              );
            }),
      ),
    );
  }
}
