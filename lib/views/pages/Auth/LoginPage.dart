import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
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
                    child: B(
                      color: "tr",
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
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                              ),
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
                          SizedBox(height: 30),
                          FormMessage(
                            type: MessageType.error,
                            messages: [
                              "Password is required",
                              "Email is required",
                            ],
                          ),
                          SizedBox(height: 35),
                          TextInput(labelText: "Email"),
                          SizedBox(height: 15),
                          TextInput(obscureText: true, labelText: "Password"),
                          SizedBox(height: 35),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.all(15),
                              ),
                              child: Text(
                                "Login",
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
            ),
          ],
        ),
      ),
    );
  }
}
