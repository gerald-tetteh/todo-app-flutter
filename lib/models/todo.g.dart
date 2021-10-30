// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodoAdapter extends TypeAdapter<Todo> {
  @override
  final int typeId = 2;

  @override
  Todo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todo(
      title: fields[0] as String?,
      notes: fields[1] as String?,
      imagePath: fields[2] as String?,
      priority: fields[3] as Priority,
      dateCreated: fields[4] as DateTime?,
      setAlarm: fields[5] as bool,
      alarmDateTime: fields[7] as DateTime?,
      completed: fields[9] as bool,
      notificationId: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Todo obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.dateCreated)
      ..writeByte(5)
      ..write(obj.setAlarm)
      ..writeByte(7)
      ..write(obj.alarmDateTime)
      ..writeByte(9)
      ..write(obj.completed)
      ..writeByte(10)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
