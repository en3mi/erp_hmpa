import '../core/enums.dart';
import '../models/history_action.dart';
import '../models/purchase.dart';
import '../models/sale.dart';
import 'database_service.dart';

class ErpRepository {
  Future<int> addPurchase(Purchase purchase) async {
    final db = await DatabaseService.instance.database;
    return db.insert('purchases', purchase.toMap());
  }

  Future<int> updatePurchase(Purchase purchase) async {
    final db = await DatabaseService.instance.database;
    return db.update(
      'purchases',
      purchase.toMap(),
      where: 'id = ?',
      whereArgs: [purchase.id],
    );
  }

  Future<int> deletePurchase(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete('purchases', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Purchase>> getPurchases() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('purchases', orderBy: 'dateCreation DESC');
    return maps.map(Purchase.fromMap).toList();
  }

  Future<int> addSale(Sale sale) async {
    final db = await DatabaseService.instance.database;
    return db.insert('sales', sale.toMap());
  }

  Future<int> updateSale(Sale sale) async {
    final db = await DatabaseService.instance.database;
    return db.update('sales', sale.toMap(), where: 'id = ?', whereArgs: [sale.id]);
  }

  Future<int> deleteSale(int id) async {
    final db = await DatabaseService.instance.database;
    return db.delete('sales', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Sale>> getSales() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('sales', orderBy: 'dateCreation DESC');
    return maps.map(Sale.fromMap).toList();
  }

  Future<int> addHistory(HistoryAction action) async {
    final db = await DatabaseService.instance.database;
    return db.insert('history', action.toMap());
  }

  Future<List<HistoryAction>> getHistory({int limit = 50}) async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('history', orderBy: 'timestamp DESC', limit: limit);
    return maps.map(HistoryAction.fromMap).toList();
  }

  Future<void> seedIfEmpty() async {
    final db = await DatabaseService.instance.database;
    final purchases = await db.rawQuery('SELECT COUNT(*) as c FROM purchases');
    final sales = await db.rawQuery('SELECT COUNT(*) as c FROM sales');
    final hasData = (purchases.first['c'] as int) > 0 || (sales.first['c'] as int) > 0;
    if (hasData) return;

    final now = DateTime.now();
    await addPurchase(
      Purchase(
        reference: 'ACH-${now.millisecondsSinceEpoch % 100000}',
        date: now.subtract(const Duration(days: 3)),
        supplier: 'Studio Son Lumière',
        description: 'Location matériel audio',
        category: 'Technique',
        amount: 450000,
        paymentMethod: 'Virement',
        createdBy: 'employe@hmpa.com',
        dateCreation: now,
        dateModification: now,
      ),
    );
    await addSale(
      Sale(
        reference: 'VTE-${now.millisecondsSinceEpoch % 100000}',
        date: now.subtract(const Duration(days: 2)),
        client: 'Chaîne TV Locale',
        description: 'Production spot publicitaire',
        category: 'Production',
        amount: 1100000,
        paymentMethod: 'Espèces',
        createdBy: 'employe@hmpa.com',
        dateCreation: now,
        dateModification: now,
      ),
    );
    await addHistory(
      HistoryAction(
        operationType: OperationType.purchase,
        operationId: 1,
        action: 'created',
        actor: 'employe@hmpa.com',
        timestamp: now,
      ),
    );
    await addHistory(
      HistoryAction(
        operationType: OperationType.sale,
        operationId: 1,
        action: 'created',
        actor: 'employe@hmpa.com',
        timestamp: now,
      ),
    );
  }
}
