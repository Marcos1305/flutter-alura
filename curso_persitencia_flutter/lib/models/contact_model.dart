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
      id: map['id'] as int,
      name: map['name'] as String,
      accountNumber: map['account_number'] as int,
    );
  }
}
