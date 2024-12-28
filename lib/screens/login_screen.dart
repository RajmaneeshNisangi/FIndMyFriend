import 'package:findmyfriend/bloc/auth_bloc.dart';
import 'package:findmyfriend/models/pallete.dart';
import 'package:findmyfriend/screens/home_screen.dart';
import 'package:findmyfriend/widgets/gradient_button.dart';

import 'package:findmyfriend/widgets/login_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LOginScreenState();
}

class _LOginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (Route) => false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 70,
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    width: 200,
                    child: Image.asset(
                      'assets/images/logo.png',
                      color: Pallete.main,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: Pallete.main),
                  ),
                  const SizedBox(height: 30),
                  LoginField(
                    hintText: 'Email',
                    controller: emailController,
                    obscureText: false,
                  ),
                  const SizedBox(height: 15),
                  LoginField(
                    hintText: 'Password',
                    controller: passwordController,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  GradientButton(onPressed: () {
                    context.read<AuthBloc>().add(
                          AuthLoginRequested(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ),
                        );
                  })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
