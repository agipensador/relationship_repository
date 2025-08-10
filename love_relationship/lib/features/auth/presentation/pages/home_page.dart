import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_state.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo')),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text(state.error!));
          final user = state.user;
          if (user == null) return const Center(child: Text('Usuário não encontrado'));

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Olá, ${user.name}!'),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: AppStrings.editUser,
                  onPressed: () async {
                    Navigator.pushNamed(context, AppStrings.editUserRoute);
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
