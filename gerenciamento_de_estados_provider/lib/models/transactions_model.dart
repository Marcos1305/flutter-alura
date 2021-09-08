import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsModel extends ChangeNotifier {
  List<Transaction> transactions = [];

  add(Transaction transaction) {
    this.transactions.add(transaction);
    notifyListeners();
  }
}
