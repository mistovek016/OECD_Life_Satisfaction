import 'package:flutter/material.dart';
import 'package:oecd_app_dir/providers/chat_provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.chatProvider,
  });

  final ChatProvider chatProvider;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  final TextEditingController textEditingController = TextEditingController();

  final FocusNode textFieldFocus = FocusNode();

  @override
  void dispose() {
    textEditingController.dispose();
    textFieldFocus.dispose();
    super.dispose();
  }

  Future<void> sendMessage(
      {required String message,
      required ChatProvider chatProvider,
      required bool textOnly}) async {
    //try {
    await chatProvider.sendMessage(message: message, textOnly: textOnly);
    //} catch (e) {
    //  log('Error found: $e');
    //} finally {
    textEditingController.clear();
    textFieldFocus.unfocus();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.6),
        //     spreadRadius: 5,
        //     blurRadius: 7,
        //     offset: const Offset(0, 3),
        //   )
        // ],
        border: Border.all(
          color: Theme.of(context).textTheme.titleLarge!.color!,
        ),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                //select image
              },
              icon: const Icon(Icons.image)),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
              focusNode: textFieldFocus,
              controller: textEditingController,
              textInputAction: TextInputAction.send,
              onSubmitted: (String value) {
                if (value.isNotEmpty) {
                  sendMessage(
                      message: textEditingController.text,
                      chatProvider: widget.chatProvider,
                      textOnly: true);
                }
              },
              decoration: InputDecoration.collapsed(
                  hintText: 'Enter a prompt',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  )),
            ),
          ),
          GestureDetector(
            onTap: () {
              //send message
              if (textEditingController.text.isNotEmpty) {
                sendMessage(
                    message: textEditingController.text,
                    chatProvider: widget.chatProvider,
                    textOnly: true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(5.0),
              child: const Padding(
                padding: EdgeInsets.all(7.5),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
