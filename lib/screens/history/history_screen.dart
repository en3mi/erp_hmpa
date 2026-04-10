import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/erp_provider.dart';
import '../../widgets/app_formatters.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<ErpProvider>().history;
    return ListView.builder(
      itemCount: history.length,
      itemBuilder: (_, i) {
        final h = history[i];
        return ListTile(
          title: Text('${h.operationType.name} #${h.operationId} - ${h.action}'),
          subtitle: Text('${h.actor} • ${formatDate(h.timestamp)} ${h.comment ?? ''}'),
        );
      },
    );
  }
}
