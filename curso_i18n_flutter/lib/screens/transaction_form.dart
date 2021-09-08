import 'dart:async';

import 'package:curso_persitencia_flutter/components/container.dart';
import 'package:curso_persitencia_flutter/components/progress.dart';
import 'package:curso_persitencia_flutter/components/transaction_auth_dialog.dart';
import 'package:curso_persitencia_flutter/models/contact_model.dart';
import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:curso_persitencia_flutter/repositories/http_exception.dart';
import 'package:curso_persitencia_flutter/repositories/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

@immutable
abstract class TransactionFormState {
  const TransactionFormState();
}

@immutable
class ShowFormTransactionFormState extends TransactionFormState {
  const ShowFormTransactionFormState();
}

@immutable
class SendingTransactionFormState extends TransactionFormState {
  const SendingTransactionFormState();
}

@immutable
class SentStateTransactionFormState extends TransactionFormState {
  final Transaction transaction;
  const SentStateTransactionFormState(this.transaction);
}

@immutable
class FatalErrorTransactionFormState extends TransactionFormState {
  final String error;
  const FatalErrorTransactionFormState(this.error);
}

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit() : super(ShowFormTransactionFormState());

  void save(
    Transaction transaction,
    String password,
    BuildContext context,
  ) async {
    try {
      emit(SendingTransactionFormState());
      final Transaction? transactionCreated =
          await TransactionRepository().save(transaction, password);

      emit(SentStateTransactionFormState(transactionCreated!));
    } on TimeoutException {
      emit(
          FatalErrorTransactionFormState("Timeout submitting the transaction"));
    } on HttpException catch (e) {
      emit(FatalErrorTransactionFormState(e.message));
    } on Exception {
      emit(FatalErrorTransactionFormState("Um erro desconhecido ocorreu"));
    }
  }
}

class TransactionFormContainer extends BlocContainer {
  final Contact contact;

  TransactionFormContainer(this.contact);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionFormCubit>(
      create: (context) {
        return TransactionFormCubit();
      },
      child: BlocListener<TransactionFormCubit, TransactionFormState>(
        listener: (context, state) {
          if (state is SentStateTransactionFormState) {
            Navigator.of(context).pop(state.transaction);
          }
        },
        child: TransactionForm(contact),
      ),
    );
  }
}

class TransactionForm extends StatelessWidget {
  final Contact contact;

  TransactionForm(this.contact);
  @override
  Widget build(BuildContext context1) {
    return BlocBuilder<TransactionFormCubit, TransactionFormState>(
      builder: (context, state) {
        if (state is ShowFormTransactionFormState) {
          return _BasicForm(contact);
        }

        if (state is SendingTransactionFormState ||
            state is SentStateTransactionFormState) {
          return BasicProgress();
        }

        if (state is FatalErrorTransactionFormState) {
          return Material(
            child: Center(
              child: Text(
                state.error,
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        }

        return Text("Error!");
      },
    );
  }
}

class _BasicForm extends StatelessWidget {
  final Contact contact;
  final String transactionId = Uuid().v4();
  final TextEditingController _valueController = TextEditingController();

  _BasicForm(this.contact);

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
                Text(
                  contact.name,
                  style: TextStyle(
                    fontSize: 24.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    contact.accountNumber.toString(),
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
                        final transactionCreated = Transaction(
                          id: transactionId,
                          value: value ?? 0,
                          contact: contact,
                        );
                        showDialog(
                          context: context,
                          builder: (_) => TransactionAuthDialog(
                            onConfirm: (password) {
                              BlocProvider.of<TransactionFormCubit>(context)
                                  .save(transactionCreated, password, context);
                            },
                          ),
                        );
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
}
