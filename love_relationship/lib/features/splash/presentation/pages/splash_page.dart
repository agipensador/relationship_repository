import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/core/theme/app_colors.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:love_relationship/features/auth/presentation/bloc/auth/auth_status.dart';

/// Splash que exibe a animação a2_logo.
/// Dispara AuthAppStarted e reage ao AuthState para navegar.
/// Garante tempo mínimo de 4 segundos exibindo a animação.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _minSplashDuration = Duration(seconds: 3);

  late final Future<void> _minTimeFuture;

  @override
  void initState() {
    super.initState();
    _minTimeFuture = Future.delayed(_minSplashDuration);
    context.read<AuthBloc>().add(const AuthAppStarted());
  }

  void _navigateAfterMinTime(String targetRoute) {
    _minTimeFuture.then((_) {
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        targetRoute,
        (_) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          curr.status == AuthStatus.authenticated ||
          curr.status == AuthStatus.unauthenticated,
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          _navigateAfterMinTime(AppStrings.shellRoute);
        } else if (state.status == AuthStatus.unauthenticated) {
          _navigateAfterMinTime(AppStrings.loginRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Lottie.asset(
              'assets/lottie/a2_logo.json',
              fit: BoxFit.contain,
              repeat: false,
              delegates: LottieDelegates(
                textStyle: (LottieFontStyle fontStyle) {
                  final baseSize =
                      fontStyle.fontFamily == 'Lateef' ? 155.0 : 140.0;
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
      ),
    );
  }
}
