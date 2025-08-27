import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/features/common/presentation/mappers/failure_message_mapper.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

import '../cubit/forgot_password_cubit.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final emailCtrl = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.passwordHint),
      ), // crie uma string "Recuperar senha"
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state.error != null) {
            final msg = failureToMessage(context, state.error!);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          } else if (state.sent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 10),
                content: Text(
                  "${l10n.emailSentForgotPassword} ${emailCtrl.text}\nCASO NÃO ENCONTRE O EMAIL, VERIFIQUE A CAIXA DE SPAM",
                ),
                backgroundColor: AppColors.secondary,
              ), // crie uma string: "Email enviado"
            );
            Navigator.pop(context); // volta pro Login
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  controller: emailCtrl,
                  hint: l10n.emailHint,
                  onChanged: context.read<ForgotPasswordCubit>().onEmailChanged,
                ),
                const SizedBox(height: 16),
                state.loading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'Enviar',
                        onPressed: () =>
                            context.read<ForgotPasswordCubit>().send(),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
