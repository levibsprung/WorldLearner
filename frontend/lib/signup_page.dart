import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/card_result.dart';
import 'package:frontend/choose_button.dart';

import 'app_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontFamily: "Schyler",
                  fontSize: 50.0,
                ),
              ),
              const SizedBox(height: 30.0),
              const InpField(placeholder: "Username"),
              const SizedBox(height: 20.0),
              const InpField(
                placeholder: "Password",
              ),
              const SizedBox(height: 20.0),
              ChooseButton(buttonTitle: "Continue", onPressed: () {}),
              const SizedBox(height: 10.0),
              TextButton(
                child: Text("Sign Up", style: TextStyle(fontSize: 15.0)),
                onPressed: () {},
              )
            ]),
      ),
    );
  }
}

class InpField extends StatelessWidget {
  final String placeholder;

  const InpField({
    super.key,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextField(
        autofocus: false,
        style: TextStyle(fontSize: 20.0, color: Colors.grey.shade800),
        decoration: InputDecoration(
          hintText: placeholder,
          filled: true,
          fillColor: Colors.grey.shade300,
          contentPadding: const EdgeInsets.only(
            left: 30.0,
            bottom: 16.0,
            top: 29.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
