import 'package:curso_persitencia_flutter/models/balance_model.dart';
import 'package:curso_persitencia_flutter/models/transactions_model.dart';
import 'package:curso_persitencia_flutter/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BalanceModel(0),
        ),
        ChangeNotifierProvider(
          create: (context) => TransactionsModel(),
        )
      ],
      child: ByteBankApp(),
    ),
  );
}

class ByteBankApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green[900],
        accentColor: Colors.blueAccent[700],
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueAccent[700],
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: Dashboard(),
    );
  }
}
