import 'package:flutter/material.dart';
import 'package:love_relationship/features/auth/domain/entities/user_entity.dart';

class HomePage extends StatelessWidget {
  final UserEntity? user;
  const HomePage({this.user, super.key});

  @override
  Widget build(BuildContext context) {
    print('gio: e,, ${user?.email}');
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo')),
      body: Center(
        child: Text('Olá, ${user?.name ?? 'Usuário'}!'),
      ),
    );
  }
}