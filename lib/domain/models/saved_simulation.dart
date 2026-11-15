import 'package:equatable/equatable.dart';

enum SimulationKind { riskClock, panic }

/// A simulation result saved by the user (see "Saved" screen).
class SavedSimulation extends Equatable {
  const SavedSimulation({
    required this.id,
    required this.kind,
    required this.title,
    required this.createdAt,
    required this.payload,
  });

  final int id;
  final SimulationKind kind;
  final String title;
  final DateTime createdAt;

  /// Free-form key/value summary displayed in the details sheet.
  final Map<String, String> payload;

  @override
  List<Object?> get props => [id];
}
