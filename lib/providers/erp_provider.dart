import 'package:flutter/material.dart';

import '../core/enums.dart';
import '../models/history_action.dart';
import '../models/purchase.dart';
import '../models/sale.dart';
import '../models/user.dart';
import '../services/erp_repository.dart';

class ErpProvider extends ChangeNotifier {
  final _repo = ErpRepository();

  List<Purchase> purchases = [];
  List<Sale> sales = [];
  List<HistoryAction> history = [];
  bool loading = false;

  Future<void> init() async {
    loading = true;
    notifyListeners();
    await _repo.seedIfEmpty();
    await refresh();
  }

  Future<void> refresh() async {
    purchases = await _repo.getPurchases();
    sales = await _repo.getSales();
    history = await _repo.getHistory();
    loading = false;
    notifyListeners();
  }

  Future<void> addPurchase(Purchase purchase) async {
    final id = await _repo.addPurchase(purchase);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.purchase,
        operationId: id,
        action: 'created',
        actor: purchase.createdBy,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> updatePurchase(Purchase purchase, String actor) async {
    await _repo.updatePurchase(purchase.copyWith(dateModification: DateTime.now()));
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.purchase,
        operationId: purchase.id!,
        action: 'updated',
        actor: actor,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> deletePurchase(Purchase purchase, String actor) async {
    await _repo.deletePurchase(purchase.id!);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.purchase,
        operationId: purchase.id!,
        action: 'deleted',
        actor: actor,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> addSale(Sale sale) async {
    final id = await _repo.addSale(sale);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.sale,
        operationId: id,
        action: 'created',
        actor: sale.createdBy,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> updateSale(Sale sale, String actor) async {
    await _repo.updateSale(sale.copyWith(dateModification: DateTime.now()));
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.sale,
        operationId: sale.id!,
        action: 'updated',
        actor: actor,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> deleteSale(Sale sale, String actor) async {
    await _repo.deleteSale(sale.id!);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.sale,
        operationId: sale.id!,
        action: 'deleted',
        actor: actor,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> validatePurchase({
    required Purchase purchase,
    required bool approve,
    required AppUser validator,
    String? comment,
  }) async {
    final updated = purchase.copyWith(
      status: approve ? OperationStatus.approved : OperationStatus.rejected,
      validatedBy: validator.email,
      validationComment: comment,
      validationDate: DateTime.now(),
      dateModification: DateTime.now(),
    );
    await _repo.updatePurchase(updated);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.purchase,
        operationId: purchase.id!,
        action: approve ? 'approved' : 'rejected',
        actor: validator.email,
        comment: comment,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  Future<void> validateSale({
    required Sale sale,
    required bool approve,
    required AppUser validator,
    String? comment,
  }) async {
    final updated = sale.copyWith(
      status: approve ? OperationStatus.approved : OperationStatus.rejected,
      validatedBy: validator.email,
      validationComment: comment,
      validationDate: DateTime.now(),
      dateModification: DateTime.now(),
    );
    await _repo.updateSale(updated);
    await _repo.addHistory(
      HistoryAction(
        operationType: OperationType.sale,
        operationId: sale.id!,
        action: approve ? 'approved' : 'rejected',
        actor: validator.email,
        comment: comment,
        timestamp: DateTime.now(),
      ),
    );
    await refresh();
  }

  double get totalPurchases => purchases.fold(0, (sum, p) => sum + p.amount);
  double get totalSales => sales.fold(0, (sum, s) => sum + s.amount);
  double get estimatedProfit => totalSales - totalPurchases;

  int get pendingCount =>
      purchases.where((p) => p.status == OperationStatus.pending).length +
      sales.where((s) => s.status == OperationStatus.pending).length;
  int get approvedCount =>
      purchases.where((p) => p.status == OperationStatus.approved).length +
      sales.where((s) => s.status == OperationStatus.approved).length;
  int get rejectedCount =>
      purchases.where((p) => p.status == OperationStatus.rejected).length +
      sales.where((s) => s.status == OperationStatus.rejected).length;
}
