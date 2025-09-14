// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_offline_bookmarked_movies.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OfflineBookmarkedHiveModelAdapter
    extends TypeAdapter<OfflineBookmarkedHiveModel> {
  @override
  final int typeId = 5;

  @override
  OfflineBookmarkedHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OfflineBookmarkedHiveModel(
      id: fields[0] as int?,
      isBookmarked: fields[1] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, OfflineBookmarkedHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OfflineBookmarkedHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
