import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/notifications/notification_service.dart';
import 'package:love_relationship/di/injection_container.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_cubit.dart';
import 'package:love_relationship/features/auth/presentation/cubit/home_state.dart';
import 'package:love_relationship/l10n/app_localizations.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await sl<NotificationService>().requestPermissions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.welcome)),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
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
                SizedBox(height: 12),
                PrimaryButton(
                  text: 'Testar Notificação Local',
                  onPressed: () async {
                    final ok = await sl<NotificationService>().showLocal(
                      title: 'Teste',
                      body: 'Local notification',
                    );
                    if (!ok && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Falha ao exibir notificação'),
                        ),
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
