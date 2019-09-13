import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:unicorndial/unicorndial.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:sticky_headers/sticky_headers.dart';


import '../scoped-models/main.dart';
import '../models/notes-model.dart';

// views
import './edit-Note.dart';

class NotePage extends StatefulWidget {
  final NotesModel note;
   NotePage(this.note);
  @override
  State<StatefulWidget> createState() {
    return _NotePage();
  }
}

class _NotePage extends State<NotePage> {
 ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });
  }
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }



//  NotesModel note;

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

  SpeedDial buildSpeedDial(model) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      // child: Icon(Icons.add),
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      visible: dialVisible,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
          child: Icon(Icons.delete, color: Colors.white),
          backgroundColor: Colors.redAccent,
          onTap: () {
             model.selectNote(widget.note.id);
              model.deleteNote()
              .then((bool success) {
                if(success) {
                  // print('delete success');
                  Navigator.pushReplacementNamed(context, '/notes').then((_) => model.selectNote(null));
                } else {
                  // print('delete failed');
                }
              });
          },
          label: 'Delete',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.redAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.edit, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          onTap: () {
            model.selectNote(widget.note.id);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return EditNotePage();
                },
              ),
            );
          },
          label: 'Edit Note',
          labelStyle: TextStyle(fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blueAccent,
        ),
      ],
    );
  }





  Widget build(BuildContext context, ) {

//     // unicorn dialer
// var childButtons = List<UnicornButton>();
//   childButtons.add(UnicornButton(
//         hasLabel: true,
//         labelText: "Choo choo",
//         currentButton: FloatingActionButton(
//           heroTag: "train",
//           backgroundColor: Colors.redAccent,
//           mini: true,
//           child: Icon(Icons.train),
//           onPressed: () {},
//         )));

//     childButtons.add(UnicornButton(
//         currentButton: FloatingActionButton(
//             heroTag: "airplane",
//             backgroundColor: Colors.greenAccent,
//             mini: true,
//             child: Icon(Icons.airplanemode_active),
//             onPressed: () {},
//             )));

//     childButtons.add(UnicornButton(
//         currentButton: FloatingActionButton(
//             heroTag: "directions",
//             backgroundColor: Colors.blueAccent,
//             mini: true,
//             child: Icon(Icons.directions_car),
            
//             )));

    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reading'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: () {
          //      model.selectNote(widget.note.id);
          //      model.deleteNote()
          //      .then((bool success) {
          //         if(success) {
          //           // print('delete success');
          //           Navigator.pushReplacementNamed(context, '/notes').then((_) => model.selectNote(null));
          //         } else {
          //           // print('delete failed');
          //         }
          //      });
          //     // Navigator.pushReplacementNamed(context, '/notes');
          //     },
          //   ) 
          // ],
        ),
        body: Stack(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:50.0),
            Container(
              decoration: new BoxDecoration(
                // image: _buildBackgroundImage(),
                color: Theme.of(context).buttonColor
              ),
              // color: Colors.red,
              padding: EdgeInsets.all(15.0),
              
              
            ),
            
            Positioned(
              bottom: 0.0,
              top:10.0,
              left: 5.0,
              right: 5.0,
              child: SingleChildScrollView(
                 controller: scrollController,
                 
                
                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                               
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                       StickyHeader(
                        header: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Padding(                          
                                // color: Colors.white,
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  widget.note.title.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 18.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald',),
                                )
                              ),
                              Divider(),
                              Padding(
                                // padding: const EdgeInsets.all(0.0),
                                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                child: Column(children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[         
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
                                        decoration: BoxDecoration(
                                            color: model.getCategoryStyle(widget.note.category, Colors.blueGrey, Colors.brown, Colors.black45, Colors.blueAccent),
                                            borderRadius: BorderRadius.circular(2.0)
                                        ),
                                        child:Text(
                                        model.getCategoryLabel(widget.note.category),
                                        style: TextStyle(color: Colors.white)
                                        ), 
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.5),
                                        child: Text(
                                          widget.note.dateTime,
                                          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)
                                        ),
                                      ), 
                                  ],),
                                  Divider(),
                                ],)
                              ),
                          ],)
                          
                        ),
                      content: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(widget.note.subtitle,
                        style: TextStyle(fontSize: 16.0,
                        height: 1.5))
                    
                      ),
                      ),
                    
                  ],
                ),

                ),


              )
              
            )
          ],
        ),
        floatingActionButton: buildSpeedDial(model),
        )
      );
    });
  }
}