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
          child: SizedBox(
            width: 500,
            height: 500,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: B(
                  color: "r",
                  child: Center(
                    child: B(
                      color: "o",
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.visibility, size: 56),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
