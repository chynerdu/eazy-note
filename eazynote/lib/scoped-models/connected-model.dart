import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';
import 'dart:convert';
import 'dart:async';
import '../database/database-helper.dart';
// import 'package:intl/intl.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

import '../models/notes-model.dart';
import '../models/user-model.dart';

mixin ConnectedNotesModel on Model {
  List <NotesModel> _notes = [];
  String _selNoteId;
   bool _isLoading = false;
   UserModel _authenticatedUser;

}

mixin NotesLists on ConnectedNotesModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  
  // define getter

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }
   bool get isLoading {
    return _isLoading;
  }
  UserModel get user {
    return _authenticatedUser;
  }
  // get date time
  String get currentDate {
    var today = new DateTime.now();
    String dateSlug ="${today.hour.toString().padLeft(2,'0')}:${today.minute.toString().padLeft(2,'0')} | ${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
    // var formatter = new DateFormat('yyyy-MM-dd');
    // int formatted = formatter.format(now);
    print(dateSlug);
    return dateSlug;
  }
  List <NotesModel> get displayedNotes {
    return List.from(_notes);
  }

  // get selected note index 
  int get selectedNoteIndex {
    return _notes.indexWhere((NotesModel note) {
      return note.id == _selNoteId;
    });
  }
  // selected Note id getter 
  String get selectedNoteId {
    return _selNoteId;
  }

  // selected note object getter
  NotesModel get selectedNote {
    if(selectedNoteId == null) {
      return null;
    }
    return _notes.firstWhere((NotesModel note) {
        return note.id == selectedNoteId;
      });
  }
  List <NotesModel> get allNotes {
    //   var entries = [
    //     {
    //     'id': '1',
    //     'title': 'How to train a dragon', 
    //     'subtitle': 'Training a dragon is not an easy as you think'
    //     },
    //     {
    //       'id': '2',
    //       'title':'ABC of making pancakes for foodies', 
    //       'subtitle': 'This is for all foodies arounf the world'
    //     },
    //     {
    //     'id': '3',
    //     'title':'All about malta',
    //     'subtitle': 'Have you ever been to malta? You should know this'
    //     },
    //     {
    //     'id': '4',
    //     'title':'Personal jottings on finance',
    //     'subtitle': 'This is a note taking from renowned writers'
    //     },
    //     { 
    //     'id': '5',
    //     'title':'10 interesting places to visit',
    //     'subtitle': 'If you plan on going on vacation, you should consider this'
    //     }
    // ];

    // // List<NotesModel> parsePhotos(String enntries) {
    // //   // final parsed = json.encode(entries);
    // //   return entries.map<NotesModel>((json) => new NotesModel.fromJson(json)).toList();
    // // }
    // List<NotesModel> list = List();
    // list = entries.map((data) => new NotesModel.fromJson(data)).toList();
    // _notes = list;
    return List.from(_notes);
  }

  //  add note
  Future <bool>  addNote(String title, String subtitle, String category) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> noteFormData = {
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'dateTime': currentDate,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post('https://eazynote-78666.firebaseio.com/notes/${_authenticatedUser.id}.json', 
      body: json.encode(noteFormData));
      if(response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final dbHelper = DatabaseHelper.instance;
      // insert into local database
      Map<String, dynamic> row = {
        DatabaseHelper.columnId: responseData['name'],
        DatabaseHelper.columnTitle : title,
        DatabaseHelper.columnSubtitle : subtitle,
        DatabaseHelper.columnCategory : category,
        DatabaseHelper.columnDateTime : currentDate
      };
      final id = await dbHelper.insert(row);
      print('inserted row id: $id');
       _isLoading = false;
      //  update state
      final NotesModel newNote = NotesModel(
        id: responseData['name'],
        title: title,
        subtitle: subtitle,
        category: category,
        dateTime: currentDate,
        userId: _authenticatedUser.id
      );
      _notes.add(newNote);
      _selNoteId = null;
      notifyListeners();
      print(newNote);
      return true;
    } catch (error) {
     print(error);
     _isLoading = false;
     notifyListeners();
     return false;
    }


  }
  // update notes
  Future <bool>  updateNote(String title, String subtitle, String category) async {
    _isLoading = true;
    notifyListeners();
    print(category);
    final Map<String, dynamic> noteFormData = {
      'title': title,
      'subtitle': subtitle,
      'category': category,
      'dateTime': currentDate,
      'userId': _authenticatedUser.id
    };
    return http.put('https://eazynote-78666.firebaseio.com/notes/${_authenticatedUser.id}/${selectedNote.id}.json',
     body: json.encode(noteFormData))
     .then((http.Response response) {
      print(noteFormData);
      final dbHelper = DatabaseHelper.instance;
      print('selected note ${selectedNote.id}');
      Map <String, dynamic> row = {
        DatabaseHelper.columnId: selectedNote.id,
        DatabaseHelper.columnTitle: title,
        DatabaseHelper.columnSubtitle: subtitle,
        DatabaseHelper.columnCategory: category,
        DatabaseHelper.columnDateTime: currentDate,
      };
      dbHelper.update(row)
      .then((rowsAffected) {
        print('updated $rowsAffected');
      });
      final NotesModel updatedNote = NotesModel(
        id: selectedNote.id,
        title: title,
        subtitle: subtitle,
        category: category,
        dateTime: currentDate,
        userId: _authenticatedUser.id
      );
      _notes[selectedNoteIndex] = updatedNote;
      _isLoading = false;
      notifyListeners();
      return true;
    }) 
    .catchError((error) {
     print(error);
     _isLoading = false;
     notifyListeners();
     return false;
    });


  }
  
  // delete database
  Future<Null> deleteDatabase() async {
    final dbHelper = DatabaseHelper.instance;
    var deleteDb = await dbHelper.deleteDatabase();
    print('delted now $deleteDb');
    notifyListeners();
  }



  Future <Null> fetchNotes() async {

    try {
    final dbHelper = DatabaseHelper.instance;
    _isLoading = true;

    // delete database
    // final response = await dbHelper.deleteDatabase();
    // print('deleted $response');

    final allRows = await dbHelper.getNotes();

    // final List<NotesModel> fetchedNoteList = [];
    print('query all rows: $allRows');
    final List<NotesModel> fetchedNoteList = [];
    allRows.forEach((dynamic noteList) {
        // print('notelist ${noteList['id']}');
        final NotesModel note = NotesModel (
          id: noteList['id'],
          title: noteList['title'],
          subtitle: noteList['subtitle'],
          category: noteList['category'],
          dateTime: noteList['dateTime']
        );
        fetchedNoteList.add(note);    
      });
      
       _notes = fetchedNoteList;
       print('notes fetched $_notes');
       _isLoading = false;
       notifyListeners();

    } catch (error) {
     _isLoading = false;
      notifyListeners();
      // return false;
    }

  }

   Future <Null> fetchNotess() async {
    // final dbHelper = DatabaseHelper.instance;
    _isLoading = true;
    
    return http.get('https://eazynote-78666.firebaseio.com/notes/${_authenticatedUser.id}.json')
    .then<Null>((http.Response response) {
      final List<NotesModel> fetchedNoteList = [];
      print('response body ${response.body}');
      final Map<String, dynamic> noteListData = json.decode(response.body);
      if (noteListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      print('decoded $noteListData');
      noteListData.forEach((String noteId, dynamic noteList) {
        final NotesModel note = NotesModel (
          id: noteId,
          title: noteList['title'],
          subtitle: noteList['subtitle'],
          category: noteList['category'],
          dateTime: noteList['dateTime']
        );
        fetchedNoteList.add(note);
      });
      _notes = fetchedNoteList;
      _isLoading = false;
      notifyListeners();
     
    })
    .catchError((error) {
     _isLoading = false;
      notifyListeners();
      // return false;
    });

  }


  
  Future <bool> deleteNote() {
    _isLoading = true;
    final deletedNoteId = selectedNote.id;
    _notes.removeAt(selectedNoteIndex);
    _selNoteId = null;
    notifyListeners();
    return http.delete('https://eazynote-78666.firebaseio.com/notes/${_authenticatedUser.id}/${deletedNoteId}.json')
    .then((http.Response response) {
      // delete in sql db
      final dbHelper = DatabaseHelper.instance;
      // final id = await dbHelper.queryRowCount();
      dbHelper.delete(deletedNoteId)
      .then((rowsDeleted) {
        _isLoading = false;
        notifyListeners();
        return true;
        // print('deleted $rowsDeleted row(s): row $deletedNoteId');
      });
    })
    .catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
  void selectNote(String noteId) {
    _selNoteId = noteId;
    notifyListeners();
  }


 
  Future <Map<String, dynamic>>signup(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map <String, dynamic> authData = {
      'email': email,
      'password' : password,
    };
    http.Response response =  await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCYEtdeXuPt0NZxjm0frL5-mxJQ_-V7KGQ',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'}
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    // print(responseData);
    bool hasError = true;
    String message = 'Something went wrong!';
    if(responseData.containsKey('idToken')) {
        hasError = false;
        message = 'Authentication succeeded!';
        _authenticatedUser = UserModel(
          id: responseData["localId"],
          email: email,
          token: responseData['idToken']
        );
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email not found';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password invalid';
    }
    _isLoading = false;
    notifyListeners();
    return {'success' : !hasError, 'message': message};
  }

  Future <Map<String, dynamic>>login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map <String, dynamic> authData = {
      'email': email,
      'password' : password,
    };
    http.Response response =  await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCYEtdeXuPt0NZxjm0frL5-mxJQ_-V7KGQ',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'}
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    // print(responseData);
    bool hasError = true;
    String message = 'Something went wrong!';
    if(responseData.containsKey('idToken')) {
        hasError = false;
        message = 'Authentication succeeded!';
        _authenticatedUser = UserModel(
          id: responseData["localId"],
          email: email,
          token: responseData['idToken']
        );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email not found';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password invalid';
    }
    _isLoading = false;
    notifyListeners();
    return {'success' : !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      _authenticatedUser = UserModel(
        id: userId,
        email: userEmail,
        token: token
      );
      _userSubject.add(true);
      notifyListeners();

    }
  }

   void logout() async {
    print('logout');
    _authenticatedUser = null;
    _notes = [];
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
   }
}

