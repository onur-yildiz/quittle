import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    setState(() {
      if (date != null) {
        noteData['date'] = date.toString();
      } else {
        noteData['date'] = DateTime.now().toString();
      }
    });
  }

  void trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<Addictions>(context, listen: false).createNote(
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
    final local = AppLocalizations.of(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final inputBackgroundColor = Theme.of(context).canvasColor;
    // final deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).hintColor,
        fontWeight: FontWeight.bold,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            border: Border(
              top: BorderSide(
                width: 1,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
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
                inputName: local.title.capitalizeWords(),
                focusNode: null,
                inputType: TextInputType.name,
                backgroundColor: inputBackgroundColor,
              ),
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
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
                      color: Theme.of(context).primaryColorLight,
                      style: BorderStyle.solid,
                    ),
                  ),
                  hintText: local.note.capitalizeWords(),
                ),
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                maxLength: 100,
                maxLengthEnforced: true,
                onSaved: (newValue) => noteData['text'] = newValue.trim(),
              ),
              SizedBox(
                height: Theme.of(context).buttonTheme.height * 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Material(
                      type: MaterialType.button,
                      color: inputBackgroundColor,
                      borderRadius: BorderRadius.circular(5),
                      child: InkWell(
                        onTap: () {
                          setState(
                            () {
                              _selectDate(context);
                            },
                          );
                        },
                        splashColor: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(noteData['date']),
                                ),
                                style: TextStyle(
                                    color: Theme.of(context).hintColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: deviceWidth * .1,
                                child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  child: Icon(Icons.date_range),
                                  onPressed: null,
                                  disabledTextColor:
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      child: FlatButton(
                        color: inputBackgroundColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        onPressed: () {
                          trySubmit(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                Theme.of(context).textTheme.headline6.fontSize,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.save,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              Text(
                                local.save.capitalizeWords(),
                                style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
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
