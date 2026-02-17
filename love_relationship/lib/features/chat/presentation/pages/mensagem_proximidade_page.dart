import 'package:flutter/material.dart';
import 'package:love_relationship/core/theme/app_colors.dart';

/// Tela "Mensagem para quando estivermos perto".
class MensagemProximidadePage extends StatelessWidget {
  const MensagemProximidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensagem para quando estivermos perto'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Configure sua mensagem para quando estiverem perto.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
