import 'contact_model.dart';

class Transaction {
  final double value;
  final Contact contact;

  Transaction({
    required this.value,
    required this.contact,
  });

  @override
  String toString() {
    return 'Transaction{value: $value, contact: $contact}';
  }

  Map<String, dynamic> toMap() {
    return {
      'value': this.value,
      'contact': this.contact.toMap(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      value: map['value'] as double,
      contact: Contact.fromMap(map['contact']),
    );
  }
}
