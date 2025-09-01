import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/services/storage_service.dart';

class AuthImageHeader extends StatefulWidget {
  const AuthImageHeader({super.key});

  @override
  State<AuthImageHeader> createState() => _AuthImageHeaderState();
}

class _AuthImageHeaderState extends State<AuthImageHeader> {
  late final Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    final storageService = GetIt.I<StorageService>();
    // Dê apenas o path do arquivo no bucket
    _imageUrlFuture = storageService.getImageUrl('logo.png');
  }

  @override
  Widget build(BuildContext context) {
    // Evita usar Platform.environment (quebra em mobile/web)
    final isTesting = const bool.fromEnvironment('FLUTTER_TEST');

    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 120,
            width: 120,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || isTesting) {
          return Image.asset('assets/images/a2_logo.jpg', height: 120);
        }

        return Image.network(
          snapshot.data!,
          height: 120,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) =>
              Image.asset('assets/images/a2_logo.jpg', height: 120),
        );
      },
    );
  }
}
