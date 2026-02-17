import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/config/app_config.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/login/login_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_image_header.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/features/common/presentation/mappers/failure_message_mapper.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/clickable_button.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';
import 'package:love_relationship/shared/widgets/secondary_button.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/di/injection_container.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    if (AppConfig.instance.isDev) {
      // TODO: remover email/senha
      _emailController.text = 'gbrrizzardo@gmail.com';
      _passwordController.text = 'Tenda_123';
    }
    // Exibe prompt de permissão quando a UI de login já carregou
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<NotificationService>().requestPermissions();
      if (AppConfig.instance.isDev) {
        if (mounted) {
          context.read<LoginBloc>().add(LoginEmailChanged(_emailController.text));
          context.read<LoginBloc>().add(LoginPasswordChanged(_passwordController.text));
        }
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                controller: _emailController,
                hint: l10n.emailHint,
                onChanged: (v) => context.read<LoginBloc>().add(LoginEmailChanged(v)),
              ),

              const SizedBox(height: 16),
              AuthTextField(
                controller: _passwordController,
                hint: l10n.passwordHint,
                obscure: true,
                onChanged: (v) => context.read<LoginBloc>().add(LoginPasswordChanged(v)),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: TextClickableButton(
                  text: l10n.forgotPassword,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppStrings.forgotPasswordRoute,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //BLoC
              BlocConsumer<LoginBloc, LoginState>(
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
                              onPressed: () async {
                                context.read<LoginBloc>().add(const LoginSubmitted());
                              },
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
