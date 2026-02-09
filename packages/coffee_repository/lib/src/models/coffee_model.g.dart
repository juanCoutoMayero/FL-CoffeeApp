// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coffee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoffeeModelAdapter extends TypeAdapter<CoffeeModel> {
  @override
  final int typeId = 0;

  @override
  CoffeeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CoffeeModel(
      file: fields[0] as String,
      localPath: fields[1] as String?,
      savedDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CoffeeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.file)
      ..writeByte(1)
      ..write(obj.localPath)
      ..writeByte(2)
      ..write(obj.savedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoffeeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoffeeModel _$CoffeeModelFromJson(Map<String, dynamic> json) => CoffeeModel(
      file: json['file'] as String,
      localPath: json['localPath'] as String?,
      savedDate: json['savedDate'] == null
          ? null
          : DateTime.parse(json['savedDate'] as String),
    );

Map<String, dynamic> _$CoffeeModelToJson(CoffeeModel instance) =>
    <String, dynamic>{
      'file': instance.file,
      'localPath': instance.localPath,
      'savedDate': instance.savedDate?.toIso8601String(),
    };
