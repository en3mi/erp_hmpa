import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../providers/auth_provider.dart';
import '../../providers/erp_provider.dart';
import '../../widgets/app_formatters.dart';
import '../../widgets/status_chip.dart';
import '../common/operation_detail_screen.dart';
import 'sale_form_screen.dart';

class SaleListScreen extends StatefulWidget {
  const SaleListScreen({super.key});

  @override
  State<SaleListScreen> createState() => _SaleListScreenState();
}

class _SaleListScreenState extends State<SaleListScreen> {
  OperationStatus? filterStatus;
  String query = '';

  @override
  Widget build(BuildContext context) {
    final erp = context.watch<ErpProvider>();
    final user = context.watch<AuthProvider>().currentUser!;
    final items = erp.sales.where((s) {
      final matchesStatus = filterStatus == null || s.status == filterStatus;
      final q = query.toLowerCase();
      final matchesQuery = q.isEmpty || s.client.toLowerCase().contains(q) || s.description.toLowerCase().contains(q);
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
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Recherche vente'),
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
                final s = items[i];
                final canEdit = s.status == OperationStatus.pending;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('${s.reference} • ${s.client}'),
                    subtitle: Text('${formatCurrency(s.amount)} - ${formatDate(s.date)}'),
                    trailing: StatusChip(status: s.status),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OperationDetailScreen.sale(sale: s),
                      ),
                    ),
                    leading: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'edit') {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SaleFormScreen(sale: s)),
                          );
                        } else if (v == 'delete') {
                          await erp.deleteSale(s, user.email);
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
          MaterialPageRoute(builder: (_) => const SaleFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
