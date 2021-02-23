import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions.dart';
import 'package:flutter_quit_addiction_app/widgets/personal_note_create.dart';
import 'package:flutter_quit_addiction_app/widgets/note.dart';
import 'package:provider/provider.dart';

class PersonalNotesView extends StatefulWidget {
  PersonalNotesView({
    @required this.addictionData,
  });
  final Addiction addictionData;
  @override
  _PersonalNotesViewState createState() => _PersonalNotesViewState();
}

class _PersonalNotesViewState extends State<PersonalNotesView> {
  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);
    return Column(
      children: [
        Flexible(
          flex: 1,
          child: ButtonBar(
            buttonPadding: const EdgeInsets.all(0),
            buttonMinWidth: double.maxFinite,
            buttonHeight: double.maxFinite,
            children: [
              FlatButton(
                color: Theme.of(context).primaryColorLight,
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) {
                      return CreatePersonalNote(
                        addictionId: widget.addictionData.id,
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text(
                      local.newNote.capitalizeWords(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 5,
          child: FutureBuilder(
            future: Provider.of<Addictions>(context, listen: false).fetchNotes(
              widget.addictionData.id,
            ),
            builder: (_, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : snapshot.error != null
                      ? Center(
                          child: Text(local.genericErrorMessage
                              .capitalizeFirstLetter()),
                        )
                      : Consumer<Addictions>(
                          builder: (_, addictionsData, _child) =>
                              ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount:
                                widget.addictionData.personalNotes.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Note(
                                  data:
                                      widget.addictionData.personalNotes[index],
                                ),
                              );
                            },
                          ),
                        );
            },
          ),
        ),
      ],
    );
  }
}
