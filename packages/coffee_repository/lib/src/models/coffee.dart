import 'package:equatable/equatable.dart';

/// {@template coffee}
/// A pure Dart class representing a Coffee entity.
/// {@endtemplate}
class Coffee extends Equatable {
  /// {@macro coffee}
  const Coffee({
    required this.file,
    this.localPath,
    this.savedDate,
  });

  /// The URL of the coffee image.
  final String file;

  /// The local file path if the coffee image is saved for offline access.
  final String? localPath;

  /// The date when the coffee was saved as favorite.
  final DateTime? savedDate;

  /// Whether the coffee image is stored locally.
  bool get isLocal => localPath != null;

  @override
  List<Object?> get props => [file, localPath, savedDate];
}