mixin Utility on ConnectedNotesModel {
   String _avatarColor = 'Colors.green';
   // define getter
   String get avatarColor {
     return _avatarColor;
  }

  getColors(firstLetter, blue, green, red, orange) {
    //  String color = blue;
     String alphabet = firstLetter;
     if (
        alphabet.contains('A') || 
        alphabet.contains('B') || 
        alphabet.contains('C') ||
        alphabet.contains('D') || 
        alphabet.contains('G') || 
        alphabet.contains('H')
     ) {
       return blue;
      //  return color;
     } else if (
        alphabet.contains('I') || 
        alphabet.contains('J') || 
        alphabet.contains('K') ||
        alphabet.contains('N') ||
        alphabet.contains('O') || 
        alphabet.contains('P')
     ) {
       return  green;
     } else if (
       alphabet.contains('Q') || 
        alphabet.contains('R') || 
        alphabet.contains('S') ||
        alphabet.contains('T') ||
        alphabet.contains('X') || 
        alphabet.contains('Y') ||
        alphabet.contains('Z')
     ) {
       return red;
     } else if (
       alphabet.contains('E') ||
       alphabet.contains('F') ||
       alphabet.contains('L') || 
       alphabet.contains('M') ||
       alphabet.contains('U') || 
       alphabet.contains('V') ||
       alphabet.contains('W') 
     ) {
       return orange;
     }
     return blue;
  }

  getCategoryStyle(category, grey, brown, black, blue) {
    if (category == "1") {
      return grey;
    } else if (category == "2") {
      return blue;
    } else if (category == "3") {
      return black;
    } else if (category == "4") {
      return brown;
    }
  }

  getCategoryLabel(category) {
    if (category == "1") {
      return "Uncategorized";
    } else if (category == "2") {
      return "Study";
    } else if (category == "3") {
      return "Work";
    } else if (category == "4") {
      return "Personal";
    }
  }
}