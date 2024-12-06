import 'package:hive_flutter/hive_flutter.dart';

part 'profile_settings.g.dart';

@HiveType(typeId: 2)
class ProfileSettings extends HiveObject {
  @HiveField(0)
  bool darkOrNot = false;

  ProfileSettings({required this.darkOrNot});
}
