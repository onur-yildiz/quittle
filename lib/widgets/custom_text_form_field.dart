import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.valKey,
      required this.data,
      required this.inputName,
      this.focusNode,
      this.inputType,
      this.validator,
      this.inputAction,
      this.backgroundColor,
      this.onSubmit,
      this.maxLength})
      : super(key: key);

  final String valKey;
  final Map<String, Object?> data;
  final String inputName;
  final TextInputType? inputType;
  final Function? validator;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final Color? backgroundColor;
  final Function? onSubmit;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    if (onSubmit == null && inputAction == TextInputAction.done)
      throw 'Error: onSubmit == null && inputAction == TextInputAction.done. Provide an onSubmit function.';

    final t = Theme.of(context);
    return TextFormField(
      onFieldSubmitted: (_) {
        if (inputAction != TextInputAction.done) return;
        onSubmit!();
      },
      focusNode: focusNode,
      key: ValueKey(valKey),
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor != null ? backgroundColor : t.canvasColor,
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
            color: t.primaryColorDark,
            style: BorderStyle.solid,
          ),
        ),
        labelText: inputName,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextStyle(
        color: t.hintColor,
      ),
      cursorColor: t.primaryColor,
      keyboardType: inputType,
      validator: validator as String? Function(String?)?,
      textInputAction: inputAction,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      textCapitalization: TextCapitalization.sentences,
      onEditingComplete: () => inputAction == TextInputAction.done
          ? FocusScope.of(context).unfocus()
          : FocusScope.of(context).nextFocus(),
      onSaved: (input) {
        var value;
        switch (data[valKey].runtimeType) {
          case int:
            value = input is int ? input : int.parse(input!);
            break;
          case double:
            value = input is double ? input : double.parse(input!);
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
