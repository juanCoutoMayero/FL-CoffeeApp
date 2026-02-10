import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_model.g.dart';

/// {@template coffee_model}
/// A model for Coffee with Hive and JSON support.
/// {@endtemplate}
@HiveType(typeId: 0)
@JsonSerializable()
class CoffeeModel extends Equatable {
  /// {@macro coffee_model}
  const CoffeeModel({required this.file, this.localPath, this.savedDate});

  @HiveField(0)
  final String file;

  @HiveField(1)
  final String? localPath;

  @HiveField(2)
  final DateTime? savedDate;

  /// Factory which converts a [Map<String, dynamic>] into a [CoffeeModel].
  factory CoffeeModel.fromJson(Map<String, dynamic> json) =>
      _$CoffeeModelFromJson(json);

  /// Converts this [CoffeeModel] into a [Map<String, dynamic>].
  Map<String, dynamic> toJson() => _$CoffeeModelToJson(this);

  /// Creates a copy of [CoffeeModel] with updated fields.
  CoffeeModel copyWith({String? file, String? localPath, DateTime? savedDate}) {
    return CoffeeModel(
      file: file ?? this.file,
      localPath: localPath ?? this.localPath,
      savedDate: savedDate ?? this.savedDate,
    );
  }

  @override
  List<Object?> get props => [file, localPath, savedDate];
}
