import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/storage/SecureStorage.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  const Playground({super.key});

  @override
  State<Playground> createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<LaraformState> formKey = GlobalKey<LaraformState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: B(
          color: "g",
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Laraform(
                key: formKey,
                builder:
                    (errors) => Column(
                      children: [
                        TextInput(
                          labelText: "Name",
                          controller: _nameController,
                          errorText: formKey.currentState?.getError("name"),
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          labelText: "Email",
                          errorText: formKey.currentState?.getError("email"),
                          controller: _emailController,
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          obscureText: true,
                          labelText: "Password",
                          errorText: formKey.currentState?.getError("password"),
                          controller: _passwordController,
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          obscureText: true,
                          labelText: "Confirm Password",
                          errorText: formKey.currentState?.getError(
                            "confirm_password",
                          ),
                          controller: _confirmPasswordController,
                        ),
                        FilledButton(
                          onPressed: () {
                            formKey.currentState!.submit();
                          },
                          child: Text("submit"),
                        ),
                      ],
                    ),
                fetcher: () async {
                  return Http.post("/api/auth/test", {
                    "name": _nameController.text,
                    "email": _emailController.text,
                    "password": _passwordController.text,
                    "confirm_password": _confirmPasswordController.text,
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
