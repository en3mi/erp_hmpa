import '../core/enums.dart';

class Purchase {
  final int? id;
  final String reference;
  final DateTime date;
  final String supplier;
  final String description;
  final String category;
  final double amount;
  final String paymentMethod;
  final OperationStatus status;
  final String createdBy;
  final String? validatedBy;
  final String? validationComment;
  final DateTime? validationDate;
  final DateTime dateCreation;
  final DateTime dateModification;

  Purchase({
    this.id,
    required this.reference,
    required this.date,
    required this.supplier,
    required this.description,
    required this.category,
    required this.amount,
    required this.paymentMethod,
    this.status = OperationStatus.pending,
    required this.createdBy,
    this.validatedBy,
    this.validationComment,
    this.validationDate,
    required this.dateCreation,
    required this.dateModification,
  });

  Purchase copyWith({
    int? id,
    String? reference,
    DateTime? date,
    String? supplier,
    String? description,
    String? category,
    double? amount,
    String? paymentMethod,
    OperationStatus? status,
    String? createdBy,
    String? validatedBy,
    String? validationComment,
    DateTime? validationDate,
    DateTime? dateCreation,
    DateTime? dateModification,
  }) {
    return Purchase(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      date: date ?? this.date,
      supplier: supplier ?? this.supplier,
      description: description ?? this.description,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      validatedBy: validatedBy ?? this.validatedBy,
      validationComment: validationComment ?? this.validationComment,
      validationDate: validationDate ?? this.validationDate,
      dateCreation: dateCreation ?? this.dateCreation,
      dateModification: dateModification ?? this.dateModification,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reference': reference,
      'date': date.toIso8601String(),
      'supplier': supplier,
      'description': description,
      'category': category,
      'amount': amount,
      'paymentMethod': paymentMethod,
      'status': status.dbValue,
      'createdBy': createdBy,
      'validatedBy': validatedBy,
      'validationComment': validationComment,
      'validationDate': validationDate?.toIso8601String(),
      'dateCreation': dateCreation.toIso8601String(),
      'dateModification': dateModification.toIso8601String(),
    };
  }

  factory Purchase.fromMap(Map<String, dynamic> map) {
    return Purchase(
      id: map['id'] as int?,
      reference: map['reference'] as String,
      date: DateTime.parse(map['date'] as String),
      supplier: map['supplier'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
      amount: (map['amount'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] as String,
      status: OperationStatusX.fromDb(map['status'] as String),
      createdBy: map['createdBy'] as String,
      validatedBy: map['validatedBy'] as String?,
      validationComment: map['validationComment'] as String?,
      validationDate: map['validationDate'] != null
          ? DateTime.parse(map['validationDate'] as String)
          : null,
      dateCreation: DateTime.parse(map['dateCreation'] as String),
      dateModification: DateTime.parse(map['dateModification'] as String),
    );
  }
}
