import 'package:curso_persitencia_flutter/models/balance_model.dart';
import 'package:curso_persitencia_flutter/models/contact_model.dart';
import 'package:curso_persitencia_flutter/models/transaction.dart';
import 'package:curso_persitencia_flutter/models/transactions_model.dart';
import 'package:curso_persitencia_flutter/screens/dashboard/balance_card.dart';
import 'package:curso_persitencia_flutter/screens/deposit/deposit_form.dart';
import 'package:curso_persitencia_flutter/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bytebank"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          BalanceCard(),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _createDeposit(context),
                child: Text("Receber depósito"),
              ),
              ElevatedButton(
                onPressed: () => _createTransaction(context),
                child: Text("Realizar transferencia"),
              ),
            ],
          ),
          Consumer<TransactionsModel>(
            builder: (context, transactionsModel, child) {
              return ListView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: transactionsModel.transactions.length,
                itemBuilder: (context, index) {
                  final Transaction transaction =
                      transactionsModel.transactions[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.monetization_on),
                      title: Text(
                        transaction.value.toString(),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        transaction.contact.accountNumber.toString(),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Future<dynamic> _createDeposit(BuildContext context) async {
    final double value = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DepositForm(),
    ));

    Provider.of<BalanceModel>(context, listen: false).add(value);
  }

  _createTransaction(BuildContext context) async {
    final double value = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TransactionForm(),
    ));

    final Transaction transaction = Transaction(
      id: Uuid().v4(),
      value: value,
      contact: Contact(id: 0, name: '', accountNumber: 100),
    );

    final balanceModel = Provider.of<BalanceModel>(context, listen: false);

    if (balanceModel.value < value) {
      return;
    }

    Provider.of<TransactionsModel>(context, listen: false).add(transaction);
    balanceModel.withdraw(value);
  }
}
