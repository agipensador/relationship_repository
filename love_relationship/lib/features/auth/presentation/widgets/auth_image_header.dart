import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:love_relationship/core/services/storage_service.dart';

class AuthImageHeader extends StatelessWidget {
  const AuthImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final storageService = GetIt.I<StorageService>();
    final isTesting = Platform.environment.containsKey('FLUTTER_TEST');

    return FutureBuilder<String>(
      future: storageService.getImageUrl('login/logo.png'),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done) return CircularProgressIndicator();

        if (snapshot.hasError || !snapshot.hasData || isTesting) return Image.asset('assets/images/a2_logo.jpg', height: 120,);

        return Image.network(snapshot.data!, height: 120);
      },
    );
  }
}