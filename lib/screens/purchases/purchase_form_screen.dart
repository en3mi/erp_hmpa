import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../models/purchase.dart';
import '../../providers/auth_provider.dart';
import '../../providers/erp_provider.dart';

class PurchaseFormScreen extends StatefulWidget {
  final Purchase? purchase;
  const PurchaseFormScreen({super.key, this.purchase});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _supplierCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _payment = 'Virement';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final p = widget.purchase;
    if (p != null) {
      _supplierCtrl.text = p.supplier;
      _descCtrl.text = p.description;
      _categoryCtrl.text = p.category;
      _amountCtrl.text = p.amount.toString();
      _payment = p.paymentMethod;
      _date = p.date;
    }
  }

  @override
  void dispose() {
    _supplierCtrl.dispose();
    _descCtrl.dispose();
    _categoryCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final erp = context.read<ErpProvider>();
    final user = auth.currentUser!;
    final now = DateTime.now();

    if (widget.purchase == null) {
      final reference = 'ACH-${now.millisecondsSinceEpoch % 1000000}';
      await erp.addPurchase(
        Purchase(
          reference: reference,
          date: _date,
          supplier: _supplierCtrl.text,
          description: _descCtrl.text,
          category: _categoryCtrl.text,
          amount: double.parse(_amountCtrl.text),
          paymentMethod: _payment,
          createdBy: user.email,
          dateCreation: now,
          dateModification: now,
        ),
      );
    } else {
      await erp.updatePurchase(
        widget.purchase!.copyWith(
          date: _date,
          supplier: _supplierCtrl.text,
          description: _descCtrl.text,
          category: _categoryCtrl.text,
          amount: double.parse(_amountCtrl.text),
          paymentMethod: _payment,
        ),
        user.email,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final locked = widget.purchase?.status != null && widget.purchase!.status != OperationStatus.pending;
    return Scaffold(
      appBar: AppBar(title: Text(widget.purchase == null ? 'Nouvel achat' : 'Modifier achat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _supplierCtrl, decoration: const InputDecoration(labelText: 'Fournisseur'), validator: _required),
              TextFormField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'Description'), validator: _required),
              TextFormField(controller: _categoryCtrl, decoration: const InputDecoration(labelText: 'Catégorie'), validator: _required),
              TextFormField(
                controller: _amountCtrl,
                decoration: const InputDecoration(labelText: 'Montant'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obligatoire';
                  final value = double.tryParse(v);
                  if (value == null || value <= 0) return 'Montant positif requis';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _payment,
                items: const ['Virement', 'Espèces', 'Mobile Money']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: locked ? null : (v) => setState(() => _payment = v!),
                decoration: const InputDecoration(labelText: 'Mode de paiement'),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: locked ? null : _save, child: const Text('Enregistrer')),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? v) => v == null || v.trim().isEmpty ? 'Obligatoire' : null;
}
