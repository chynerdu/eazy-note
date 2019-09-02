import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
// import 'dart:convert';
// import '../models/notes-model.dart';
import '../scoped-models/main.dart';
import './create-note.dart';


class Notes extends StatefulWidget {
  final MainModel model;

  Notes(this.model);
  @override
  State<StatefulWidget> createState() {
    return _NotesState();
  }
}

class _NotesState extends State<Notes> {
  @override
  initState() {
    widget.model.fetchNotes();
    // widget.model.currentDate;
    super.initState();
  }

  // animation
   Route _newNoteAnimation() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => NewNotePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      }
    );
  }
   Widget _buildListViewBuilder() {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
     return 
     LiquidPullToRefresh(
       onRefresh: model.fetchNotes,
       child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: model.allNotes.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(model.allNotes[index].title),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white)
              ),
            // child: Icon(Icons.delete),
            onDismissed: (direction) {
                  model.selectNote(model.allNotes[index].id);
                  model.deleteNote()
                  .then((bool success) {
                    if(success) {
                      Flushbar(
                        title:  "Success!",
                        message:  "${model.allNotes[index].title} deleted",
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        reverseAnimationCurve: Curves.decelerate,
                        forwardAnimationCurve: Curves.elasticOut,
                        boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
                        backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
                        icon: Icon(
                          Icons.warning,
                          color: Colors.redAccent,
                        ),
            
                        duration:  Duration(seconds: 3),              
                      )..show(context);
                      // Scaffold
                      //   .of(context)
                      //   .showSnackBar(SnackBar(content: Text());
                    } else  {
                      Flushbar(
                        title:  "Failed",
                        message:  "Unable to delete ${model.allNotes[index].title}",
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        reverseAnimationCurve: Curves.decelerate,
                        forwardAnimationCurve: Curves.elasticOut,
                        boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
                        backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
                        icon: Icon(
                          Icons.warning,
                          color: Colors.redAccent,
                        ),
            
                        duration:  Duration(seconds: 3),              
                      )..show(context);
                    }
                  });
              },
            child: Column(
              children: <Widget>[
                ListTile(
                  dense: true,
                  // trailing: Icon(Icons.keyboard_arrow_right),
                  leading: CircleAvatar(
                    backgroundColor: model.getColors(model.allNotes[index].title.substring(0, 1).toUpperCase(), Colors.blue, Colors.green, Colors.red, Colors.orange),
                    child: Text(
                      model.allNotes[index].title.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        // fontWeight: FontWeight.bold,
                        fontSize: 22.0)
                      )
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:<Widget>[
                    Flexible(
                    child: Text(
                      model.allNotes[index].title.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.0
                      )
                    ),),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                      decoration: BoxDecoration(
                          color: model.getCategoryStyle(model.allNotes[index].category, Colors.blueGrey, Colors.brown, Colors.black45, Colors.blueAccent),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child:Text(
                      model.getCategoryLabel(model.allNotes[index].category),
                      style: TextStyle(color: Colors.white)
                      ), 
                  ),
                  ]),
                  subtitle:
                  Column(
                    // child: Column(
                      children: <Widget> [   
                        SizedBox(height: 3.0, ),  
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                          Flexible(
                              child:Text(
                                model.allNotes[index].subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                // softWrap: true,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold
                                )
                            ),
                          )
                        ],) , 
                        SizedBox(height: 10.0, ),             
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              model.allNotes[index].dateTime,
                            ),
                          //    style: TextStyle(fontSize: 10.0)
                          //     ),
                          
                          // Chip(
                          //   avatar: CircleAvatar(
                          //     backgroundColor: Colors.red,
                          //     child: Icon(
                          //       Icons.access_time,
                          //       color: Colors.white,
                          //       size: 13.0,
                          //     )
                          //   ),
                          //   label: Text(
                          //     model.allNotes[index].dateTime,
                          //     style: TextStyle(fontSize: 10.0)
                          //     ),
                          // ),
                        ],),
                        
                      ]
                    // )
                    
                  ),

                  onTap: () => Navigator.pushNamed<bool>(
                    context, '/notes/' + model.allNotes[index].id
                    
                  )
                ),
                Divider()
              ]
            )
          );
        }
      ),);
    });
   }
   Widget _buildNoteList() {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
      Widget  content = Center(child:CircularProgressIndicator());
      if (model.displayedNotes.length > 0 && !model.isLoading) {
        print('done loading');
        content = _buildListViewBuilder();
      } else if (model.displayedNotes.length <= 0 && !model.isLoading) {
        content = Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image(
                  image: AssetImage('assets/no-note.png'),
                  height: 120.0,
                  width: 120
                  // fit: BoxFit.cover,
                  // placeholder: AssetImage('assets/eazynote.svg')
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0, bottom: 10.0),
                child: Text("Oops! You don't have any notes, click the button to create a note")
              ),
            ]
          )
        );

      } else if (model.isLoading) {
        content = Center(child:CircularProgressIndicator());
      }
      // return RefreshIndicator(onRefresh: model.fetchNotes, child: content);
      return content;
    });
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('My Notes'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                model.logout();
                Navigator.of(context).pushReplacementNamed('/');
              }
            ) 
          ],
        ),
        body: _buildNoteList(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Add your onPressed code here!
              Navigator.of(context).push(
              _newNoteAnimation()
              );
              //  Navigator.pushReplacementNamed(context, '/create');
            },
            // label: Text('New'),
            child: Icon(Icons.add),
            backgroundColor: Colors.red,
          ),
        
      );
    });
    
  }
}