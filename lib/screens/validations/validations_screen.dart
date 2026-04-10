import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../providers/auth_provider.dart';
import '../../providers/erp_provider.dart';
import '../../widgets/status_chip.dart';

class ValidationsScreen extends StatelessWidget {
  const ValidationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final erp = context.watch<ErpProvider>();
    final boss = context.watch<AuthProvider>().currentUser!;
    final pendingPurchases = erp.purchases.where((p) => p.status == OperationStatus.pending);
    final pendingSales = erp.sales.where((s) => s.status == OperationStatus.pending);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('Achats en attente', style: TextStyle(fontWeight: FontWeight.bold)),
        ...pendingPurchases.map(
          (p) => Card(
            child: ListTile(
              title: Text('${p.reference} - ${p.supplier}'),
              subtitle: Text(p.description),
              trailing: StatusChip(status: p.status),
              onTap: () => _showDialog(context, onApprove: (comment) {
                erp.validatePurchase(purchase: p, approve: true, validator: boss, comment: comment);
              }, onReject: (comment) {
                erp.validatePurchase(purchase: p, approve: false, validator: boss, comment: comment);
              }),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Text('Ventes en attente', style: TextStyle(fontWeight: FontWeight.bold)),
        ...pendingSales.map(
          (s) => Card(
            child: ListTile(
              title: Text('${s.reference} - ${s.client}'),
              subtitle: Text(s.description),
              trailing: StatusChip(status: s.status),
              onTap: () => _showDialog(context, onApprove: (comment) {
                erp.validateSale(sale: s, approve: true, validator: boss, comment: comment);
              }, onReject: (comment) {
                erp.validateSale(sale: s, approve: false, validator: boss, comment: comment);
              }),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDialog(
    BuildContext context, {
    required ValueChanged<String> onApprove,
    required ValueChanged<String> onReject,
  }) async {
    final ctrl = TextEditingController();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Validation opération'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Commentaire optionnel'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              onReject(ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('Rejeter'),
          ),
          FilledButton(
            onPressed: () {
              onApprove(ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('Valider'),
          ),
        ],
      ),
    );
  }
}
