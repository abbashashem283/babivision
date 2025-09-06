import 'package:babivision/views/forms/FormMessage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum LFMethod { get, post }

class Laraform extends StatefulWidget {
  //A Simple form wrapper that works well with laravel validations

  final Widget Function(String? Function(String) errorGetter) builder;
  final Widget waitingIndicator;
  final String? errorMessage;
  final Future<Response<dynamic>> Function() fetcher;
  const Laraform({
    required GlobalKey<LaraformState> key,
    this.waitingIndicator = const CircularProgressIndicator(),
    this.errorMessage = "Error: Couldn't proccess form",
    required this.builder,
    required this.fetcher,
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
      setState(() {
        isLoading = false;
        isDone = true;
        isError = false;
        errors = response!.statusCode == 422 ? response!.data["errors"] : null;
        debugPrint("${errors!["name"]}");
      });
    } catch (_) {
      setState(() {
        isLoading = false;
        isDone = false;
        isError = true;
        errors = null;
      });
    }
  }

  String? getError(String key) {
    return errors?[key]?[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(height: 30),
        widget.builder(getError),
      ],
    );
  }
}
