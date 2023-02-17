import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app_ismagi/notes/bloc/notes_bloc.dart';
import 'package:notes_app_ismagi/notes/view/view.dart';
import 'package:notes_repository/notes_repository.dart';

class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  static Route route() =>
      MaterialPageRoute(builder: (_) => const NoteListPage());

  @override
  Widget build(BuildContext context) => RepositoryProvider(
        create: (context) => NotesRepository(),
        child: BlocProvider(
          create: (context) => NotesBloc(
            notesRepository: RepositoryProvider.of<NotesRepository>(context),
          )..add(NoteFetchAllNotes()),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Notes'),
            ),
            body: const _NotesList(),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.push(
                context,
                NotesCreatePage.route(),
              ),
            ),
          ),
        ),
      );
}

class _NotesList extends StatelessWidget {
  const _NotesList();

  @override
  Widget build(BuildContext context) => BlocBuilder<NotesBloc, NotesState>(
        buildWhen: (previous, current) =>
            previous.notes.length != current.notes.length,
        builder: (context, state) => RefreshIndicator(
          onRefresh: () async => context.read<NotesBloc>().add(
                NoteFetchAllNotes(),
              ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: state.notes.isNotEmpty
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1 / 1.5,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) => Card(
                      child: ListTile(
                        title: Text(state.notes[index].title),
                        subtitle: Text(state.notes[index].body),
                        onTap: () => Navigator.push(
                          context,
                          NoteEditPage(note: state.notes[index]).route(),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Text(
                      'THERE IS NOTHING TO SHOW HERE PLEASE ADD SOME NOTES.',
                    ),
                  ),
          ),
        ),
      );
}
