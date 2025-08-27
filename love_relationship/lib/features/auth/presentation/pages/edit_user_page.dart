import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/auth_state.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_state.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/features/common/presentation/mappers/failure_message_mapper.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EditUserCubit>().load();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editUser)),
      body: BlocConsumer<EditUserCubit, EditUserState>(
        listener: (context, state) {
          // manter controller sincronizado com o draft carregado
          if (state.current != null && nameController.text != state.nameDraft) {
            nameController.text = state.nameDraft!;
          }
          if (state.error != null) {
            final msg = failureToMessage(context, state.error!);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
        },
        builder: (context, state) {
          if (state.loading && state.current == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthTextField(
                  controller: nameController,
                  hint: state.current?.name?.isNotEmpty == true
                      ? state.current!.name!
                      : l10n.editNameHint,
                  onChanged: context.read<EditUserCubit>().onNameChanged,
                ),
                const SizedBox(height: 24),
                state.loading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        key: const Key('edit_user_save_button'),
                        text: l10n.save,
                        onPressed: () async {
                          final ok = await context.read<EditUserCubit>().save();
                          if (!mounted) return;
                          final msg = ok ? l10n.savedSuccess : l10n.saveError;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(msg)));
                          if (ok) Navigator.pop(context);
                        },
                      ),
                SizedBox(height: 16),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.error!)));
                    } else if (state.loggedOut) {
                      // Navigator.pushReplacementNamed(
                      //   context,
                      //   AppStrings.loginRoute,
                      // );
                      Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pushNamedAndRemoveUntil(
                        AppStrings.loginRoute,
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return state.isLoggingOut
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Logout',
                            backgroundColor: AppColors.redDefault,
                            onPressed: () => context.read<AuthCubit>().logout(),
                          );
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
