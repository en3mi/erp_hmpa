enum UserRole { employee, boss }

enum OperationStatus { pending, approved, rejected }

enum OperationType { purchase, sale }

extension OperationStatusX on OperationStatus {
  String get label {
    switch (this) {
      case OperationStatus.pending:
        return 'En attente';
      case OperationStatus.approved:
        return 'Validé';
      case OperationStatus.rejected:
        return 'Rejeté';
    }
  }

  String get dbValue => name;

  static OperationStatus fromDb(String value) =>
      OperationStatus.values.firstWhere((e) => e.name == value);
}
