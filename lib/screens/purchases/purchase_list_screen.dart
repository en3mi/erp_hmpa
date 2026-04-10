import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../providers/auth_provider.dart';
import '../../providers/erp_provider.dart';
import '../../widgets/app_formatters.dart';
import '../../widgets/status_chip.dart';
import '../common/operation_detail_screen.dart';
import 'purchase_form_screen.dart';

class PurchaseListScreen extends StatefulWidget {
  const PurchaseListScreen({super.key});

  @override
  State<PurchaseListScreen> createState() => _PurchaseListScreenState();
}

class _PurchaseListScreenState extends State<PurchaseListScreen> {
  OperationStatus? filterStatus;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final erp = context.watch<ErpProvider>();
    final user = context.watch<AuthProvider>().currentUser!;
    final items = erp.purchases.where((p) {
      final matchesStatus = filterStatus == null || p.status == filterStatus;
      final q = query.toLowerCase();
      final matchesQuery = q.isEmpty || p.supplier.toLowerCase().contains(q) || p.description.toLowerCase().contains(q);
      return matchesStatus && matchesQuery;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Recherche achat'),
                    onChanged: (v) => setState(() => query = v),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<OperationStatus?>(
                  value: filterStatus,
                  hint: const Text('Statut'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Tous')),
                    ...OperationStatus.values.map((s) => DropdownMenuItem(value: s, child: Text(s.label))),
                  ],
                  onChanged: (v) => setState(() => filterStatus = v),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final p = items[i];
                final canEdit = p.status == OperationStatus.pending;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('${p.reference} • ${p.supplier}'),
                    subtitle: Text('${formatCurrency(p.amount)} - ${formatDate(p.date)}'),
                    trailing: StatusChip(status: p.status),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OperationDetailScreen.purchase(purchase: p),
                      ),
                    ),
                    leading: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => PurchaseFormScreen(purchase: p)),
                          );
                        } else if (v == 'delete') {
                          await erp.deletePurchase(p, user.email);
                        }
                      },
                      itemBuilder: (_) => [
                        PopupMenuItem(value: 'edit', enabled: canEdit, child: const Text('Modifier')),
                        PopupMenuItem(value: 'delete', enabled: canEdit, child: const Text('Supprimer')),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PurchaseFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
