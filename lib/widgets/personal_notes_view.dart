import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_quit_addiction_app/extensions/string_extension.dart';
import 'package:flutter_quit_addiction_app/models/addiction.dart';
import 'package:flutter_quit_addiction_app/providers/addictions_provider.dart';
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
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: FutureBuilder(
            future: Provider.of<AddictionsProvider>(context, listen: false)
                .fetchNotes(
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
                      : Consumer<AddictionsProvider>(
                          builder: (_, addictionsData, _child) =>
                              widget.addictionData.personalNotes.length == 0
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 16.0),
                                      child: Divider(
                                        thickness: 1,
                                        height: 0,
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: widget
                                          .addictionData.personalNotes.length,
                                      itemBuilder: (_, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
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
          elevation: 12.0,
          highlightElevation: 8.0,
          tooltip: local.newNote.capitalizeWords(),
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
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
