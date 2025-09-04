import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isLoading = false, isDone = false, isError = false;
  dynamic responseData;

  Future<dynamic>? fetcher;
  Map<String, dynamic>? errors;

  void _setImmersiveMode() {
    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.immersiveSticky,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    _setImmersiveMode();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardUp = bottomInset > 0;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _setImmersiveMode();
        },
        child: Stack(
          children: [
            isKeyboardUp
                ? SizedBox.shrink()
                : Image.asset(
                  "assets/screens/wavy.png",
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
            Container(
              padding: EdgeInsets.all(30),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      //spacing: 10,
                      children: [
                        Image.asset(
                          'assets/images/babivision-logo.png',
                          width: 150,
                          height: 75,
                          fit: BoxFit.fill,
                        ),

                        RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.black, fontSize: 32),
                            children: [
                              TextSpan(
                                text: "Babi",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "Vision",
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        isLoading
                            ? CircularProgressIndicator(color: Colors.purple)
                            : isDone
                            ? errors != null
                                ? SizedBox.shrink()
                                : FormMessage(messages: [responseData])
                            : isError
                            ? FormMessage(
                              messages: ["Error: Couldn't proccess form"],
                              type: MessageType.error,
                            )
                            : SizedBox.shrink(),
                        SizedBox(height: 30),
                        TextInput(
                          labelText: "Name",
                          controller: _nameController,
                          errorText: errors?["name"]?[0],
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          labelText: "Email",
                          errorText: errors?["email"]?[0],
                          controller: _emailController,
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          obscureText: true,
                          labelText: "Password",
                          errorText: errors?["password"]?[0],
                          controller: _passwordController,
                        ),
                        SizedBox(height: 15),
                        TextInput(
                          obscureText: true,
                          labelText: "Confirm Password",
                          errorText: errors?["confirm_password"]?[0],
                          controller: _confirmPasswordController,
                        ),
                        SizedBox(height: 35),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                isLoading = true;
                                isDone = false;
                                isError = false;
                              });
                              try {
                                Response<dynamic> response =
                                    await Http.post("/api/auth/test", {
                                      "name": _nameController.text,
                                      "email": _emailController.text,
                                      "password": _passwordController.text,
                                      "confirm_password":
                                          _confirmPasswordController.text,
                                    });
                                //responseData = response.data["message"];
                                setState(() {
                                  errors = null;
                                  isLoading = false;
                                  isDone = true;
                                  if (response.statusCode == 422) {
                                    errors = response.data["errors"];
                                  }
                                  isError = false;
                                  responseData = response.data["message"];
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                  isDone = false;
                                  isError = true;
                                });
                              }
                            },
                            style: FilledButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.all(15),
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
