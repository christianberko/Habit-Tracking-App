import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {

  final VoidCallback onSave;
  final VoidCallback onCancel;
  final controller;
  final String hintText;

  const AlertBox({
    super.key, 
    required this.onSave, 
    required this.onCancel, 
    required this.controller,
    required this.hintText

    });
  


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style:  const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration:  InputDecoration(
          hintText: hintText,
          hintStyle:  TextStyle(color:Colors.grey[600]),
          enabledBorder: const OutlineInputBorder(
             borderSide: BorderSide(color: Colors.white),
           ),
           focusedBorder:  const OutlineInputBorder(
             borderSide: BorderSide(color: Colors.white),
           ),
        ),
      ),
      actions: [
        MaterialButton(
        onPressed: onSave,
        child: Text(
          "Save",
          style: TextStyle(color:Colors.white)
          ),
        color: Colors.black,
        
      ),
       MaterialButton(
        onPressed: onCancel,
        child: Text(
          "Cancel",
          style: TextStyle(color:Colors.white)
          ),
        color: Colors.black,
        
      ),
      ],
    );
  }
}
