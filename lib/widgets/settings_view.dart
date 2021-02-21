import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _progressCheck = false;
  bool _quoteCheck = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final deviceHeight = mediaQuery.size.height;
    final deviceWidth = mediaQuery.size.width;
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: deviceHeight * .1,
            child: DrawerHeader(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.headline6.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 15.0,
              children: [
                CheckboxListTile(
                  title: Text('Progress Notifications'),
                  subtitle: Text('Enable push notifications for milestones'),
                  value: _progressCheck,
                  onChanged: (value) {
                    setState(() {
                      _progressCheck = value;
                    });
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                CheckboxListTile(
                  title: Text('Quote of the Day'),
                  subtitle: Text('Enable push notifications for daily quotes'),
                  value: _quoteCheck,
                  onChanged: (value) {
                    setState(() {
                      _quoteCheck = value;
                    });
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                ListTile(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => new SimpleDialog(
                      backgroundColor: Theme.of(context).cardColor,
                      contentPadding: EdgeInsets.zero,
                      children: [
                        Container(
                          color: Theme.of(context).canvasColor,
                          height: deviceHeight * .75,
                          width: deviceWidth * .3,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FlatButton(
                                  onPressed: () {},
                                  child: Text('data'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                FlatButton(
                                  onPressed: () {},
                                  child: Text('data'),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                                FlatButton(
                                    onPressed: () {}, child: Text('data')),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  isThreeLine: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.attach_money),
                  title: Text('Currency'),
                  subtitle: Text('USD'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Column(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: [
//     Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       // mainAxisSize: MainAxisSize.max,
//       children: [
//         Text('data'),
//         Checkbox(
//           value: _check,
//           onChanged: (value) {
//             setState(() {
//               print('CHECK');
//               _check = value;
//             });
//           },
//         ),
//       ],
//     ),
//   ],
// ),
