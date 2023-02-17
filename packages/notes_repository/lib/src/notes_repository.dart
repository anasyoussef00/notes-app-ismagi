import 'models/models.dart';
import 'package:dio/dio.dart';

class NotesRepository {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api/',
      contentType: 'application/json',
    ),
  );

  Future<List<Note>> getAllNotes() async {
    try {
      var response = await dio.get('/notes/');
      var data = (response.data as List).map((i) => Note.fromJson(i)).toList();
      return data;
    } on DioError catch (e) {
      throw Exception(
        'Something wrong happened while trying to get all notes from the database. ERR_MSG: ${e.message}',
      );
    }
  }

  Future<void> storeNote(Note note) async {
    try {
      await dio.post(
        '/notes/create/',
        data: {
          'title': note.title,
          'body': note.body,
        },
      );
    } on DioError catch (e) {
      throw Exception(
        'Something wrong happened while trying to store your note in the database. ERR_MSG: ${e.message}',
      );
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await dio.put(
        '/notes/${note.id}/update/',
        data: {
          'title': note.title,
          'body': note.body,
        },
      );
    } on DioError catch (e) {
      throw Exception(
        'Something wrong happened while trying to update your note in the database. ERR_MSG: ${e.message}',
      );
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await dio.delete('/notes/$id/delete/');
    } on DioError catch (e) {
      throw Exception(
        'Something wrong happened while trying to delete your note from the database. ERR_MSG: ${e.message}',
      );
    }
  }
}
