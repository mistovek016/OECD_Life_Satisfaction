import 'package:hive/hive.dart';
import 'package:oecd_app_dir/constants.dart';
import 'package:oecd_app_dir/hive/chat_history.dart';
import 'package:oecd_app_dir/hive/chat_model.dart';
import 'package:oecd_app_dir/hive/profile_settings.dart';

class ChatHisBoxes {
  static Box<ChatHistory> getChatHistory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

  static Box<ChatModel> getChatModel() =>
      Hive.box<ChatModel>(Constants.chatModelBox);

  static Box<ProfileSettings> getProfileSettings() =>
      Hive.box<ProfileSettings>(Constants.profileSettingsBox);
}
