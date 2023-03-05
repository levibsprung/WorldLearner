import 'package:flutter/material.dart';
import 'package:frontend/choose_button.dart';
import 'package:frontend/realm/app_services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

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
              'Sign In',
              style: TextStyle(
                fontFamily: "Schyler",
                fontSize: 50.0,
              ),
            ),
            const SizedBox(height: 30.0),
            InpField(
              placeholder: "Email",
              controller: _emailController,
            ),
            const SizedBox(height: 20.0),
            InpField(
              placeholder: "Password",
              password: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 20.0),
            ChooseButton(
              buttonTitle: "Continue",
              onPressed: _loginUser,
            ),
            const SizedBox(height: 10.0),
            TextButton(
              child: const Text("Sign Up", style: TextStyle(fontSize: 15.0)),
              onPressed: _loginUser,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _loginUser() async {
    try {
      final appServices = Provider.of<AppServices>(context, listen: false);
      await appServices.logInUserEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      Navigator.pushNamed(context, '/');
    } catch (err) {
      print(err);
      setState(() {
        // _errorMessage = err.toString();
        final snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text(err.toString()),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }
}

class InpField extends StatelessWidget {
  final String placeholder;
  final bool password;
  final TextEditingController controller;

  const InpField({
    super.key,
    required this.placeholder,
    required this.controller,
    this.password = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.0,
      child: TextField(
        controller: controller,
        autofocus: false,
        obscureText: password,
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
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
