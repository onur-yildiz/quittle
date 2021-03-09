import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animations/animations.dart';

import 'package:quittle/extensions/datetime_extension.dart';
import 'package:quittle/extensions/timeofday_extension.dart';
import 'package:quittle/models/addiction_item_screen_args.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/screens/addiction_item_screen.dart';
import 'package:quittle/util/progress_constants.dart';
import 'package:quittle/widgets/custom_text_form_field.dart';

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

class _AddictionCardState extends State<AddictionCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String _consumptionType;
  FocusNode _focusNode;
  AnimationController _dpAnimController;
  var addictionData = {
    'name': '',
    'quit_date': DateTime.now().toString(),
    'consumption_type': 0,
    'daily_consumption': 1.0,
    'unit_cost': 1.0,
    'level': 0,
    'achievement_level': 0,
  };

  void _selectDate(context, DateTime currentlyPicked) async {
    //pick date
    DateTime date = await showDatePicker(
      context: context,
      builder: (context, child) {
        _dpAnimController.forward();
        return FadeScaleTransition(
          animation: _dpAnimController,
          child: child,
        );
      },
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 900)),
      lastDate: DateTime.now(),
    );
    _dpAnimController.reset();

    // check if datepicker canceled
    if (date != null) {
      TimeOfDay time = await showTimePicker(
        context: context,
        builder: (context, child) {
          _dpAnimController.forward();
          return FadeScaleTransition(
            animation: _dpAnimController,
            child: child,
          );
        },
        initialTime: TimeOfDay.now(),
      );
      _dpAnimController.reset();

      // check if timepicker canceled
      if (time != null) {
        // if date is today, check if picked time is in future
        // if it is, cancel and reset the date.
        if (date.isSameDate(DateTime.now())) {
          if (time.asDuration.inSeconds <=
              TimeOfDay.now().asDuration.inSeconds) {
            date = date.add(time.asDuration);
          } else {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).cantPickFutureTime,
                  ),
                ),
              );
            date = date.add(TimeOfDay.now().asDuration);
          }
        } else // if date is not today, add picked time
          date = date.add(time.asDuration);
      } else // if time = null (canceled)
        date = currentlyPicked;
    } else // if date = null (canceled)
      date = currentlyPicked;

    addictionData['quit_date'] = date.toString();
    Duration quitDuration = DateTime.now().difference(date);
    setState(() {
      int temp = levelDurations
          .indexWhere((element) => quitDuration.inSeconds < element.inSeconds);
      addictionData['level'] =
          temp == -1 ? levelDurations.length - 1 : temp - 1;
      temp = achievementDurations
          .indexWhere((element) => quitDuration.inSeconds < element.inSeconds);
      addictionData['achievement_level'] =
          temp == -1 ? achievementDurations.length - 1 : temp - 1;
    });
  }

  void trySubmit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      final newAddiction =
          await Provider.of<AddictionsProvider>(context, listen: false)
              .createAddiction(addictionData);
      Navigator.of(context).popAndPushNamed(
        AddictionItemScreen.routeName,
        arguments: AddictionItemScreenArgs(newAddiction),
      );
    }
  }

  @override
  void initState() {
    _dpAnimController = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _focusNode = new FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _dpAnimController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    final deviceSize = MediaQuery.of(context).size;

    return Container(
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
                  inputName: local.addictionName,
                  inputType: TextInputType.name,
                  inputAction: TextInputAction.next,
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
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Theme.of(context).highlightColor,
                            onTap: () {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                _selectDate(
                                  context,
                                  DateTime.parse(addictionData['quit_date']),
                                );
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
                                    local.date,
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
                            focusNode: _focusNode,
                            borderRadius: BorderRadius.circular(5),
                            splashColor: Theme.of(context).highlightColor,
                            onTap: () {
                              setState(() {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) => Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        TextButton.icon(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.all(32.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              FocusScope.of(context).unfocus();
                                              addictionData[
                                                  'consumption_type'] = 0;
                                              _consumptionType = local.quantity;
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.iso_outlined,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          label: Text(
                                            local.quantity,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          indent: 8,
                                          endIndent: 8,
                                          height: 0,
                                        ),
                                        TextButton.icon(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.all(32.0),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              addictionData[
                                                  'consumption_type'] = 1;
                                              _consumptionType = local.hour(0);
                                              Navigator.of(context).pop();
                                            });
                                          },
                                          icon: Icon(
                                            Icons.hourglass_bottom_rounded,
                                            color: Theme.of(context).hintColor,
                                          ),
                                          label: Text(
                                            local.hour(0),
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).hintColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    local.consumptionType,
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
                                        ? _consumptionType
                                        : local.quantity,
                                    style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .fontSize,
                                      color: Theme.of(context).hintColor,
                                    ),
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
                  inputName: local.dailyConsumption,
                  inputType: TextInputType.number,
                  validator: (value) {
                    if (double.tryParse(value) == null) {
                      return local.pleaseEnterANumber;
                    } else if (double.parse(value) < 0) {
                      return local.valueMustBePositive;
                    } else {
                      return null;
                    }
                  },
                  maxLength: 10,
                  inputAction: TextInputAction.next,
                ),
                CustomTextFormField(
                  valKey: 'unit_cost',
                  data: addictionData,
                  inputName: local.unitCost,
                  inputType: TextInputType.number,
                  onSubmit: trySubmit,
                  validator: (value) {
                    if (double.tryParse(value) == null) {
                      return local.pleaseEnterANumber;
                    } else if (double.parse(value) < 0) {
                      return local.valueMustBePositive;
                    } else {
                      return null;
                    }
                  },
                  maxLength: 10,
                  inputAction: TextInputAction.done,
                ),
                ElevatedButton(
                  onPressed: trySubmit,
                  child: Container(
                    width: deviceSize.width,
                    height: deviceSize.height * .1,
                    alignment: Alignment.center,
                    child: Text(
                      local.quitAddiction,
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
