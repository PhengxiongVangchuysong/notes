import 'package:special_notes/models/note_model.dart';
import 'package:special_notes/services/notification_service.dart';

class SendNoti {
  showNoti(NoteModel noteModel) async {
    await NotificationService.instance.showLocalNotification(
        id: noteModel.id!,
        title: noteModel.title ?? '',
        body: noteModel.description ?? '',
        payload: 'notes');
  }
}
