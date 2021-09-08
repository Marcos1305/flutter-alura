import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData? icone;

  const Editor({
    Key? key,
    required this.controlador,
    required this.rotulo,
    required this.dica,
    this.icone,
  }) : super(key: key);

  @override
  State createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: widget.controlador,
        style: TextStyle(
          fontSize: 24,
        ),
        decoration: InputDecoration(
          icon: widget.icone != null ? Icon(widget.icone) : null,
          labelText: widget.rotulo,
          hintText: widget.dica,
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
