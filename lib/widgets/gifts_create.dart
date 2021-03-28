import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/widgets/custom_text_form_field.dart';

class CreateGift extends StatefulWidget {
  CreateGift({
    @required this.addictionId,
  });

  final String addictionId;
  @override
  _CreateGiftNoteState createState() => _CreateGiftNoteState();
}

class _CreateGiftNoteState extends State<CreateGift> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode formFocusNode;
  var giftData = {
    'name': '',
    'price': 0.0,
  };

  void trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<AddictionsProvider>(context, listen: false).createGift(
        giftData,
        widget.addictionId,
      );
      Navigator.of(ctx).pop();
    }
  }

  @override
  void initState() {
    formFocusNode = FocusNode();
    formFocusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    formFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final local = AppLocalizations.of(context);
    final inputBackgroundColor = t.canvasColor;
    final buttonHeight = t.buttonTheme.height * 2;

    return DefaultTextStyle(
      style: TextStyle(
        color: t.hintColor,
        fontWeight: FontWeight.bold,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: t.cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20,
            bottom: 8,
            left: 8,
            right: 8,
          ),
          child: Wrap(
            runSpacing: 20,
            children: [
              CustomTextFormField(
                valKey: 'name',
                data: giftData,
                inputName: local.title,
                focusNode: null,
                inputType: TextInputType.name,
                backgroundColor: inputBackgroundColor,
              ),
              CustomTextFormField(
                valKey: 'price',
                data: giftData,
                inputName: local.price,
                focusNode: null,
                inputType: TextInputType.number,
                backgroundColor: inputBackgroundColor,
                validator: (value) {
                  if (double.tryParse(value) == null) {
                    return local.pleaseEnterANumber;
                  } else if (double.parse(value) < 0) {
                    return local.valueMustBePositive;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: buttonHeight,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(inputBackgroundColor),
                  ),
                  onPressed: () {
                    trySubmit(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: t.primaryColorLight,
                      ),
                      Text(
                        local.save,
                        style: TextStyle(
                          color: t.primaryColorLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
