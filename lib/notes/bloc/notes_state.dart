part of 'notes_bloc.dart';

// @immutable
// abstract class NotesState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }

class NotesState extends Equatable {
  const NotesState({
    this.notes = const <Note>[],
    this.title = '',
    this.body = '',
  });

  NotesState copyWith({
    List<Note>? notes,
    String? title,
    String? body,
  }) =>
      NotesState(
        notes: notes ?? this.notes,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  final List<Note> notes;
  final String title;
  final String body;

  @override
  List<Object?> get props => [notes, title, body];
}
