import 'package:curso_persitencia_flutter/components/container.dart';
import 'package:curso_persitencia_flutter/models/name_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return NameView();
  }
}

class NameView extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.text = context.read<NameCubit>().state;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change name"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            style: TextStyle(fontSize: 24),
            decoration: InputDecoration(labelText: "Desired name:"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: () {
                  final name = _nameController.text;
                  context.read<NameCubit>().change(name);
                },
                child: Text("Change"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
