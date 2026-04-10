import 'package:flutter_test/flutter_test.dart';
import 'package:erp_hmpa/main.dart';

void main() {
  testWidgets('App démarre et affiche le splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ErpHmpaApp());
    expect(find.text('ERP HMPA - Gestion Comptable'), findsOneWidget);
  });
}
