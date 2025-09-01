import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  void Function(String)? onChanged;
  AuthTextField({
    required this.controller,
    this.onChanged,
    this.hint = 'Preencha',
    this.obscure = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
      ),
      onChanged: onChanged,
    );
  }
}
