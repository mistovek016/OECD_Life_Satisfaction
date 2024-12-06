import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oecd_app_dir/api/api_integration.dart';
import 'package:oecd_app_dir/constants.dart';
import 'package:oecd_app_dir/hive/chat_history.dart';
import 'package:oecd_app_dir/hive/chat_model.dart';
import 'package:oecd_app_dir/hive/profile_settings.dart';
import 'package:oecd_app_dir/models/message_model.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  List<MessageModel> chatMessages = [];

  final PageController pgController = PageController();

  List<XFile>? imgList = [];

  int screenIndex = 0;

  String chatId = '';

  GenerativeModel? genModel;

  GenerativeModel? txtModel;
  GenerativeModel? imgModel;

  String modelType = 'gemini-pro';

  bool isLoading = false;

  Future<void> setChatMessages({required String chatId}) async {
    final loadedChatMessages = await loadMessagesFromHive(chatId: chatId);

    for (var message in loadedChatMessages) {
      if (chatMessages.contains(message)) {
        log('Message exists already');
        continue;
      }

      chatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<MessageModel>> loadMessagesFromHive(
      {required String chatId}) async {
    await Hive.openBox((Constants.chatMessageBox) + chatId);

    final messageBox = Hive.box((Constants.chatMessageBox) + chatId);

    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      final messageData =
          MessageModel.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

  void setImageList({required List<XFile> image}) {
    imgList = image;
    notifyListeners();
  }

  String setCurrentModel({required String model}) {
    modelType = model;
    notifyListeners();
    return modelType;
  }

  Future<void> setModelTextOrNot({required bool isText}) async {
    genModel = isText
        ? txtModel ??
            GenerativeModel(
              model: setCurrentModel(model: 'gemini-pro'),
              apiKey: ApiIntegration.apiKey,
            )
        : imgModel ??
            GenerativeModel(
              model: setCurrentModel(model: 'gemini-pro-vision'),
              apiKey: ApiIntegration.apiKey,
            );
    notifyListeners();
  }

  void setScreenIndex({required int index}) {
    screenIndex = index;
    notifyListeners();
  }

  void setChatId({required String newId}) {
    chatId = newId;
    notifyListeners();
  }

  void setLoadingOrNot({required bool isLoading}) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  //send message to Gemini
  Future<void> sendMessage(
      {required String message, required bool textOnly}) async {
    await setModelTextOrNot(isText: textOnly);
    setLoadingOrNot(isLoading: true);
    String chatId = getChatId();
    List<Content> history = [];
    history = await getHistory(chatId: chatId);

    List<String> imgLinks = getImageLinks(textOnly: textOnly);

    final userMsg = MessageModel(
        messageId: '',
        chatId: chatId,
        role: Role.user,
        message: StringBuffer(message),
        imageLinks: imgLinks,
        timeStamp: DateTime.now());

    chatMessages.add(userMsg);
    notifyListeners();

    if (chatId.isEmpty) {
      setChatId(newId: chatId);
    }

    await sendMsgAndWait(
      message: message,
      chatId: chatId,
      isTextOnly: textOnly,
      history: history,
      userMessage: userMsg,
    );
  }

  Future<void> sendMsgAndWait({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required MessageModel userMessage,
  }) async {
    if (genModel == null) {
      log('genModel is null. Ensure setModelTextOrNot was called successfully.');
      await setModelTextOrNot(isText: true);
    }
    final chatSession = genModel!
        .startChat(history: history.isEmpty || !isTextOnly ? null : history);

    final content = await getContent(message: message, isTextOnly: isTextOnly);

    log('genModel: $genModel');
    log('imgList: $imgList');
    log('chatId: $chatId');
    if (genModel == null) {
      throw Exception(
          'imgList is null or empty. Add images before proceeding.');
    }

    final chatBotMessage = userMessage.copyWith(
      messageId: '',
      role: Role.chatbot,
      message: StringBuffer(),
      timeStamp: DateTime.now(),
    );

    chatMessages.add(chatBotMessage);
    notifyListeners();

    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen((event) {
      chatMessages
          .firstWhere((element) => element.role == Role.chatbot)
          .message
          .write(event.text);
      notifyListeners();
    }, onDone: () {
      //save msg to hive and set loading to false
      setLoadingOrNot(isLoading: false);
    }).onError((error, stackTrace) {
      setLoadingOrNot(isLoading: false);
    });
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = imgList
          ?.map((imageFile) => imageFile.readAsBytes())
          .toList(growable: false);

      final imageBytes = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpg', Uint8List.fromList(bytes)))
          .toList();

      return Content.model([prompt, ...imageParts]);
    }
  }

  List<String> getImageLinks({required bool textOnly}) {
    List<String> imgLinks = [];

    if (!textOnly && imgList != null) {
      for (var image in imgList!) {
        imgLinks.add(image.path);
      }
    }

    return imgLinks;
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (chatId.isNotEmpty) {
      await setChatMessages(chatId: chatId);

      for (var message in chatMessages) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }

    return history;
  }

  String getChatId() {
    if (chatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return chatId;
    }
  }

  static initHive() async {
    final directory = await path.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.initFlutter(Constants.geminiDatabase);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());
      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ChatModelAdapter());
      await Hive.openBox<ChatModel>(Constants.chatModelBox);
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(ProfileSettingsAdapter());
      await Hive.openBox<ProfileSettings>(Constants.profileSettingsBox);
    }
  }
}
