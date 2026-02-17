import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_colors.dart';

/// Tela "Mensagem pro futuro".
class MensagemFuturoPage extends StatelessWidget {
  const MensagemFuturoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagem pro futuro'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Configure sua mensagem para o futuro.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
