import 'dart:convert';

import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:curso_persitencia_flutter/repositories/http_exception.dart';
import 'package:curso_persitencia_flutter/services/http/web_client_service.dart';
import 'package:http/http.dart';

class TransactionRepository {
  static final Uri url = Uri.parse("$baseUrl/transactions");
  static final Map<int, String> _statusCodeResponses = {
    400: "there was an error submitting transaction",
    401: 'authentication failed',
    409: 'transaction always exists'
  };

  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(url);
    final List<dynamic> decodedJson = jsonDecode(response.body);
    final List<Transaction> transactions =
        decodedJson.map((e) => Transaction.fromMap(e)).toList();

    return transactions;
  }

  Future<Transaction?> save(
    final Transaction transaction,
    final String password,
  ) async {
    final Response response = await client.post(url,
        headers: {
          "Content-type": "application/json",
          "password": password,
        },
        body: jsonEncode(
          transaction.toMap(),
        ));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedJson = jsonDecode(response.body);
      return Transaction.fromMap(decodedJson);
    }

    throw HttpException(_getHttpExceptionMessage(response.statusCode));
  }

  String _getHttpExceptionMessage(final int statusCode) {
    return _statusCodeResponses[statusCode] ?? "Unknown error";
  }
}
