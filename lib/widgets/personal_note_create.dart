import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/widgets/custom_text_form_field.dart';

class CreatePersonalNote extends StatefulWidget {
  CreatePersonalNote({
    @required this.addictionId,
  });

  final String addictionId;
  @override
  _CreatePersonalNoteState createState() => _CreatePersonalNoteState();
}

class _CreatePersonalNoteState extends State<CreatePersonalNote> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode formFocusNode;
  var noteData = {
    'title': '',
    'text': '',
    'date': DateTime.now().toString(),
  };

  Future<void> _selectDate(context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (mounted) {
      setState(() {
        if (date != null) {
          noteData['date'] = date.toString();
        } else {
          noteData['date'] = DateTime.now().toString();
        }
      });
    }
  }

  void trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<AddictionsProvider>(context, listen: false).createNote(
        noteData,
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
    final deviceWidth = MediaQuery.of(context).size.width;
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
            bottom: 8,
            top: 20,
            left: 8,
            right: 8,
          ),
          child: Wrap(
            runSpacing: 20,
            children: [
              CustomTextFormField(
                valKey: 'title',
                data: noteData,
                inputName: local.title,
                focusNode: null,
                inputType: TextInputType.name,
                backgroundColor: inputBackgroundColor,
              ),
              TextFormField(
                cursorColor: t.primaryColor,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: inputBackgroundColor,
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
                      color: t.primaryColorLight,
                      style: BorderStyle.solid,
                    ),
                  ),
                  hintText: local.note,
                ),
                style: TextStyle(
                  color: t.hintColor,
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                minLines: 8,
                maxLines: null,
                maxLength: 100,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                onSaved: (newValue) => noteData['text'] = newValue.trim(),
              ),
              SizedBox(
                height: buttonHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Material(
                      type: MaterialType.button,
                      color: inputBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _selectDate(context);
                            });
                          }
                        },
                        splashColor: t.primaryColor,
                        borderRadius: BorderRadius.circular(5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(noteData['date']),
                                  ),
                                  style: TextStyle(
                                      color: t.hintColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: deviceWidth * .1,
                                  child: Icon(
                                    Icons.date_range,
                                    color: t.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(inputBackgroundColor),
                        ),
                        onPressed: () {
                          trySubmit(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: t.textTheme.headline6.fontSize,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.save,
                                color: t.primaryColor,
                              ),
                              Text(
                                local.save,
                                style: TextStyle(
                                  color: t.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
