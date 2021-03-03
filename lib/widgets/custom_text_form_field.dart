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
    this.inputAction,
    this.backgroundColor,
  }) : super(key: key);

  final String valKey;
  final Map<String, Object> data;
  final String inputName;
  final TextInputType inputType;
  final Function validator;
  final FocusNode focusNode;
  final TextInputAction inputAction;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      key: ValueKey(valKey),
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).canvasColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 0,
            style: BorderStyle.none,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            width: 0,
            color: Theme.of(context).primaryColorDark,
            style: BorderStyle.solid,
          ),
        ),
        labelText: inputName,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).hintColor,
      ),
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: inputType,
      validator: validator,
      textInputAction: inputAction,
      textCapitalization: TextCapitalization.sentences,
      onEditingComplete: () => inputAction == TextInputAction.done
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
