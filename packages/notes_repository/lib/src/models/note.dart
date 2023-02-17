import 'package:equatable/equatable.dart';

class Note extends Equatable {
  const Note({this.id, required this.title, required this.body});

  final int? id;
  final String title;
  final String body;

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        body: json['body'],
      );

  @override
  List<Object?> get props => [id, title, body];
}
