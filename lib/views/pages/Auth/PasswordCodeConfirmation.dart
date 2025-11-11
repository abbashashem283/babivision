import 'package:babivision/Utils/Http.dart';
import 'package:babivision/views/debug/B.dart';
import 'package:babivision/views/forms/LaraForm.dart';
import 'package:babivision/views/pages/Auth/PasswordReset.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:babivision/views/forms/FormMessage.dart';
import 'package:babivision/views/forms/TextInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as services;

class PasswordCodeConfirmation extends StatefulWidget {
  final String email;
  final String origin;
  const PasswordCodeConfirmation({
    super.key,
    required this.email,
    required this.origin,
  });

  @override
  State<PasswordCodeConfirmation> createState() =>
      _PasswordCodeConfirmationState();
}

class _PasswordCodeConfirmationState extends State<PasswordCodeConfirmation> {
  GlobalKey<LaraformState> _formKey = GlobalKey<LaraformState>();
  final TextEditingController _pinController = TextEditingController();

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
    //_pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final _isKeyboardUp = _bottomInset > 0;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _setImmersiveMode();
        },
        child: Stack(
          children: [
            _isKeyboardUp
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

                        /* */
                        Laraform(
                          key: _formKey,
                          topMargin: 20,
                          topMarginIM: 20,
                          errorMessage: "Possible Network Error!",
                          fetcher:
                              () async =>
                                  Http.post("/api/auth/password/check-code", {
                                    "email": widget.email,
                                    "code": _pinController.text,
                                  }),
                          onError: (e) {},
                          onFetched: (response) {
                            if (response.statusCode == 200) {
                              Future.delayed(Duration(seconds: 2), () {
                                if (!mounted) return;
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder:
                                //         (context) => PasswordReset(
                                //           email: widget.email,
                                //           code: _pinController.text,
                                //         ),
                                //   ),
                                // );

                                // Navigator.pushReplacementNamed(
                                //   context,
                                //   "/password/reset",
                                //   arguments: {
                                //     "email": widget.email,
                                //     "code": _pinController.text,
                                //     "origin": widget.origin,
                                //   },
                                // );

                                Navigator.pushNamed(
                                  context,
                                  "/password/reset",
                                  arguments: {
                                    "email": widget.email,
                                    "code": _pinController.text,
                                    "origin": widget.origin,
                                  },
                                ).then((passwordReset) {
                                  if (mounted)
                                    Navigator.pop(context, passwordReset);
                                });
                              });
                            }
                          },
                          builder:
                              (_) => Column(
                                children: [
                                  Text(
                                    "Enter the code you received below",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  PinCodeTextField(
                                    appContext: context,
                                    length: 6,
                                    controller: _pinController,
                                    pinTheme: PinTheme(
                                      selectedColor: Colors.amber,
                                      activeColor: Colors.purple,
                                      inactiveColor: Colors.blue,
                                      shape: PinCodeFieldShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: FilledButton(
                                      onPressed: () {
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
                                        "Verify",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ) /* */,
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
