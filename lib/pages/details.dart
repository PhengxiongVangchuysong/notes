import 'package:flutter/material.dart';
import 'package:special_notes/models/note_model.dart';
import 'package:special_notes/repository/note_repository.dart';

class Details extends StatefulWidget {
  const Details({super.key, required this.noteModel});
  final NoteModel noteModel;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController titleC = TextEditingController();
  TextEditingController desC = TextEditingController();
  NoteRepository noteRepository = NoteRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Detail Note'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.noteModel.title ?? '',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.noteModel.description ?? '',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black),
                        ),
                      ),
                      // display list of devices when navigate as add device

                      // display list of devices when navigate as add borrow
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
