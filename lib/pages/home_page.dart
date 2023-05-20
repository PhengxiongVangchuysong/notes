import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:special_notes/constants/hive_box.dart';
import 'package:special_notes/models/note_model.dart';
import 'package:special_notes/pages/add_note.dart';
import 'package:special_notes/pages/details.dart';
import 'package:special_notes/repository/note_repository.dart';
import 'package:special_notes/repository/send_noti.dart';
import 'package:special_notes/widgets/display_box_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SendNoti sendNoti = SendNoti();
  TextEditingController serchT = TextEditingController();
  NoteRepository noteRepository = NoteRepository();
  DateFormat dateFormat = DateFormat('dd/MM/yyyy HH:mm');
  Timer? timer;

  listenTime() async {
    await Future.delayed(Duration.zero);
    const oneSec = Duration(milliseconds: 800);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (mounted) {
        setState(
          () {
            for (var element
                in Hive.box<NoteModel>(HiveBox.notes.name).values) {
              if (element.notiTime != null) {
                if (DateTime.parse(element.notiTime ?? '').year ==
                        DateTime.now().year &&
                    DateTime.parse(element.notiTime ?? '').month ==
                        DateTime.now().month &&
                    DateTime.parse(element.notiTime ?? '').day ==
                        DateTime.now().day &&
                    DateTime.parse(element.notiTime ?? '').hour ==
                        DateTime.now().hour &&
                    DateTime.parse(element.notiTime ?? '').minute ==
                        DateTime.now().minute) {
                  sendNoti.showNoti(element);
                }
              }
            }
          },
        );
      }
    });
  }

  @override
  void initState() {
    listenTime();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setnewListen() {
    timer!.cancel();
    listenTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 4),
            //   child: TextFormField(
            //     decoration: InputDecoration(
            //       filled: true,
            //       isDense: true,
            //       fillColor: const Color.fromRGBO(211, 187, 255, 100),
            //       prefixIcon: const Icon(
            //         Icons.search,
            //         color: Colors.black45,
            //       ),
            //       hintText: 'Search',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(16.0),
            //         borderSide: BorderSide.none,
            //       ),

            //     ),
            //   ),
            // ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: DisplayBoxWidget<NoteModel>(
                hiveBox: HiveBox.notes,
                child: (context, index, note) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Details(noteModel: note)));
                    },
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: const Color.fromRGBO(211, 187, 255, 100),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          note.title ?? '',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        InkWell(
                                            onTap: () {
                                              noteRepository.deleteNotes(index);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        note.description ?? '',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.black),
                                      ),
                                    ),
                                    note.notiTime != null
                                        ? Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.notifications,
                                                  color: Colors.purple,
                                                ),
                                                Text(
                                                  dateFormat
                                                      .format(DateTime.parse(
                                                          note.notiTime ?? ''))
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          )
                                        : const SizedBox(
                                            height: 10,
                                          )
                                  ],
                                ),
                              ],
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNote(
                                                  index: index,
                                                  noteModel: note,
                                                )));
                                    setnewListen();
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddNote()));
          setnewListen();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
