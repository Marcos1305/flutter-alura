class Contact {
  final int id;
  final String name;
  final int accountNumber;

  Contact({required this.id, required this.name, required this.accountNumber});

  @override
  String toString() {
    return 'Contact{name: $name, accountNumber: $accountNumber}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'account_number': this.accountNumber,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: 0,
      name: map['name'] as String,
      accountNumber: map['accountNumber'] as int,
    );
  }
}
