import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_status.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/edit_user/edit_user_state.dart';
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
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editUser)),
      body: BlocConsumer<EditUserBloc, EditUserState>(
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
          if (state.saveSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.savedSuccess)),
            );
            context.read<EditUserBloc>().add(const EditUserClearSaveSuccess());
            Navigator.pop(context);
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
                  onChanged: (v) => context.read<EditUserBloc>().add(EditUserNameChanged(v)),
                ),
                const SizedBox(height: 24),
                state.loading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        key: const Key('edit_user_save_button'),
                        text: l10n.save,
                        onPressed: () async {
                          context.read<EditUserBloc>().add(const EditUserSave());
                        },
                      ),
                SizedBox(height: 16),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state.error != null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error!)));
                    } else if (state.status == AuthStatus.unauthenticated) {
                      Navigator.of(context, rootNavigator: true)
                          .pushNamedAndRemoveUntil(
                        AppStrings.loginRoute,
                        (route) => false,
                      );
                    }
                  },
                  builder: (context, state) {
                    return state.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                            text: 'Logout',
                            backgroundColor: AppColors.redDefault,
                            onPressed: () async {
                              context.read<AuthBloc>().add(const AuthLogoutRequested());
                            },
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
