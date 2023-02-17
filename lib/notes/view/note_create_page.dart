import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_ismagi/notes/bloc/notes_bloc.dart';
import 'package:notes_app_ismagi/notes/view/view.dart';
import 'package:notes_repository/notes_repository.dart';

class NotesCreatePage extends StatelessWidget {
  const NotesCreatePage({super.key});

  static Route route() =>
      MaterialPageRoute(builder: (_) => const NotesCreatePage());

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => NotesRepository(),
        child: BlocProvider(
          create: (context) => NotesBloc(
            notesRepository: RepositoryProvider.of<NotesRepository>(context),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const _NoteTitleInput(),
            ),
            body: const _NoteBodyInput(),
            floatingActionButton: const _NoteSubmitButton(),
          ),
        ),
      );
}

class _NoteTitleInput extends StatelessWidget {
  const _NoteTitleInput();

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) => previous.title != current.title,
        builder: (context, state) => TextFormField(
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.black,
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
  const _NoteBodyInput();

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
  const _NoteSubmitButton();

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) =>
            previous.title != current.title || previous.body != current.body,
        builder: (context, state) =>
            state.title.isNotEmpty || state.body.isNotEmpty
                ? FloatingActionButton(
                    child: const Icon(Icons.check),
                    onPressed: () {
                      context.read<NotesBloc>().add(NoteSubmitted());
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
