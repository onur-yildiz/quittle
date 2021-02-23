import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    @required this.valKey,
    @required this.data,
    @required this.inputName,
    this.focusNode,
    this.inputType,
    this.validator,
    // this.onSubmit,
    this.isLast,
  }) : super(key: key);

  final String valKey;
  final Map<String, Object> data;
  final String inputName;
  final TextInputType inputType;
  final Function validator;
  // final Function onSubmit;
  final FocusNode focusNode;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
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
      textInputAction:
          isLast == true ? TextInputAction.done : TextInputAction.next,
      onEditingComplete: () => isLast == true
          ? FocusScope.of(context).unfocus()
          : FocusScope.of(context).nextFocus(),
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
