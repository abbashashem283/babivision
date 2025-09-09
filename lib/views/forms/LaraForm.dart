import 'package:babivision/views/debug/B.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum LFMethod { get, post }

enum MessageType { success, error, warning }

class FormMessage extends StatelessWidget {
  final MessageType type;
  final int? httpCode;
  final String? message;

  const FormMessage({
    super.key,
    this.type = MessageType.success,
    this.httpCode = -1,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor, textColor;
    IconData messageIcon;
    MessageType type = this.type;

    if (httpCode != -1) {
      switch (httpCode) {
        case 200:
          type = MessageType.success;
          break;
        default:
          type = MessageType.error;
      }
    }

    switch (type) {
      case MessageType.success:
        backgroundColor = Colors.green[100]!;
        textColor = Colors.green;
        messageIcon = Icons.check_circle_outline;
        break;
      case MessageType.error:
        backgroundColor = Colors.red[100]!;
        textColor = Colors.red;
        messageIcon = Icons.error_outline;
        break;
      case MessageType.warning:
        backgroundColor = Colors.amber[100]!;
        textColor = const Color.fromARGB(255, 228, 172, 5);
        messageIcon = Icons.warning_amber_rounded;
        break;
    }

    return message == null
        ? SizedBox.shrink()
        : Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Icon(messageIcon, color: textColor),
                Flexible(
                  child: Text(
                    message!,
                    style: TextStyle(color: textColor, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
  }
}

class Laraform extends StatefulWidget {
  //A Simple form wrapper that works well with laravel validations

  final Widget Function(String? Function(String) errorGetter) builder;
  final Widget waitingIndicator;
  final String? errorMessage;
  final double? topMargin;
  final double? topMarginIM;
  final Future<Response<dynamic>> Function() fetcher;
  final Function(Response<dynamic> response) onSuccess;
  final Function(Object e)? onError;
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
    required this.fetcher,
    required this.onSuccess,
    required this.builder,
  }) : super(key: key);

  @override
  State<Laraform> createState() => LaraformState();
}

class LaraformState extends State<Laraform> {
  bool isLoading = false, isDone = false, isError = false;
  Map<String, dynamic>? errors;
  Response<dynamic>? response;
  String? userMessage;
  MessageType? userMessageType;

  bool _codeIsOK(int? httpCode) {
    if (httpCode == null) return false;
    return httpCode > 199 && httpCode < 300;
  }

  Future<void> submit() async {
    if (isLoading) return;
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
        Map<String, dynamic>? userData = widget.onSuccess(response!);
        userMessage = userData?["message"];
        userMessageType = userData?["type"];
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
        Map<String, dynamic>? userData = widget.onError!(e);
        userMessage = userData?["message"];
        debugPrint("hererreerer");
        debugPrint(e.toString());
      }
    }
  }

  String? getError(String key) {
    return errors?[key]?[0];
  }

  bool _isLoadingOrMessage() {
    final message = _getMessage()?["message"];
    //errors null check cz laravel validation errors also send a "message"
    return (message != null || isLoading) && errors == null;
  }

  Map<String, dynamic>? _getMessage() {
    if (isError) {
      return {"message": userMessage ?? widget.errorMessage};
    }
    if (!isDone) return null;
    if (userMessage == null) {
      final autoType =
          _codeIsOK(response?.statusCode)
              ? MessageType.success
              : MessageType.error;
      return {
        "message": response!.data?["message"],
        "type": userMessageType ?? autoType,
      };
    }
    userMessageType ??= MessageType.success;
    return {"message": userMessage, "type": userMessageType};
  }

  @override
  Widget build(BuildContext context) {
    final message = _getMessage()?["message"];
    final messageType = _getMessage()?["type"] ?? MessageType.success;
    return Column(
      children: [
        SizedBox(
          height: _isLoadingOrMessage() ? widget.topMarginIM : widget.topMargin,
        ),

        isLoading
            ? widget.waitingIndicator
            : isDone
            ? errors != null
                ? SizedBox.shrink()
                : FormMessage(message: message, type: messageType)
            : isError
            ? FormMessage(message: message, type: MessageType.error)
            : SizedBox.shrink(),
        SizedBox(
          height: _isLoadingOrMessage() || isLoading && errors != null ? 30 : 0,
        ),
        widget.builder(getError),
      ],
    );
  }
}
