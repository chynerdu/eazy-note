import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/notes-model.dart';

// views
import './edit-Note.dart';

class NotePage extends StatelessWidget {
   final NotesModel note;
   NotePage(this.note);

     // components
  DecorationImage _buildBackgroundImage() {
    return new DecorationImage(
      // fit: BoxFit.cover,
      colorFilter:
      ColorFilter.mode(Colors.red.withOpacity(0.3), BlendMode.darken),
      image: AssetImage('assets/note.jpg'),
      // image: new ExactAssetImage("assets/note.jpg"),
      fit: BoxFit.cover,
 
    );
  }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(note.title.toUpperCase()),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
               model.selectNote(note.id);
               model.deleteNote()
               .then((bool success) {
                  if(success) {
                    // print('delete success');
                    Navigator.pushReplacementNamed(context, '/notes').then((_) => model.selectNote(null));
                  } else {
                    // print('delete failed');
                  }
               });
              // Navigator.pushReplacementNamed(context, '/notes');
              },
            ) 
          ],
        ),
        body: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:50.0),
            Container(
              decoration: new BoxDecoration(
                // image: _buildBackgroundImage(),
                color: Colors.orangeAccent
              ),
              // color: Colors.red,
              padding: EdgeInsets.all(15.0),
              
              
            ),
            Positioned(
              bottom: 0.0,
              top:10.0,
              left: 10.0,
              right: 10.0,
              child: Card(
              elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                               
                ),
                child: Column(
                  children: <Widget>[
                    // Divider(color: Colors.red,),
                    Padding(
                      // padding: const EdgeInsets.all(0.0),
                      padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[          
                            Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.access_time,
                                  color: Colors.white,
                                  size: 13.0,
                                )
                              ),
                              label: Text(
                                note.dateTime,
                                style: TextStyle(fontSize: 10.0)
                                ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                              decoration: BoxDecoration(
                                  color: model.getCategoryStyle(note.category, Colors.blueGrey, Colors.brown, Colors.black45, Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(2.0)
                              ),
                              child:Text(
                              model.getCategoryLabel(note.category),
                              style: TextStyle(color: Colors.white)
                              ), 
                            ),
                        ],),
                      ],)
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        note.title.toUpperCase(),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald',),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(note.subtitle,
                      style: TextStyle(fontSize: 16.0,
                      height: 1.5))
                    ),
                  ],
                ),

              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            model.selectNote(note.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditNotePage();
                },
              ),
            );
          },
          // label: Text('Edit'),
          child: Icon(Icons.edit),
          backgroundColor: Colors.red,
        ),
        )
      );
    });
  }
}