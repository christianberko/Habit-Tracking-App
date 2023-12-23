import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget{

  final Function()? onPressed; 

  const MyFloatingActionButton({
    super.key,
    required this.onPressed,
    
    });
  
  


  @override
  Widget build(BuildContext context){
    return FloatingActionButton(
      onPressed:onPressed,
      // ignore: prefer_const_constructors
      child: Icon(Icons.add),
    
    );
  }

}