import 'package:babivision/views/forms/FormMessage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum LFMethod { get, post }

class Laraform extends StatefulWidget {
  //A Simple form wrapper that works well with laravel validations

  final Widget Function(String? Function(String) errorGetter) builder;
  final Widget waitingIndicator;
  final String? errorMessage;
  final double? topMargin;
  final double? topMarginIM;
  final Future<Response<dynamic>> Function() fetcher;
  final Function() onSuccess;
  final Function()? onError;
  final Function()? onValidationError;
  const Laraform({
    required GlobalKey<LaraformState> key,
    this.waitingIndicator = const CircularProgressIndicator(),
    this.errorMessage = "Error: Couldn't proccess form",
    this.topMargin = 0, //form top space that changes with state
    this.topMarginIM =
        0, //form top space when form is loading or showing message
    this.onError,
    this.onValidationError,
    required this.builder,
    required this.fetcher,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<Laraform> createState() => LaraformState();
}

class LaraformState extends State<Laraform> {
  bool isLoading = false, isDone = false, isError = false;
  Map<String, dynamic>? errors;
  Response<dynamic>? response;

  Future<void> submit() async {
    try {
      setState(() {
        isLoading = true;
        isDone = false;
        isError = false;
      });
      response = await widget.fetcher();
      debugPrint(response?.data.toString());
      setState(() {
        isLoading = false;
        isDone = true;
        isError = false;
        errors = response!.data?["errors"];
      });
      if (errors == null) {
        widget.onSuccess();
      } else if (widget.onValidationError != null) {
        widget.onValidationError!();
      }
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
        isDone = false;
        isError = true;
        errors = null;
      });
      if (widget.onError != null) {
        widget.onError!();
      }
    }
  }

  String? getError(String key) {
    return errors?[key]?[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height:
              (isLoading || (isDone && errors == null) || isError)
                  ? widget.topMarginIM
                  : widget.topMargin,
        ),
        isLoading
            ? widget.waitingIndicator
            : isDone
            ? errors != null
                ? SizedBox.shrink()
                : FormMessage(messages: [response!.data!["message"]])
            : isError
            ? FormMessage(
              messages: [widget.errorMessage],
              type: MessageType.error,
            )
            : SizedBox.shrink(),
        SizedBox(
          height: (isLoading || (isDone && errors == null) || isError) ? 30 : 0,
        ),
        widget.builder(getError),
      ],
    );
  }
}
