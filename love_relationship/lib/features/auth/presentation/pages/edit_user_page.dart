import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';
import 'package:love_relationship/features/auth/presentation/cubit/edit_user_cubit.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class EditUserPage extends StatefulWidget {
  //Aqui é o usuário que inicia na página
  // final UserEntity userEntity;

  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late final TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    // aqui widget.userEntity.name seta o nome do usuário que inicia na PG
    // nameController = TextEditingController(text: widget.userEntity.name);
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: Text(AppStrings.editUser)),
            body: BlocConsumer<EditUserCubit, EditUserState>(
              listener: (context, state) {
                // quando carregar o usuário, atualiza o controller  
                if(state.current != null && nameController.text != state.nameDraft){
                  nameController.text = state.nameDraft!;
                }
                if (state.error != null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error!)));
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
                        hint: state.current!.name!.isEmpty ?
                              AppStrings.editNameHint
                            : state.current?.name ?? '',
                      ),   
                      const SizedBox(height: 24),
                      state.loading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(
                        text: AppStrings.save,
                        onPressed: () async {
                          context
                              .read<EditUserCubit>()
                              .onNameChanged(nameController.text);

                          final saveEdittedUser =
                              await context.read<EditUserCubit>().save();
                          if (!mounted) return;

                          if (saveEdittedUser) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppStrings.savedSuccess)),
                            );
                            Navigator.pop(context); // volta pra Home
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(AppStrings.saveError)),
                            );
                          }
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