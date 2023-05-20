// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:special_notes/constants/hive_box.dart';
import 'package:special_notes/models/note_model.dart';
import 'package:special_notes/repository/note_repository.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, this.noteModel, this.index});
  final NoteModel? noteModel;
  final int? index;

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController titleC = TextEditingController();
  TextEditingController desC = TextEditingController();
  NoteRepository noteRepository = NoteRepository();
  bool check = false;
  DateTime? dateTime;
  TimeOfDay? timeOfDay;
  DateFormat dateFormat = DateFormat('HH:mm');

  @override
  void initState() {
    setEdit();
    super.initState();
  }

  setEdit() async {
    await Future.delayed(Duration.zero);
    if (widget.noteModel != null) {
      titleC.text = widget.noteModel?.title ?? '';
      desC.text = widget.noteModel?.description ?? '';
      if (widget.noteModel?.notiTime != null) {
        check = true;
        dateTime = DateTime.parse(widget.noteModel!.notiTime!);
        timeOfDay = TimeOfDay.fromDateTime(dateTime!);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.noteModel != null ? 'Edit Note' : 'Add Note'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: titleC,
                          decoration: InputDecoration(
                            label: Text(widget.noteModel != null
                                ? "Edit Title"
                                : "Add Title"),
                          ),
                        ),
                        TextFormField(
                          controller: desC,
                          maxLines: 5,
                          decoration: InputDecoration(
                            label: Text(widget.noteModel != null
                                ? "Edit description"
                                : "Add description"),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                                value: check,
                                onChanged: (v) {
                                  if (!check) {
                                    check = true;
                                  } else {
                                    check = false;
                                  }
                                  setState(() {});
                                }),
                            const Text('Use Notification'),
                          ],
                        ),
                        if (check == true)
                          InkWell(
                            onTap: () async {
                              var value = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (value != null) {
                                dateTime = value;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  dateTime != null
                                      ? Text(
                                          "Selected Day : ${dateTime.toString().split(" ")[0]}")
                                      : const Text(
                                          "Selected Day : DD/MM/YYYY "),
                                ],
                              ),
                            ),
                          ),
                        if (check == true)
                          InkWell(
                            onTap: () async {
                              var value = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (value != null) {
                                timeOfDay = value;
                              }
                              setState(() {});
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Wrap(
                                children: [
                                  const Text("Selected time : "),
                                  Text(
                                    timeOfDay != null
                                        ? dateFormat.format(DateTime.parse(
                                            dateTime.toString().split(" ")[0] +
                                                " " +
                                                timeOfDay!.hour
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                ':' +
                                                timeOfDay!.minute
                                                    .toString()
                                                    .padLeft(2, '0') +
                                                ':00'))
                                        : 'HH:mm',
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // display list of devices when navigate as add device

                        // display list of devices when navigate as add borrow
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 48),
                      backgroundColor: Colors.purple.withOpacity(0.5)),
                  onPressed: () async {
                    // add borrow
                    if (titleC.text.isEmpty || desC.text.isEmpty) {
                      Fluttertoast.showToast(msg: "Please fill the Blank");
                      return;
                    }
                    if (widget.noteModel != null) {
                      var edit = NoteModel(
                        id: Hive.box<NoteModel>(HiveBox.notes.name)
                                .values
                                .length +
                            1,
                        title: titleC.text,
                        description: desC.text,
                        notiTime: check == true
                            ? dateTime.toString().split(" ")[0] +
                                " " +
                                timeOfDay!.hour.toString().padLeft(2, '0') +
                                ':' +
                                timeOfDay!.minute.toString().padLeft(2, '0') +
                                ':00'
                            : null,
                        createdTime: DateTime.now().toString(),
                      );
                      noteRepository.updateNotes(widget.index!, edit);
                      titleC.clear();
                      desC.clear();
                      check = false;
                      dateTime = null;
                      timeOfDay = null;
                      setState(() {});
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: "Edited!");
                      return;
                    }

                    var newNote = NoteModel(
                      id: Hive.box<NoteModel>(HiveBox.notes.name)
                              .values
                              .length +
                          1,
                      title: titleC.text,
                      description: desC.text,
                      notiTime: check == true
                          ? dateTime.toString().split(" ")[0] +
                              " " +
                              timeOfDay!.hour.toString().padLeft(2, '0') +
                              ':' +
                              timeOfDay!.minute.toString().padLeft(2, '0') +
                              ':00'
                          : null,
                      createdTime: DateTime.now().toString(),
                    );
                    noteRepository.addNotes(newNote);
                    titleC.clear();
                    desC.clear();
                    check = false;
                    dateTime = null;
                    timeOfDay = null;
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "added!");
                  },
                  child: Text(
                    widget.noteModel != null ? "Edit" : "Add",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
