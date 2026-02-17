import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/features/common/presentation/mappers/failure_message_mapper.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/forgot_password/forgot_password_event.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _emailCtrl;
  late final TextEditingController _codeCtrl;
  late final TextEditingController _newPasswordCtrl;
  late final TextEditingController _confirmPasswordCtrl;
  bool _sentSnackbarShown = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _codeCtrl = TextEditingController();
    _newPasswordCtrl = TextEditingController();
    _confirmPasswordCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forgotPassword),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.error != null) {
            final msg = failureToMessage(context, state.error!);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
          } else if (state.sent && !_sentSnackbarShown) {
            _sentSnackbarShown = true;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 5),
                content: Text(
                  '${l10n.emailSentForgotPassword} ${state.email}\n${l10n.checkSpam}',
                ),
                backgroundColor: AppColors.secondary,
              ),
            );
          } else if (state.passwordReset) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.passwordResetSuccess),
                backgroundColor: AppColors.secondary,
              ),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!state.sent) ...[
                    AuthTextField(
                      controller: _emailCtrl,
                      hint: l10n.emailHint,
                      onChanged: (v) => context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(v)),
                    ),
                    const SizedBox(height: 16),
                    state.loading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: l10n.send,
                            onPressed: () async {
                              context.read<ForgotPasswordBloc>().add(const ForgotPasswordSendRequested());
                            },
                          ),
                  ] else ...[
                    Text(
                      l10n.enterCodeAndNewPassword,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    AuthTextField(
                      controller: _codeCtrl,
                      hint: l10n.confirmationCodeHint,
                      onChanged: (v) => context.read<ForgotPasswordBloc>().add(ForgotPasswordCodeChanged(v)),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _newPasswordCtrl,
                      hint: l10n.newPasswordHint,
                      obscure: true,
                      onChanged: (v) => context.read<ForgotPasswordBloc>().add(ForgotPasswordNewPasswordChanged(v)),
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _confirmPasswordCtrl,
                      hint: l10n.confirmPasswordHint,
                      obscure: true,
                      onChanged: (v) => context.read<ForgotPasswordBloc>().add(ForgotPasswordConfirmPasswordChanged(v)),
                    ),
                    const SizedBox(height: 24),
                    state.loading
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: l10n.confirmPasswordReset,
                            onPressed: () async {
                              context.read<ForgotPasswordBloc>().add(const ForgotPasswordConfirmRequested());
                            },
                          ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
