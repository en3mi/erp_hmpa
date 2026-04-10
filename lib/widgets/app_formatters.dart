import 'package:intl/intl.dart';

String formatCurrency(double value) =>
    NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA ').format(value);

String formatDate(DateTime date) => DateFormat('dd/MM/yyyy').format(date);
