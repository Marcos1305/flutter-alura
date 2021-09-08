import 'package:flutter/material.dart';

const _title = "Receber depósito";
const _hintValueField = '0.0';
const _labelValueField = "Valor";

class DepositForm extends StatelessWidget {
  final TextEditingController _controllerValueField = TextEditingController();

  DepositForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _controllerValueField,
              decoration: InputDecoration(
                labelText: _labelValueField,
                hintText: _hintValueField,
              ),
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(onPressed: () {
              final double? value = double.tryParse(_controllerValueField.text);

              if (value != null) {
                Navigator.of(context).pop(value);
              }
            }, child: Text("Depositar"))
          ],
        ),
      ),
    );
  }
}
