// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileSettingsAdapter extends TypeAdapter<ProfileSettings> {
  @override
  final int typeId = 2;

  @override
  ProfileSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileSettings(
      darkOrNot: fields[0] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileSettings obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.darkOrNot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
