part of 'notes_overview_bloc.dart';

enum NotesOverviewStatus { loading, loaded, error }

final class NotesOverviewState extends Equatable {
  const NotesOverviewState({
    this.status = NotesOverviewStatus.loading,
    this.notes = const IList<Note>.empty(),
    this.message = const UniqueNotification.empty(),
    this.lastDeletedNote = const Note.empty(),
    this.inputField = '',
    this.isDarkTheme = false,
    this.editingNoteId = 0,
    this.filteredNotes = const IList<Note>.empty(),
    this.searchStatus = false,
    this.datePicked = 0,
    this.cleanInputField = false,
  });

  final NotesOverviewStatus status;
  final IList<Note> notes;
  final int editingNoteId;
  final Note lastDeletedNote;
  final UniqueNotification message;
  final String inputField;
  final bool isDarkTheme;
  final IList<Note> filteredNotes;
  final bool searchStatus;
  final int datePicked;
  final bool cleanInputField;

  NotesOverviewState copyWith({
    NotesOverviewStatus? status,
    IList<Note>? notes,
    Note? lastDeletedNote,
    UniqueNotification? message,
    String? inputField,
    int? editingNoteId,
    IList<Note>? filteredNotes,
    bool? searchStatus,
    int? datePicked,
    bool? cleanInputField,
  }) {
    return NotesOverviewState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      lastDeletedNote: lastDeletedNote ?? this.lastDeletedNote,
      message: message ?? this.message,
      inputField: inputField ?? this.inputField,
      editingNoteId: editingNoteId ?? this.editingNoteId,
      filteredNotes: filteredNotes ?? this.filteredNotes,
      searchStatus: searchStatus ?? this.searchStatus,
      datePicked: datePicked ?? this.datePicked,
      cleanInputField: cleanInputField ?? this.cleanInputField,
    );
  }

  @override
  List<Object> get props => [
        status,
        notes,
        message,
        lastDeletedNote,
        inputField,
        editingNoteId,
        filteredNotes,
        searchStatus,
        datePicked,
        cleanInputField,
      ];
}
