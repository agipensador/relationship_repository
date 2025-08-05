import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthImageHeader extends StatelessWidget {
  const AuthImageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: FirebaseStorage.instance.ref('login/logo.png').getDownloadURL(),
      builder: (context, snapshot){
        if(snapshot.connectionState != ConnectionState.done) return CircularProgressIndicator();
        if (!snapshot.hasData) return Image.asset('assets/images/a2_logo.jpg', height: 120,);
        return Image.network(snapshot.data!, height: 120);

      },
    );
  }
}