import 'package:findmyfriend/models/pallete.dart';
import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {

  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  const LoginField({super.key, required this.hintText, required this.controller,this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(constraints: const BoxConstraints(maxHeight: 400),
    child: TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(27),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Pallete.main,width: 4),
          borderRadius: BorderRadius.circular(50),
        ),
        hintText: hintText,
         hintStyle: TextStyle(
              color: Pallete.main,
              fontSize: 16, 
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold
            ),
      ),
    ),
    );
  }
}