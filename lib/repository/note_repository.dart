import 'package:special_notes/constants/hive_box.dart';
import 'package:special_notes/models/note_model.dart';
import 'package:special_notes/services/local_database_service.dart';

class NoteRepository {
  LocalDatabaseService locaD = LocalDatabaseService.instance;
  addNotes(NoteModel noteModel) async {
    await locaD.add<NoteModel>(HiveBox.notes, noteModel);
  }

  updateNotes(int index, NoteModel noteModel) async {
    await locaD.putAt<NoteModel>(HiveBox.notes, index, noteModel);
  }

  deleteNotes(int index) async {
    await locaD.deleteAt<NoteModel>(HiveBox.notes, index);
  }


}
