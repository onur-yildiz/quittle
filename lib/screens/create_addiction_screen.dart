import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/screens/addictions_screen.dart';
import 'package:flutter_quit_addiction_app/widgets/custom_text_form_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateAddictionScreen extends StatelessWidget {
  static const routeName = '/create-addiction';

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).accentColor,
                  Theme.of(context).accentColor,
                  Theme.of(context).primaryColorLight,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                stops: [0, .3, .8, 1],
              ),
            ),
          ),
          AddictionCard(statusBarHeight),
        ],
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
  FocusNode focusNode;
  var _consumptionType = ConsumptionType.quantity;
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
      Provider.of<Addictions>(context, listen: false)
          .createAddiction(addictionData);
      Navigator.of(ctx).popAndPushNamed(AddictionsScreen.routeName);
    }
  }

  @override
  void initState() {
    focusNode = new FocusNode();
    focusNode.requestFocus();
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      margin: EdgeInsets.all(0),
      color: Theme.of(context).cardColor.withAlpha(110),
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
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Color.fromRGBO(255, 255, 255, 0.4),
                  ),
                  width: deviceSize.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor.withAlpha(150),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // padding: EdgeInsets.only(right: 10),
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
                                      DateTime.parse(
                                          addictionData['quit_date']),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: deviceSize.width * .1,
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
                      Container(
                        // for some reason, it needs 2 higher padding than the other container to be at the same height
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor.withAlpha(150),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
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
                            ),
                            DropdownButton(
                              dropdownColor: Theme.of(context).cardColor,
                              isDense: true,
                              underline: Container(),
                              value: _consumptionType,
                              items: [
                                DropdownMenuItem(
                                  child: Text(local.quantity.capitalizeWords()),
                                  value: ConsumptionType.quantity,
                                ),
                                DropdownMenuItem(
                                  child: Text(local.hour(0).capitalizeWords()),
                                  value: ConsumptionType.hour,
                                ),
                              ],
                              onChanged: (value) {
                                setState(
                                  () {
                                    _consumptionType = value;
                                    switch (value) {
                                      case ConsumptionType.quantity:
                                        addictionData['consumption_type'] = 0;
                                        break;
                                      case ConsumptionType.hour:
                                        addictionData['consumption_type'] = 1;
                                        break;
                                      default:
                                    }
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
                  isLast: true,
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onPressed: () => trySubmit(context),
                  child: Container(
                    width: deviceSize.width,
                    height: deviceSize.height * .15,
                    alignment: Alignment.center,
                    child: Text(
                      local.quitAddiction.capitalizeWords(),
                      style: TextStyle(
                        color: Theme.of(context).accentTextTheme.button.color,
                        fontSize: 20,
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
