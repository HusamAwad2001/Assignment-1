import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String validation;
  final TextInputType keyboardType;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.validation,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (String? value){
        if(value!.isEmpty){
          return validation;
        }
        return null;
      },
      decoration: InputDecoration(
        // hintText: hintText,
        label: Text(hintText),
        enabledBorder: borderTextField(),
        focusedBorder: borderTextField(),
        errorBorder: borderTextField(color: Colors.red),
        focusedErrorBorder: borderTextField(color: Colors.red),
      ),
    );
  }

  OutlineInputBorder borderTextField({Color color = Colors.blue}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        width: 1,
        color: color,
      ),
    );
  }
}
