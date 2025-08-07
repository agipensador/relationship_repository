import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/core/constants/app_strings.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_image_header.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:love_relationship/shared/widgets/clickable_button.dart';
import 'package:love_relationship/shared/widgets/primary_button.dart';
import 'package:love_relationship/shared/widgets/secondary_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(padding: EdgeInsets.all(16),
          child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AuthImageHeader(), // image Banco
            SizedBox(height: 32),
            AuthTextField(controller: emailController, hint: 'Email'),
            const SizedBox(height: 16),
            AuthTextField(controller: passwordController, hint: 'Senha', obscure: true),
            const SizedBox(height: 4),
            Align(alignment: Alignment.centerRight, child: ClickableButton(text: 'Esqueci a senha', onPressed: () => Navigator.pushNamed(context, '/register'))),
            const SizedBox(height: 16),
            //BLoC
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state){
                if(state is LoginFailure){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is LoginSuccess) {
                    Navigator.pushReplacementNamed(context, AppStrings.homeRoute, arguments: state);
                  }
              },
              builder: (context, state){
                return state is LoginLoading ? CircularProgressIndicator()
                 : Column(
                    children: [
                      PrimaryButton(
                        key: Key('login_button'),
                        text: AppStrings.btnAccess,
                        onPressed: () =>
                          context.read<LoginCubit>().login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          )
                      ),
                      SizedBox(height: 16),
                      SecondaryButton(
                        text: AppStrings.btnRegister, 
                        onPressed:  () => Navigator.pushNamed(context, AppStrings.registerRoute)
                      ),
                    ],
                  );
              })
          ],
          ),
        ),
      ),
    );
  }
}
