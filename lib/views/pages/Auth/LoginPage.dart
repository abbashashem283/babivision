import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:babivision/views/pages/Auth/PasswordCodeConfirmation.dart';
import 'package:babivision/views/pages/Auth/PasswordReset.dart';
import 'package:flutter/material.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:flutter/services.dart' as services;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  GlobalKey<LaraformState> _formKey = GlobalKey<LaraformState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool forgotPassword = false;

  void _setImmersiveMode() {
    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _setImmersiveMode();
    super.initState();
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
                        Laraform(
                          key: _formKey,
                          topMargin: 30,
                          topMarginIM: 20,
                          errorMessage: "Possible Network Error!",
                          fetcher: () async {
                            return Http.post("/api/auth/test", {
                              "email": _emailController.text,
                              "password": _passwordController.text,
                            });
                          },
                          onSuccess:
                              () => debugPrint("Sending you to some page"),
                          builder:
                              (errors) => Column(
                                children: [
                                  TextInput(
                                    labelText: "Email",
                                    controller: _emailController,
                                    errorText: errors("email"),
                                  ),
                                  SizedBox(height: 15),
                                  if (!forgotPassword)
                                    TextInput(
                                      obscureText: true,
                                      labelText: "Password",
                                      controller: _passwordController,
                                      errorText: errors("password"),
                                    ),
                                  SizedBox(height: forgotPassword ? 0 : 15),

                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        forgotPassword = !forgotPassword;
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: KColors.getColor(
                                          context,
                                          "primary",
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      forgotPassword
                                          ? "Remember Password?"
                                          : "Forgot Password?",
                                    ),
                                  ),
                                  SizedBox(height: forgotPassword ? 15 : 35),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () {
                                        FocusScope.of(context).unfocus();
                                        if (forgotPassword) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      PasswordCodeConfirmation(),
                                            ),
                                          );
                                          return;
                                        }
                                        _formKey.currentState!.submit();
                                      },
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(15),
                                      ),
                                      child: Text(
                                        forgotPassword
                                            ? "Send Password Reset Code"
                                            : "Login",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
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
