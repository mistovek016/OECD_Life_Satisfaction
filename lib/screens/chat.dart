import 'package:flutter/material.dart';
import 'package:oecd_app_dir/models/message_model.dart';
import 'package:oecd_app_dir/providers/chat_provider.dart';
import 'package:oecd_app_dir/widgets/bottom_chat_field.dart';
import 'package:oecd_app_dir/widgets/chatbot_message_widget.dart';
import 'package:oecd_app_dir/widgets/user_message_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(builder: (context, chatProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          title: const Text("AI Chat"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                    child: chatProvider.chatMessages.isEmpty
                        ? const Center(child: Text('No messages'))
                        : ListView.builder(
                            itemCount: chatProvider.chatMessages.length,
                            itemBuilder: (context, index) {
                              final message = chatProvider.chatMessages[index];
                              return message.role == Role.user
                                  ? UserMessageWidget(message: message)
                                  : ChatbotMessageWidget(
                                      message: message.message.toString());
                            })),
                BottomChatField(chatProvider: chatProvider)
              ],
            ),
          ),
        ),
      );
    });
  }
}
