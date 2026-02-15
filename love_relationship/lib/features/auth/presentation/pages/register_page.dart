import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/register/register_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';
import 'package:love_relationship/shared/widgets/secondary_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
          if (state.registeredUser != null && context.mounted) {
            Navigator.pushReplacementNamed(
              context,
              AppStrings.shellRoute,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(controller: nameController, hint: l10n.nameHint),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: emailController,
                  hint: l10n.emailHint,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: passController,
                  hint: l10n.passwordHint,
                  obscure: true,
                ),
                const SizedBox(height: 24),
                state.isLoading
                    ? CircularProgressIndicator()
                    : PrimaryButton(
                        key: const Key('register_button'),
                        text: l10n.createAccount,
                        onPressed: () async {
                          context.read<RegisterBloc>().add(
                                RegisterSubmitted(
                                  name: nameController.text,
                                  email: emailController.text,
                                  password: passController.text,
                                ),
                              );
                        },
                      ),
                const SizedBox(height: 16),
                SecondaryButton(
                  text: l10n.back,
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
