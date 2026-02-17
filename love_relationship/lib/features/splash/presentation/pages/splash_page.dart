import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/theme/app_colors.dart';

/// Splash que exibe a animação a2_logo enquanto o app carrega.
/// Dura o tempo da animação (~4s) e navega para o login.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _scheduleNavigation();
  }

  void _scheduleNavigation() {
    // Animação a2_logo: 120 frames @ 30fps = 4s
    Future.delayed(const Duration(milliseconds: 4200), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppStrings.loginRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: SizedBox(
          width: width,
          height: width, // quadrado para manter proporção
          child: Lottie.asset(
            'assets/lottie/a2_logo.json',
            fit: BoxFit.contain,
            repeat: false,
            delegates: LottieDelegates(
              textStyle: (LottieFontStyle fontStyle) {
                final baseSize = fontStyle.fontFamily == 'Lateef' ? 155.0 : 140.0;
                if (fontStyle.fontFamily == 'Lateef') {
                  return GoogleFonts.lateef(
                    fontSize: baseSize,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                  );
                }
                if (fontStyle.fontFamily == 'Libre Barcode EAN13 Text') {
                  return GoogleFonts.libreBarcodeEan13Text(
                    fontSize: baseSize,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  );
                }
                return TextStyle(fontSize: baseSize, color: Colors.white);
              },
            ),
          ),
        ),
      ),
    );
  }
}
