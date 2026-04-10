import 'package:flutter/material.dart';

import '../core/enums.dart';

class StatusChip extends StatelessWidget {
  final OperationStatus status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case OperationStatus.pending:
        color = Colors.orange;
        break;
      case OperationStatus.approved:
        color = Colors.green;
        break;
      case OperationStatus.rejected:
        color = Colors.red;
        break;
    }
    return Chip(
      label: Text(status.label, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
    );
  }
}
