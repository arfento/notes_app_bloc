part of 'main_cubit.dart';

abstract class MainState {}

class AppCubitInitialState extends MainState {}

class NotesAppDbCreation extends MainState {}

class NotesLoadingInsertion extends MainState {}

class NotesInsertionSuccessfully extends MainState {}

class NotesInsertionError extends MainState {}

class NotesLoadingGetDataFromDb extends MainState {}

class NotesSuccessGetDataFromDb extends MainState {}

class NotesErrorGetDataFromDb extends MainState {}

class NotesUpdateDbSuccessfully extends MainState {}

class ErrorInNotesInUpdateDb extends MainState {}

class SuccessInDeletionFromDb extends MainState {}

class ErrorInDeletionFromDb extends MainState {}

class ErrorInDeletionAllQueries extends MainState {}

class SuccessInDeletionAllQueries extends MainState {}
