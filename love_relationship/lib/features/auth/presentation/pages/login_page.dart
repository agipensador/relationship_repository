import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:love_relationship/features/auth/presentation/cubit/login_cubit.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_image_header.dart';
import 'package:love_relationship/features/auth/presentation/widgets/auth_text_field.dart';

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
            const SizedBox(height: 24),
            //BLoC
            BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state){
                if(state is LoginFailure){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                } else if (state is LoginSuccess) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
              },
              builder: (context, state){
                return state is LoginLoading ? CircularProgressIndicator()
                 : Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<LoginCubit>().login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                        },
                        child: const Text('Entrar'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/register'),
                        child: const Text('Criar cadastro'),
                      )
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




class AudioPlayButton extends StatefulWidget {
  final Color color;
  const AudioPlayButton({super.key, this.color = Colors.green});

  @override
  State<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends State<AudioPlayButton> {
  bool isPlaying = false;

  void _toggleAudio() {
    setState(() {
      isPlaying = !isPlaying;
      // Aqui você pode integrar com o player de áudio
      if (isPlaying) {
        print('🔊 Tocando áudio...');
        // exemplo: audioPlayer.play(url);
      } else {
        print('⏸️ Pausando áudio...');
        // exemplo: audioPlayer.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAudio,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: widget.color,
          size: 30,
        ),
      ),
    );
  }
}
