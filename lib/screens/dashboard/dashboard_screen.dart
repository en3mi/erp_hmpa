import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/erp_provider.dart';
import '../../widgets/app_formatters.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final erp = context.watch<ErpProvider>();
    final latest = [...erp.purchases.map((e) => 'Achat ${e.reference}'), ...erp.sales.map((e) => 'Vente ${e.reference}')]
      ..sort();

    return RefreshIndicator(
      onRefresh: erp.refresh,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _card('Total achats', formatCurrency(erp.totalPurchases)),
              _card('Total ventes', formatCurrency(erp.totalSales)),
              _card('Bénéfice estimatif', formatCurrency(erp.estimatedProfit)),
              _card('En attente', '${erp.pendingCount}'),
              _card('Validées', '${erp.approvedCount}'),
              _card('Rejetées', '${erp.rejectedCount}'),
            ],
          ),
          const SizedBox(height: 18),
          const Text('5 dernières opérations', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...latest.take(5).map((e) => ListTile(title: Text(e))),
        ],
      ),
    );
  }

  Widget _card(String title, String value) {
    return SizedBox(
      width: 170,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text(title), const SizedBox(height: 8), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))],
          ),
        ),
      ),
    );
  }
}
