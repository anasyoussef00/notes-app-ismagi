import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notes_repository/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc({required NotesRepository notesRepository})
      : _notesRepository = notesRepository,
        super(const NotesState()) {
    on<NoteFetchAllNotes>(_onNoteFetchAllNotes);
    on<NoteTitleChanged>(_onNoteTitleChanged);
    on<NoteBodyChanged>(_onNoteBodyChanged);
    on<NoteSubmitted>(_onNoteSubmitted);
    on<NoteUpdateSubmitted>(_onNoteUpdateSubmitted);
    on<NoteDeleted>(_onNoteDeleted);
  }

  final NotesRepository _notesRepository;

  Future<void> _onNoteFetchAllNotes(
    NoteFetchAllNotes event,
    Emitter<NotesState> emit,
  ) async {
    try {
      var notes = await _notesRepository.getAllNotes();
      return emit(state.copyWith(notes: notes));
    } catch (e) {
      print(e);
    }
  }

  void _onNoteTitleChanged(
    NoteTitleChanged event,
    Emitter<NotesState> emit,
  ) =>
      emit(state.copyWith(title: event.title));

  void _onNoteBodyChanged(
    NoteBodyChanged event,
    Emitter<NotesState> emit,
  ) =>
      emit(state.copyWith(body: event.body));

  Future<void> _onNoteSubmitted(
    NoteSubmitted event,
    Emitter<NotesState> emit,
  ) async {
    try {
      var note = Note(title: state.title, body: state.body);
      await _notesRepository.storeNote(note);
      return emit(state);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onNoteUpdateSubmitted(
    NoteUpdateSubmitted event,
    Emitter<NotesState> emit,
  ) async {
    try {
      var note = Note(
        id: event.id,
        title: state.title,
        body: state.body,
      );
      await _notesRepository.updateNote(note);
      return emit(state);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _onNoteDeleted(
    NoteDeleted event,
    Emitter<NotesState> emit,
  ) async {
    try {
      await _notesRepository.deleteNote(event.id);
      return emit(state);
    } catch (e) {
      print(e);
    }
  }
}
