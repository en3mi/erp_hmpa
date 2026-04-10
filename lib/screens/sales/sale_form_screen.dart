import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums.dart';
import '../../models/sale.dart';
import '../../providers/auth_provider.dart';
import '../../providers/erp_provider.dart';

class SaleFormScreen extends StatefulWidget {
  final Sale? sale;
  const SaleFormScreen({super.key, this.sale});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  String _payment = 'Virement';
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    final s = widget.sale;
    if (s != null) {
      _clientCtrl.text = s.client;
      _descCtrl.text = s.description;
      _categoryCtrl.text = s.category;
      _amountCtrl.text = s.amount.toString();
      _payment = s.paymentMethod;
      _date = s.date;
    }
  }

  @override
  void dispose() {
    _clientCtrl.dispose();
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

    if (widget.sale == null) {
      final reference = 'VTE-${now.millisecondsSinceEpoch % 1000000}';
      await erp.addSale(
        Sale(
          reference: reference,
          date: _date,
          client: _clientCtrl.text,
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
      await erp.updateSale(
        widget.sale!.copyWith(
          date: _date,
          client: _clientCtrl.text,
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
    final locked = widget.sale?.status != null && widget.sale!.status != OperationStatus.pending;
    return Scaffold(
      appBar: AppBar(title: Text(widget.sale == null ? 'Nouvelle vente' : 'Modifier vente')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _clientCtrl, decoration: const InputDecoration(labelText: 'Client'), validator: _required),
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
