import 'package:flutter/material.dart';

import '../../models/purchase.dart';
import '../../models/sale.dart';
import '../../widgets/app_formatters.dart';
import '../../widgets/status_chip.dart';

class OperationDetailScreen extends StatelessWidget {
  final Purchase? purchase;
  final Sale? sale;

  const OperationDetailScreen.purchase({super.key, required this.purchase}) : sale = null;
  const OperationDetailScreen.sale({super.key, required this.sale}) : purchase = null;

  @override
  Widget build(BuildContext context) {
    return purchase != null ? _buildPurchase(context, purchase!) : _buildSale(context, sale!);
  }

  Widget _buildPurchase(BuildContext context, Purchase p) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail achat')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Référence: ${p.reference}'),
          Text('Date: ${formatDate(p.date)}'),
          Text('Fournisseur: ${p.supplier}'),
          Text('Description: ${p.description}'),
          Text('Catégorie: ${p.category}'),
          Text('Montant: ${formatCurrency(p.amount)}'),
          Text('Paiement: ${p.paymentMethod}'),
          const SizedBox(height: 8),
          StatusChip(status: p.status),
          Text('Créé par: ${p.createdBy}'),
          Text('Validé par: ${p.validatedBy ?? '-'}'),
          Text('Commentaire: ${p.validationComment ?? '-'}'),
        ],
      ),
    );
  }

  Widget _buildSale(BuildContext context, Sale s) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail vente')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Référence: ${s.reference}'),
          Text('Date: ${formatDate(s.date)}'),
          Text('Client: ${s.client}'),
          Text('Description: ${s.description}'),
          Text('Catégorie: ${s.category}'),
          Text('Montant: ${formatCurrency(s.amount)}'),
          Text('Paiement: ${s.paymentMethod}'),
          const SizedBox(height: 8),
          StatusChip(status: s.status),
          Text('Créé par: ${s.createdBy}'),
          Text('Validé par: ${s.validatedBy ?? '-'}'),
          Text('Commentaire: ${s.validationComment ?? '-'}'),
        ],
      ),
    );
  }
}
