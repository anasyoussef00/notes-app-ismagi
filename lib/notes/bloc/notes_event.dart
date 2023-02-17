part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NoteFetchAllNotes extends NotesEvent {}

class NoteTitleChanged extends NotesEvent {
  NoteTitleChanged({required this.title});

  final String title;

  @override
  List<Object?> get props => [title];
}

class NoteBodyChanged extends NotesEvent {
  NoteBodyChanged({required this.body});

  final String body;

  @override
  List<Object?> get props => [body];
}

class NoteSubmitted extends NotesEvent {}

class NoteUpdateSubmitted extends NotesEvent {
  NoteUpdateSubmitted({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

class NoteDeleted extends NotesEvent {
  NoteDeleted({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
