import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_state.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.welcome)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.loading) return const Center(child: CircularProgressIndicator());
          if (state.error != null) return Center(child: Text(state.error!));
          final user = state.user;
          if (user == null) return Center(child: Text(l10n.userNotFound));

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Olá, ${user.name}!'),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: l10n.editUser,
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
