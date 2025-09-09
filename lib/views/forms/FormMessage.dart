/*import 'package:babivision/views/debug/B.dart';
import 'package:flutter/material.dart';

enum MessageType { success, error, warning }

class FormMessage extends StatelessWidget {
  final MessageType type;
  final int? httpCode;
  final List messages;

  const FormMessage({
    super.key,
    this.type = MessageType.success,
    this.httpCode = -1,
    required this.messages,
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

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children:
              messages
                  .map(
                    (message) => Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 5,
                      children: [
                        Icon(messageIcon, color: textColor),
                        Flexible(
                          child: Text(
                            message,
                            style: TextStyle(color: textColor, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}*/
