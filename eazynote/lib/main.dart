import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';
// import './database/database-helper.dart';

import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

import 'package:intro_slider/intro_slider.dart';


// models
import './models/notes-model.dart';

// dart views
import './pages/login.dart';
import './pages/notes.dart';
import './pages/note.dart';
import './pages/create-note.dart';
import './intro.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}



class _MyAppState extends State <MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;
  // final dbHelper = DatabaseHelper.instance;

  // final pages = [
  //   PageViewModel(
  //       pageColor: const Color(0xFF03A9F4),
  //       // iconImageAssetPath: 'assets/air-hostess.png',
  //       // bubble: Image.asset('assets/note.png'),
  //       body: Text(
  //         'Haselfree  booking  of  flight  tickets  with  full  refund  on  cancelation',
  //       ),
  //       title: Text(
  //         'Flights',
  //       ),
  //       textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
  //       mainImage: Image.asset(
  //         'assets/note.png',
  //         height: 285.0,
  //         width: 285.0,
  //         alignment: Alignment.center,
  //       )
  //       ),
  //   PageViewModel(
  //     pageColor: const Color(0xFF8BC34A),
  //     iconImageAssetPath: 'assets/note.png',
  //     body: Text(
  //       'We  work  for  the  comfort ,  enjoy  your  stay  at  our  beautiful  hotels',
  //     ),
  //     title: Text('Hotels'),
  //     mainImage: Image.asset(
  //       'assets/note.png',
  //       height: 285.0,
  //       width: 285.0,
  //       alignment: Alignment.center,
  //     ),
  //     textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
  //   ),
  //   PageViewModel(
  //     pageColor: const Color(0xFF607D8B),
  //     iconImageAssetPath: 'assets/note.png',
  //     body: Text(
  //       'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
  //     ),
  //     title: Text('Cabs'),
  //     mainImage: Image.asset(
  //       'assets/note.png',
  //       height: 285.0,
  //       width: 285.0,
  //       alignment: Alignment.center,
  //     ),
  //     textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
  //   ),
  // ];

  // end slider
  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }
   @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(
    //   SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent, //top bar color
    //     statusBarIconBrightness: Brightness.dark, //top bar icons
    //     // systemNavigationBarColor: Colors.red, //bottom bar color
    //     systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    //   )
    // );
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
          accentColor: Colors.orangeAccent,
          buttonColor: Colors.orange
        ),
        routes: {
          '/': (BuildContext context) => !_isAuthenticated ? IntroScreen(_model) : Notes(_model),
          // '/': (BuildContext context) => IntroViewsFlutter(
          //     pages,
          //     onTapDoneButton: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => !_isAuthenticated ? AuthPage(_model) : Notes(_model),
          //         ), //MaterialPageRoute
          //       );
          //     },
          //     pageButtonTextStyles: TextStyle(
          //       color: Colors.white,
          //       fontSize: 18.0,
          //     ),
          //   ),
          '/notes': (BuildContext context) => Notes(_model),
          '/create': (BuildContext context) => NewNotePage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          print(pathElements);
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'notes') {
            final String noteId = pathElements[2];
            // check if noteId exist
            final NotesModel singleNote = _model.allNotes.firstWhere((NotesModel singleNote) {
              return singleNote.id == noteId;
            });
            // return route
            return MaterialPageRoute<bool> (
              builder:(BuildContext context) => NotePage(singleNote)
            );
          }
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => AuthPage(_model));
        },
      )
    );
  }
}