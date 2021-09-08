import 'contact_model.dart';

class Transaction {
  final String id;
  final double value;
  final Contact contact;

  Transaction({
    required this.id,
    required this.value,
    required this.contact,
  });

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'value': this.value,
      'contact': this.contact.toMap(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      value: map['value'] as double,
      contact: Contact.fromMap(map['contact']),
    );
  }
}
