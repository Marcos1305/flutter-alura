import 'dart:convert';

import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:curso_persitencia_flutter/services/http/web_client_service.dart';
import 'package:http/http.dart';

class TransactionRepository {
  static final Uri url = Uri.parse("$baseUrl/transactions");

  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(url).timeout(Duration(seconds: 5));
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions =
        decodedJson.map((e) => Transaction.fromMap(e)).toList();

    return transactions;
  }

  Future<Transaction> save(final Transaction transaction) async {
    final Response response = await client.post(url,
        headers: {
          "Content-type": "application/json",
          "password": "1000",
        },
        body: jsonEncode(
          transaction.toMap(),
        ));

    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return Transaction.fromMap(decodedJson);
  }
}
