import 'package:babivision/Utils/Http.dart';
import 'package:babivision/data/KConstants.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;
import 'package:babivision/Utils/Widgets.dart' as w;

class PasswordChange extends StatefulWidget {
  final String origin;
  const PasswordChange({super.key, required this.origin});

  @override
  State<PasswordChange> createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {
  GlobalKey<LaraformState> _formKey = GlobalKey<LaraformState>();

  final TextEditingController _passwordController = TextEditingController();

  void _setImmersiveMode() {
    services.SystemChrome.setEnabledSystemUIMode(
      services.SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                        /*** */
                        Laraform(
                          key: _formKey,
                          topMargin: 30,
                          topMarginIM: 20,
                          fetcher: () async {
                            return Http.post("/api/auth/password/verify", {
                              'password': _passwordController.text,
                            });
                          },

                          onFetched: (response) {
                            //debugPrint(response.data.toString());
                            final data = response.data;
                            if (data["type"] == "success") {
                              Future.delayed(Duration(seconds: 2), () {
                                if (mounted) {
                                  Navigator.popUntil(
                                    context,
                                    ModalRoute.withName('/login'),
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
                                    labelText: "Enter Current Password",
                                    controller: _passwordController,
                                    errorText: errors("password"),
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
                                        "Change Password",
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
