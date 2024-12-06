import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatbotMessageWidget extends StatelessWidget {
  const ChatbotMessageWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        child: message.isEmpty
            ? const SizedBox(
                width: 50,
                child: SpinKitThreeInOut(
                  color: Colors.indigo,
                  size: 20,
                ))
            : MarkdownBody(
                data: message,
                selectable: true,
              ),
      ),
    );
  }
}
