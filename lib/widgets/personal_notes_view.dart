import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quittle/extensions/string_extension.dart';
import 'package:quittle/models/addiction.dart';
import 'package:quittle/models/personal_note.dart';
import 'package:quittle/providers/addictions_provider.dart';
import 'package:quittle/widgets/personal_note_create.dart';
import 'package:quittle/widgets/note.dart';
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24.0),
          child: FutureBuilder(
            future: Provider.of<AddictionsProvider>(context, listen: false)
                .fetchNotes(
              widget.addictionData.id,
            ),
            builder: (_, snapshot) {
              return snapshot.error != null
                  ? Center(
                      child: Text(
                          local.genericErrorMessage.capitalizeFirstLetter()),
                    )
                  : Consumer<AddictionsProvider>(
                      builder: (_, addictionsData, _child) =>
                          widget.addictionData.personalNotes.length == 0
                              ? Note(
                                  data: PersonalNote(
                                    title: 'your journey begins',
                                    text:
                                        'here you can take notes. you can keep your motivations, memories etc. keep record of your journey becoming free of your bad habit/addiction!',
                                    date: DateTime.now().toString(),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      widget.addictionData.personalNotes.length,
                                  itemBuilder: (_, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Note(
                                        data: widget.addictionData
                                                .personalNotesDateSorted[
                                            index], // todo date sort ascend descend button
                                      ),
                                    );
                                  },
                                ),
                    );
            },
          ),
        ),
        FloatingActionButton(
          heroTag: null,
          elevation: 12.0,
          highlightElevation: 8.0,
          tooltip: local.newNote.capitalizeWords(),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              useRootNavigator: true,
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return CreatePersonalNote(
                  addictionId: widget.addictionData.id,
                );
              },
            );
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
