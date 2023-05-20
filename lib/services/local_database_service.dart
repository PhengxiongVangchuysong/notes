import 'package:hive_flutter/adapters.dart';
import 'package:special_notes/constants/hive_box.dart';
import 'package:special_notes/models/note_model.dart';

typedef RegisterAdapter = void Function<T>(
  TypeAdapter<T> adapter, {
  bool internal,
  bool override,
});

class LocalDatabaseService {
  /// private constructor
  LocalDatabaseService._();

  /// the one and only instance of this singleton
  static final instance = LocalDatabaseService._();

  Future<void> initialize() async {
    // set hive path and initialize hive
    await Hive.initFlutter();
    // register adapters
    // TODO: I think this path need to be more dynamic, so we can you this service in every projects
    Hive.registerAdapter(NoteModelAdapter());

    // open boxes
    // TODO: the same above
    await Future.wait(
      [
        Hive.openBox<NoteModel>(HiveBox.notes.name),
      ],
    );
  }

  /// ### added data into specific box base on type you put
  ///
  /// [T] is model
  ///
  /// [hiveBox] is box, you want to interact with
  ///
  /// [data] is new data to add to the box
  Future<void> add<T>(HiveBox hiveBox, T data) async {
    final box = Hive.box<T>(hiveBox.name);
    await box.add(data);
  }

  /// ### Update data by index
  ///
  /// [T] is model
  ///
  /// [hiveBox] is box, you want to interact with
  ///
  /// [data] is new data to udpate to the box
  ///
  /// [index] is position you to update
  Future<void> putAt<T>(HiveBox hiveBox, int index, T data) async {
    final box = Hive.box<T>(hiveBox.name);
    await box.putAt(index, data);
  }

  /// ### Delete data by index
  ///
  /// [T] is model
  ///
  /// [hiveBox] is box, you want to interact with
  ///
  /// [index] is position you to delete
  Future<void> deleteAt<T>(HiveBox hiveBox, int index) async {
    final box = Hive.box<T>(hiveBox.name);
    await box.deleteAt(index);
  }

  /// ### Get data by index
  ///
  /// [T] is model
  ///
  /// [hiveBox] is box, you want to interact with
  ///
  /// [index] is position you to get
  T? getAt<T>(HiveBox hiveBox, int index) {
    final box = Hive.box<T>(hiveBox.name);
    return box.getAt(index);
  }
}
