import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
import 'package:flutter_quit_addiction_app/screens/addictions_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAddictionScreen extends StatelessWidget {
  static const routeName = '/create-addiction';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Hero(
      tag: 'newAddiction',
      transitionOnUserGestures: true,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: AddictionCard(statusBarHeight),
      ),
    );
  }
}

class AddictionCard extends StatefulWidget {
  AddictionCard(
    this.statusBarHeight,
  );
  @override
  _AddictionCardState createState() => _AddictionCardState();

  final statusBarHeight;
}

class _AddictionCardState extends State<AddictionCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _consumptionType;
  FocusNode focusNode;
  var addictionData = {
    'name': '',
    'quit_date': DateTime.now().toString(),
    'consumption_type': 0,
    'daily_consumption': 1.0,
    'unit_cost': 1.0,
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
        addictionData['quit_date'] = date.toString();
      } else {
        addictionData['quit_date'] = DateTime.now().toString();
      }
    });
  }

  void trySubmit(BuildContext ctx) {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      Provider.of<AddictionsProvider>(context, listen: false)
          .createAddiction(addictionData);
      Navigator.of(ctx).popAndPushNamed(AddictionsScreen.routeName);
    }
  }

  @override
  void initState() {
    focusNode = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: Duration(milliseconds: 20000),
      curve: Curves.fastOutSlowIn,
      margin: EdgeInsets.zero,
      color: Theme.of(context).cardColor,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            height:
                deviceSize.height - (kToolbarHeight + widget.statusBarHeight),
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomTextFormField(
                  valKey: 'name',
                  data: addictionData,
                  inputName: local.addictionName.capitalizeWords(),
                  inputType: TextInputType.name,
                  focusNode: focusNode,
                  inputAction: TextInputAction.done,
                ),
                SizedBox(
                  width: deviceSize.width,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Wrap(
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 24.0,
                      children: [
                        Material(
                          type: MaterialType.button,
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            focusNode: focusNode,
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Theme.of(context).highlightColor,
                            onTap: () {
                              setState(() {
                                _selectDate(context);
                              });
                            },
                            child: Container(
                              height: Theme.of(context).buttonTheme.height * 2,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
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
                                  Wrap(
                                    direction: Axis.horizontal,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    spacing: 8.0,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          DateTime.parse(
                                              addictionData['quit_date']),
                                        ),
                                        style: TextStyle(
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      Icon(
                                        Icons.date_range,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Material(
                          type: MaterialType.button,
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(5),
                          child: InkWell(
                            focusNode: focusNode,
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Theme.of(context).highlightColor,
                            onTap: () {
                              setState(() {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FlatButton(
                                        padding: const EdgeInsets.all(24.0),
                                        onPressed: () {
                                          setState(() {
                                            addictionData['consumption_type'] =
                                                0;
                                            _consumptionType = local.quantity;
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          local.quantity.capitalizeWords(),
                                        ),
                                      ),
                                      FlatButton(
                                        padding: const EdgeInsets.all(24.0),
                                        onPressed: () {
                                          setState(() {
                                            addictionData['consumption_type'] =
                                                1;
                                            _consumptionType = local.hour(0);
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: Text(
                                          local.hour(0).capitalizeWords(),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            },
                            child: Container(
                              height: Theme.of(context).buttonTheme.height * 2,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).canvasColor,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    local.consumptionType.capitalizeWords(),
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  Text(
                                    _consumptionType != null
                                        ? _consumptionType.capitalizeWords()
                                        : local.quantity.capitalizeWords(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CustomTextFormField(
                  valKey: 'daily_consumption',
                  data: addictionData,
                  inputName: local.dailyConsumption.capitalizeWords(),
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (double.tryParse(value) == null) {
                      return local.pleaseEnterANumber.capitalizeFirstLetter();
                    } else if (double.parse(value) < 0) {
                      return local.valueMustBePositive.capitalizeFirstLetter();
                    } else {
                      return null;
                    }
                  },
                  inputAction: TextInputAction.next,
                ),
                CustomTextFormField(
                  valKey: 'unit_cost',
                  data: addictionData,
                  inputName: local.unitCost.capitalizeWords(),
                  inputType: TextInputType.number,
                  // onSubmit: () => trySubmit(context),
                  validator: (value) {
                    if (double.tryParse(value) == null) {
                      return local.pleaseEnterANumber.capitalizeFirstLetter();
                    } else if (double.parse(value) < 0) {
                      return local.valueMustBePositive.capitalizeFirstLetter();
                    } else {
                      return null;
                    }
                  },
                  inputAction: TextInputAction.done,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () => trySubmit(context),
                  child: Container(
                    width: deviceSize.width,
                    height: deviceSize.height * .1,
                    alignment: Alignment.center,
                    child: Text(
                      local.quitAddiction.capitalizeWords(),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
