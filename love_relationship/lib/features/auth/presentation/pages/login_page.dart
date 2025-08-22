import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_image_header.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/features/common/presentation/mappers/failure_message_mapper.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/clickable_button.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';
import 'package:love_relationship/shared/widgets/secondary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthImageHeader(), // image Banco
              SizedBox(height: 32),

              AuthTextField(
                controller: emailController,
                hint: l10n.emailHint,
                onChanged: context.read<LoginCubit>().onEmailChanged,
              ),

              const SizedBox(height: 16),
              AuthTextField(
                controller: passwordController,
                hint: l10n.passwordHint,
                obscure: true,
                onChanged: context.read<LoginCubit>().onPasswordChanged,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextClickableButton(
                  text: l10n.forgotPassword,
                  onPressed: () =>
                      Navigator.pushNamed(context, AppStrings.registerRoute),
                ),
              ),
              const SizedBox(height: 16),
              //BLoC
              BlocConsumer<LoginCubit, LoginState>(
                listener: (context, state) {
                  if (state.error != null) {
                    final msg = failureToMessage(context, state.error!);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(msg)));
                  } else if (state.user != null) {
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   AppStrings.shellRoute,
                    // );
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil(
                      AppStrings.shellRoute,
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  return state.loading
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            PrimaryButton(
                              key: Key('login_button'),
                              text: l10n.btnAccess,
                              onPressed: () =>
                                  context.read<LoginCubit>().login(),
                            ),
                            SizedBox(height: 16),
                            SecondaryButton(
                              text: l10n.createAccount,
                              onPressed: () => Navigator.pushNamed(
                                context,
                                AppStrings.registerRoute,
                              ),
                            ),
                          ],
                        );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
