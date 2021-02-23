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
    // final deviceHeight = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.blueGrey[800],
        fontWeight: FontWeight.bold,
      ),
      child: Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).accentColor.withAlpha(100),
                offset: Offset(0, -3),
                spreadRadius: 3,
                blurRadius: 3,
              )
            ],
            border: Border(
              top: BorderSide(
                width: 1,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          // height: deviceHeight * .5,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            top: 10,
            left: 8,
            right: 8,
          ),
          child: Wrap(
            runSpacing: 20,
            // mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextFormField(
                valKey: 'title',
                data: noteData,
                inputName: local.title.capitalizeWords(),
                focusNode: null,
                inputType: TextInputType.name,
              ),
              TextFormField(
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
                  hintText: local.note.capitalizeWords(),
                ),
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                maxLines: null,
                maxLength: 100,
                maxLengthEnforced: true,
                onSaved: (newValue) => noteData['text'] = newValue.trim(),
              ),
              // CustomTextFormField(
              //   data: noteData,
              //   inputName: 'Note',
              //   focusNode: null,
              //   inputType: TextInputType.text,
              // ),
              SizedBox(
                height: Theme.of(context).buttonTheme.height * 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor.withAlpha(150),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              local.date.capitalizeWords(),
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateTime.parse(noteData['date']),
                                  ),
                                ),
                              ),
                              Container(
                                width: deviceWidth * .1,
                                child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  child: Icon(Icons.date_range),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _selectDate(context);
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      child: FlatButton(
                        color: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        splashColor: Theme.of(context).primaryColorLight,
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
                              Icon(Icons.save),
                              Text(local.save.capitalizeWords()),
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
