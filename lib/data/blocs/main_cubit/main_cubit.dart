import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(AppCubitInitialState());
  static MainCubit get(context) => BlocProvider.of(context);
  List<Map> notes = [];
  late Database database;

  void createDatabase() {
    openDatabase('Notes.db', version: 1, onCreate: (db, version) {
      {
        print("db created");
        db
            .execute(
                'CREATE TABLE NOTES (ID INTEGER PRIMARY KEY,TITLE STRING,BODY STRING,DATE STRING)')
            .then((value) {
          print('table created');
        }).catchError((onError) {
          print(onError.toString());
        });
      }
    }, onOpen: (db) {
      getDataFromDatabase(db);
      emit(NotesSuccessGetDataFromDb());
      print('database opened');
    }).then((value) {
      database = value;
      emit(NotesAppDbCreation());
    });
  }

  void getDataFromDatabase(database) {
    notes = [];
    emit(NotesLoadingGetDataFromDb());
    database.rawQuery('SELECT * FROM NOTES').then((value) {
      value.forEach((element) {
        notes.add(element);
      });
      emit(NotesSuccessGetDataFromDb());
    });
  }

  void insertToDatabase(
      {required String title,
      required String body,
      required String date}) async {
    await database.transaction((txn) {
      emit(NotesLoadingInsertion());
      return txn
          .rawInsert('INSERT INTO NOTES (TITLE,BODY,DATE)'
              'VALUES("$title","$body","$date")')
          .then((value) {
        print('$value inserted successfully');
        emit(NotesInsertionSuccessfully());
        getDataFromDatabase(database);
        emit(NotesSuccessGetDataFromDb());
      }).catchError((error) {
        print(error.toString());
        emit(NotesInsertionError());
      });
    });
  }

  void updateDb({required String date, required int id}) async {
    database.rawUpdate('UPDATE NOTES SET DATE =? WHERE ID=?', [date, id]).then(
        (value) {
      getDataFromDatabase(database);
      emit(NotesUpdateDbSuccessfully());
    }).catchError((error) {
      emit(ErrorInNotesInUpdateDb());
    });
  }

  void deleteFromDb({required int id}) async {
    database.rawDelete('DELETE FROM NOTES WHERE ID=?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(SuccessInDeletionFromDb());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorInDeletionFromDb());
    });
  }

  void deleteAllQueries() {
    database.rawDelete('DELETE FROM NOTES').then((value) {
      getDataFromDatabase(database);
      emit(SuccessInDeletionAllQueries());
    }).catchError((error) {
      emit(ErrorInDeletionAllQueries());
    });
  }
}
