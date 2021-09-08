import 'package:curso_persitencia_flutter/database/dao/contact_dao.dart';
import 'package:curso_persitencia_flutter/models/contact_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  State createState() {
    return ContactFormState();
  }
}

class ContactFormState extends State<ContactForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo contato"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: widget._nameController,
              decoration: InputDecoration(labelText: "Nome Completo"),
              style: TextStyle(fontSize: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextField(
                controller: widget._accountNumberController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Número conta"),
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () {
                  final String name = widget._nameController.text;
                  final int? accountNumber =
                      int.tryParse(widget._accountNumberController.text);

                  if (accountNumber != null) {
                    final Contact newContact = Contact(
                      id: 0,
                      name: name,
                      accountNumber: accountNumber,
                    );

                    ContactDAO()
                        .save(newContact)
                        .then((value) => Navigator.of(context).pop());
                  }
                },
                child: Text("Criar"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
