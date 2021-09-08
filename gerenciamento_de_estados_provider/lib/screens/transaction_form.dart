import 'dart:async';

import 'package:curso_persitencia_flutter/components/progress.dart';
import 'package:curso_persitencia_flutter/components/response_dialog.dart';
import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:curso_persitencia_flutter/repositories/http_exception.dart';
import 'package:curso_persitencia_flutter/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  const TransactionForm();

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final String transactionId = Uuid().v4();
  final TextEditingController _valueController = TextEditingController();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                  visible: _sending,
                  child: Progress(
                    message: "Salvando transação",
                  ),
                ),
                Text(
                  "1000",
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    "01",
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: TextField(
                    controller: _valueController,
                    style: TextStyle(fontSize: 24.0),
                    decoration: InputDecoration(labelText: 'Value'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      child: Text('Transfer'),
                      onPressed: () {
                        final double? value =
                            double.tryParse(_valueController.text);

                        if (value != null) {
                          Navigator.of(context).pop(value);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveTransaction(
    final BuildContext context,
    final Transaction transaction,
    final String password,
  ) async {
    try {
      setState(() {
        _sending = true;
      });
      final Transaction? transactionCreated =
          await TransactionRepository().save(transaction, password);

      await showDialog(
        context: context,
        builder: (context) {
          return SuccessDialog("Successful transaction");
        },
      );
      Navigator.of(context).pop(transactionCreated);
    } on TimeoutException {
      _showFailureMessage(context, error: "Timeout submitting the transaction");
    } on HttpException catch (e) {
      _showFailureMessage(context, error: e.message);
    } on Exception {
      _showFailureMessage(context);
    } finally {
      setState(() {
        _sending = false;
      });
    }
  }

  void _showFailureMessage(BuildContext context, {error = "unknown error"}) {
    showDialog(
      context: context,
      builder: (context) {
        return FailureDialog(error);
      },
    );
  }
}
