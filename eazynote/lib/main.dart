import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './scoped-models/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
  int _themeColor = 1;
  String _connectionStatus;
  // String _connectionStatus;

  // final dbHelper = DatabaseHelper.instance;

  @override
  initState() {
    // start network check
     _model.networkStatus();
    _model.getNetworkStatus.listen((String connectionStatus) {
      setState(() {
      
        _connectionStatus = connectionStatus;
        print('connection here $_connectionStatus');
      });
    });
    
    // get active theme from sharedPreference
    SharedPreferences.getInstance()
    .then((SharedPreferences prefs) {
      final int persistedThemeColor = prefs.getInt('activeTheme');
      // print('color saved now $persistedThemeColor');
      // auto login
       _model.autoAuthenticate();
      _themeColor = persistedThemeColor != null ? persistedThemeColor : _themeColor;
    });

    // Check authentication status
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });

    // listen to themeCOlor change
    _model.themeColor.listen((dynamic themeColor) {
      setState(() {
        _themeColor = themeColor;
      });
    });
    super.initState();
  }
  // dynamic theme data
  getColor(model) {
    // setState(() {
      if (_themeColor == 1 ) {
        // setState(() {
          return ThemeData(
          unselectedWidgetColor:Colors.orange,
          brightness: Brightness.light,
          primarySwatch: Colors.orange,
          accentColor: Colors.white,
          buttonColor: Colors.orange,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white
            )        
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white
          ),
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
 
          
        );
        // });
      
    } else if (_themeColor == 2) {
      return ThemeData(
          unselectedWidgetColor:Colors.red,
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          accentColor: Colors.white,
          buttonColor: Colors.red,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white
            )        
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white
          ),
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
 
          
        );
        } else if (_themeColor == 4) {
          return ThemeData(
              unselectedWidgetColor:Colors.green,
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              accentColor: Colors.white,
              buttonColor: Colors.green,
              primaryTextTheme: TextTheme(
                title: TextStyle(
                  color: Colors.white
                )        
              ),
              primaryIconTheme: IconThemeData(
                color: Colors.white
              ),
              textTheme: TextTheme(
              headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            ),
    
              
            );
        } else if (_themeColor == 5) {
        return ThemeData(
          unselectedWidgetColor:Colors.brown,
          brightness: Brightness.light,
          primarySwatch: Colors.brown,
          accentColor: Colors.white,
          buttonColor: Colors.brown,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white
            )        
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white
          ),
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
 
          
        );
    
    } else {
      return ThemeData(
          unselectedWidgetColor:Colors.blue,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          accentColor: Colors.white,
          buttonColor: Colors.blue,
          primaryTextTheme: TextTheme(
            title: TextStyle(
              color: Colors.white
            )        
          ),
          primaryIconTheme: IconThemeData(
            color: Colors.white
          ),
          textTheme: TextTheme(
          headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 30.0, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
 
          
        );
    }
    // });
    
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
        theme: getColor(_model),
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