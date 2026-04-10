import '../core/enums.dart';

class HistoryAction {
  final int? id;
  final OperationType operationType;
  final int operationId;
  final String action;
  final String actor;
  final String? comment;
  final DateTime timestamp;

  HistoryAction({
    this.id,
    required this.operationType,
    required this.operationId,
    required this.action,
    required this.actor,
    this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'operationType': operationType.name,
      'operationId': operationId,
      'action': action,
      'actor': actor,
      'comment': comment,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory HistoryAction.fromMap(Map<String, dynamic> map) {
    return HistoryAction(
      id: map['id'] as int?,
      operationType: OperationType.values.firstWhere(
        (e) => e.name == map['operationType'],
      ),
      operationId: map['operationId'] as int,
      action: map['action'] as String,
      actor: map['actor'] as String,
      comment: map['comment'] as String?,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
