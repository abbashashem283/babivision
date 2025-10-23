import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:babivision/Utils/Widgets.dart' as w;

class PasswordReset extends StatefulWidget {
  final String email;
  final String code;
  final String origin;
  const PasswordReset({
    super.key,
    required this.email,
    required this.code,
    required this.origin,
  });

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  GlobalKey<LaraformState> _formKey = GlobalKey<LaraformState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _setImmersiveMode() {
    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                        /*** */
                        Laraform(
                          key: _formKey,
                          topMargin: 30,
                          topMarginIM: 20,
                          fetcher:
                              () async =>
                                  Http.post("/api/auth/password/reset", {
                                    "email": widget.email,
                                    "code": widget.code,
                                    "password": _passwordController.text,
                                    "confirm_password":
                                        _confirmPasswordController.text,
                                  }),
                          onFetched: (response) {
                            //debugPrint(response.data.toString());
                            final data = response.data;
                            if (data["type"] == "success") {
                              Future.delayed(Duration(seconds: 2), () {
                                if (mounted) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    "/login",
                                    arguments: {
                                      "origin": widget.origin,
                                      "redirect": widget.origin,
                                    },
                                  );
                                }
                              });
                            }
                          },
                          builder:
                              (errors) => Column(
                                children: [
                                  TextInput(
                                    obscureText: true,
                                    labelText: "New Password",
                                    controller: _passwordController,
                                    errorText: errors("password"),
                                  ),
                                  SizedBox(height: 15),
                                  TextInput(
                                    obscureText: true,
                                    labelText: "Confirm New Password",
                                    controller: _confirmPasswordController,
                                    errorText: errors("confirm_password"),
                                  ),
                                  // SizedBox(height: 15),
                                  SizedBox(height: 35),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () {
                                        w.unfocus(context);
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
                                        "Reset Password",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ),

                        /** */
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
