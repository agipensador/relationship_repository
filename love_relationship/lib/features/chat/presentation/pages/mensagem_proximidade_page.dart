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
            'Esta tela vai utilizar localização do casal, e se ambos tiverem localizacão ativa, conseguimos notificar essas mensagens para quando estiverem próximo;\n\nPodendo dar um grau de prioridade para essa mensagem já na hora que cria a mensagem.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
