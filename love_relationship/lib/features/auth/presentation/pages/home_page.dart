import 'package:flutter/material.dart';
import 'package:love_relationship/features/auth/domain/entities/user.dart';

class HomePage extends StatelessWidget {
  final User? user;
  const HomePage({this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bem-vindo')),
      body: Center(
        child: Text('Olá, ${user?.name ?? 'Usuário'}!'),
      ),
    );
  }
}