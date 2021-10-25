// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_folder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoFolderAdapter extends TypeAdapter<TodoFolder> {
  @override
  final int typeId = 1;

  @override
  TodoFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TodoFolder(
      iconDataCodePoint: fields[3] as int?,
      name: fields[1] as String?,
      todos: (fields[2] as HiveList?)?.castHiveList(),
      iconColorValue: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, TodoFolder obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.todos)
      ..writeByte(3)
      ..write(obj.iconDataCodePoint)
      ..writeByte(5)
      ..write(obj.iconColorValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoFolderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
