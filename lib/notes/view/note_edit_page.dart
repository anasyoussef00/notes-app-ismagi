import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_ismagi/notes/bloc/notes_bloc.dart';
import 'package:notes_app_ismagi/notes/view/view.dart';
import 'package:notes_repository/notes_repository.dart';

class NoteEditPage extends StatelessWidget {
  const NoteEditPage({super.key, required this.note});

  final Note note;

  Route route() => MaterialPageRoute(builder: (_) => NoteEditPage(note: note));

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => NotesRepository(),
        child: BlocProvider(
          create: (context) => NotesBloc(
            notesRepository: RepositoryProvider.of<NotesRepository>(context),
          )
            ..add(NoteTitleChanged(title: note.title))
            ..add(NoteBodyChanged(body: note.body)),
          child: Scaffold(
            appBar: AppBar(
              title: _NoteTitleInput(note: note),
              actions: [
                BlocBuilder<NotesBloc, NotesState>(
                  buildWhen: (previous, current) =>
                      previous.notes.length != current.notes.length,
                  builder: (context, state) => PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () {
                          context
                              .read<NotesBloc>()
                              .add(NoteDeleted(id: note.id!));
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            body: _NoteBodyInput(note: note),
            floatingActionButton: _NoteSubmitButton(note: note),
          ),
        ),
      );
}

class _NoteTitleInput extends StatelessWidget {
  const _NoteTitleInput({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous.title != current.title,
        builder: (context, state) => TextFormField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.black,
          initialValue: note.title,
          decoration: const InputDecoration.collapsed(
            hintText: 'Title...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (title) =>
              context.read<NotesBloc>().add(NoteTitleChanged(title: title)),
        ),
      );
}

class _NoteBodyInput extends StatelessWidget {
  const _NoteBodyInput({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous.body != current.body,
        builder: (context, state) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 17.0,
                ),
                child: TextFormField(
                  initialValue: note.body,
                  decoration: const InputDecoration.collapsed(
                    hintText: "What's on your mind?",
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (body) => context
                      .read<NotesBloc>()
                      .add(NoteBodyChanged(body: body)),
                ),
              ),
            ),
          ],
        ),
      );
}

class _NoteSubmitButton extends StatelessWidget {
  const _NoteSubmitButton({required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) =>
            previous.title != current.title || previous.body != current.body,
        builder: (context, state) =>
            state.title.isNotEmpty || state.body.isNotEmpty
                ? FloatingActionButton(
                    child: const Icon(Icons.check),
                    onPressed: () {
                      context
                          .read<NotesBloc>()
                          .add(NoteUpdateSubmitted(id: note.id!));
                      Navigator.pushAndRemoveUntil(
                        context,
                        NoteListPage.route(),
                        (route) => false,
                      );
                    },
                  )
                : const SizedBox.shrink(),
      );
}
