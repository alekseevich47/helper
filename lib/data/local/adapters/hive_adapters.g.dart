// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class CallRecordAdapter extends TypeAdapter<CallRecord> {
  @override
  final typeId = 0;

  @override
  CallRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallRecord(
      id: fields[0] as String,
      phoneNumber: fields[1] as String?,
      contactName: fields[2] as String?,
      dateTime: fields[3] as DateTime,
      durationSeconds: (fields[4] as num).toInt(),
      audioFilePath: fields[5] as String?,
      transcriptionText: fields[6] as String?,
      summaryText: fields[7] as String?,
      status: fields[8] as String,
      processedAt: fields[9] as DateTime?,
      syncedToServer: fields[10] == null ? false : fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CallRecord obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.contactName)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(4)
      ..write(obj.durationSeconds)
      ..writeByte(5)
      ..write(obj.audioFilePath)
      ..writeByte(6)
      ..write(obj.transcriptionText)
      ..writeByte(7)
      ..write(obj.summaryText)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.processedAt)
      ..writeByte(10)
      ..write(obj.syncedToServer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CallEventAdapter extends TypeAdapter<CallEvent> {
  @override
  final typeId = 1;

  @override
  CallEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CallEvent(
      id: fields[0] as String,
      callId: fields[1] as String,
      type: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String?,
      eventDateTime: fields[5] as DateTime?,
      isCompleted: fields[6] == null ? false : fields[6] as bool,
      notificationId: (fields[7] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, CallEvent obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.callId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.eventDateTime)
      ..writeByte(6)
      ..write(obj.isCompleted)
      ..writeByte(7)
      ..write(obj.notificationId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 2;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      createdAt: fields[3] as DateTime,
      updatedAt: fields[4] as DateTime,
      linkedCallId: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.linkedCallId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppSettingsAdapter extends TypeAdapter<AppSettings> {
  @override
  final typeId = 3;

  @override
  AppSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSettings(
      autoTranscribe: fields[0] == null ? false : fields[0] as bool,
      themeMode: fields[1] == null ? 'system' : fields[1] as String,
      language: fields[2] == null ? 'ru' : fields[2] as String,
      whisperModel: fields[3] == null ? 'turbo' : fields[3] as String,
      notifyBeforeTranscribe: fields[4] == null ? true : fields[4] as bool,
      userId: fields[5] as String?,
      authToken: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.autoTranscribe)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.whisperModel)
      ..writeByte(4)
      ..write(obj.notifyBeforeTranscribe)
      ..writeByte(5)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.authToken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
