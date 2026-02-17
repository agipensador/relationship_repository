import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFAA143C); // vermelho principal (logo)
  static const Color secondary = Color(0xFFC41E5A); // baseado na primary (mais claro)
  static const Color tertiary = Color(0xFF7A0E28); // mais escuro que primary
  // static const Color backgroundPrimary = Color.fromARGB(255, 255, 235, 242);
  // static const Color backgroundPrimary = Color(0xFFFDF4F7);
  static const Color backgroundPrimary = Color(0xFFFCECF2);
  static const Color backgroundSecondary = Color.fromARGB(255, 57, 16, 31);
  static const Color grayDefault = Color.fromARGB(255, 158, 123, 139);
  static const Color blackDefault = Color(0xFF252525);
  static const Color whiteDefault = Color(0xFFFFFFFF);
  static const Color redDefault = Color.fromARGB(255, 123, 0, 49);

  // Estados / Feedback
  static const Color success = Color(0xFF2E7D32); // Verde sucesso
  static const Color warning = Color(0xFFF9A825); // Amarelo alerta
  static const Color error = Color(0xFF96003C); // Vermelho/rosa erro
  static const Color info = Color(0xFF1976D2); // Azul informativo

  // Variantes da primária (shades & tints)
  static const Color primaryLight = Color(0xFFD42D6B); // mais claro (hover, foco)
  static const Color primaryDark = Color(0xFF7A0E28); // mais escuro (pressed)

  // Overlay e states
  static const Color overlay = Color(0x33000000); // Preto com 20% opacidade
  static const Color shadow = Color(0x1A000000); // Preto com 10% opacidade

  // Brutalismo (chat e telas com esse padrão)
  static const Color brutalistPrimary = Color(0xFFAA143C); // vermelho principal
  static const Color brutalistAccent = Color(0xFFFFE135); // amarelo CTA
  static const Color brutalistBackground = Color(0xFFFCECF2); // fundo claro
  static const Color brutalistSurface = Color(0xFFFFFFFF); // cards/input
  static const Color brutalistBorder = Color(0xFF000000); // bordas grossas
  static const Color brutalistText = Color(0xFF000000); // texto bold
}
