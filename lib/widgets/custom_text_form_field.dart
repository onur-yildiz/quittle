import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    @required this.data,
    @required this.inputName,
    @required this.formNode,
    this.inputType,
    this.validator,
    this.isLast,
  }) : super(key: key);

  final Map<String, Object> data;
  final String inputName;
  final TextInputType inputType;
  final Function validator;
  final FocusNode formNode;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final valKey = inputName.toLowerCase().split(' ').join('_');
    return TextFormField(
      key: ValueKey(valKey),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).cardColor.withAlpha(150),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        labelText: inputName,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      keyboardType: inputType,
      validator: validator,
      onEditingComplete: () =>
          isLast == true ? formNode.unfocus() : formNode.nextFocus(),
      onSaved: (input) {
        var value;
        switch (data[valKey].runtimeType) {
          case int:
            value = input is int ? input : int.parse(input);
            break;
          case double:
            value = input is double ? input : double.parse(input);
            break;
          case String:
            value = input is String ? input : input.toString();
            break;
          default:
            break;
        }
        data[valKey] = value;
      },
    );
  }
}
