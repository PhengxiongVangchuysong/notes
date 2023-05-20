import 'package:hive/hive.dart';
part 'note_model.g.dart';

@HiveType(typeId: 3)
class NoteModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? title;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? createdTime;
  @HiveField(4)
  final String? notiTime;

  NoteModel(
      {this.id, this.title, this.description, this.createdTime, this.notiTime});
}
