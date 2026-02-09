import 'package:coffee_repository/src/models/coffee.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_model.g.dart';

/// {@template coffee_model}
/// A model for Coffee with Hive and JSON support.
/// {@endtemplate}
@HiveType(typeId: 0)
@JsonSerializable()
class CoffeeModel extends Coffee {
  /// {@macro coffee_model}
  const CoffeeModel({
    required this.file,
    this.localPath,
    this.savedDate,
  }) : super(file: file, localPath: localPath, savedDate: savedDate);

  @override
  @HiveField(0)
  final String file;

  @override
  @HiveField(1)
  final String? localPath;

  @override
  @HiveField(2)
  final DateTime? savedDate;

  /// Factory which converts a [Map<String, dynamic>] into a [CoffeeModel].
  factory CoffeeModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeModelFromJson(json);

  /// Converts this [CoffeeModel] into a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$CoffeeModelToJson(this);

  /// Creates a [CoffeeModel] from a [Coffee] entity.
  factory CoffeeModel.fromEntity(Coffee coffee) {
    return CoffeeModel(
      file: coffee.file,
      localPath: coffee.localPath,
      savedDate: coffee.savedDate,
    );
  }
}
