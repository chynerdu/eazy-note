import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flushbar/flushbar.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/rendering.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
    ScrollController scrollController;
    final ScrollController controller = ScrollController();
    bool dialVisible = true;
    var currentPage = 0;
    var selectedTheme = 1;
  @override
  initState() {
    widget.model.fetchNotes();
    widget.model.getNetworkStatus;
    // widget.model.currentDate;
    super.initState();
    // scrollController = ScrollController();
    //   controller.addListener(() {
    //     print(scrollController.position.userScrollDirection);
    //     if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
    //       print('scrolling');
    //     }
    //     setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
    //   });
  }
  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
       // _showAlert();
        
    });
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
   Widget _buildListViewBuilder(Function fetch) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
     return 
     LiquidPullToRefresh(
       onRefresh: fetch,
       child: ListView.builder(
        controller: scrollController,
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
                  .then((dynamic success) {
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
                        ],),                       
                      ]                   
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
   Widget _buildNoteList(Function fetch) {
    return ScopedModelDescendant(builder: (BuildContext context, Widget child, MainModel model) {
      Widget  content = Center(child:CircularProgressIndicator());
      if (model.displayedNotes.length > 0 && !model.isLoading) {
        print('done loading');
        content = _buildListViewBuilder(fetch);
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

  Widget _buildSideDrawer(BuildContext context, model) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // AppBar(
          //   automaticallyImplyLeading: false,
          //   title: Text('EazyNote'),
          // ),
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Theme.of(context).buttonColor
            // ),
            decoration: BoxDecoration(
              color: Colors.red,
              image: new DecorationImage(
                colorFilter:
                  ColorFilter.mode(Theme.of(context).buttonColor.withOpacity(0.2), BlendMode.darken),
                fit: BoxFit.cover,
                image: new ExactAssetImage("assets/note.jpg")
              )
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                Text('EazyNote', 
                style: TextStyle(color:Colors.white, fontSize: 30.0,),
                ),
                Text(model.user.email,
                  style: new TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500, color:Colors.white),
                  ),
              ],)
            
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.add_comment),
            title: Text('Create Note'),
            onTap: () {
              Navigator.of(context).push(
                _newNoteAnimation()
              );
            },
          ),
          Divider(),
          ListTile(
            dense: true,
            leading: Icon(Icons.book),
            title: Text('Project Manager (Coming Soon)'),
            onTap: () {
              
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.nature_people),
            title: Text('Instagram'),
            onTap: () {
              model.logout();
                Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          
          Divider(),
          ListTile(
            dense: true,
            leading: Icon(Icons.palette),
            title: Text('Change App Theme'),
          ),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 51.0, maxHeight: 21.0),
                onPressed: () {
                  widget.model.changeAppTheme(1);
                  // changeTheme(model, selectedTheme);
                },
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.orange,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 51.0, maxHeight: 21.0),
                onPressed: () {
                  widget.model.changeAppTheme(2);
                },
                // child: new Icon(
                //   Icons.pause,
                //   color: Colors.blue,
                //   size: 35.0,
                // ),
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.red,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 51.0, maxHeight: 21.0),
                onPressed: () {
                  widget.model.changeAppTheme(3);
                },
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.blue,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 51.0, maxHeight: 21.0),
                onPressed: () {
                  //  _showAlert();
                      // EdgeAlert.show(context, title: 'Title', description: 'Description', gravity: EdgeAlert.TOP);
                  widget.model.changeAppTheme(4);
                },
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.green,
                padding: const EdgeInsets.all(15.0),
              ),
              new RawMaterialButton(
                constraints: BoxConstraints(maxWidth: 51.0, maxHeight: 21.0),
                onPressed: () {
                  widget.model.changeAppTheme(5);
                },
                shape: new CircleBorder(),
                elevation: 2.0,
                fillColor: Colors.brown,
                padding: const EdgeInsets.all(15.0),
              )
            ],
          ),
          SizedBox(height: 5.0),
        
          Divider(),
          
          ListTile(
            dense: true,
            leading: Icon(Icons.apps),
            title: Text('App Version: 1.0'),
            onTap: () {
              model.logout();
                Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            dense: true,
            leading: Icon(Icons.person_pin),
            title: Text('About Us'),
            onTap: () {
              model.logout();
                Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.red),
            title: Text('Logout', 
            style: TextStyle(color: Colors.red)),
            onTap: () {
              model.logout();
                Navigator.of(context).pushReplacementNamed('/');
            },
          ),

          // LogoutListTile()
        ],
      ),
    );
  }
 
  // Widget _showAlert() {
  //   Alert(
  //     context: context,
  //     title: "Network Changed",
  //     desc: "Oooh, You are not connected to a newtwork",
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "Okay",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //         color: Color.fromRGBO(0, 179, 134, 1.0),
  //       ),],
  //     style: AlertStyle(
  //       // animationDuration: Duration(milliseconds: 400),
  //       animationType: AnimationType.fromTop,
  //       isCloseButton: false,
  //       isOverlayTapDismiss: false,
  //     )
  //   ).show();
  // }
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
      List<Widget> _widgetOptions = <Widget>[
        _buildNoteList(model.fetchNotes),
        _buildNoteList(model.fetchOnlineNotes),
      ];
      return Scaffold(
        drawer: _buildSideDrawer(context, model),
        appBar: AppBar(
          title:  currentPage == 0 ? Text('Local Device') : Text('Online'),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.exit_to_app),
          //     onPressed: () {
                
          //     }
          //   ) 
          // ],
        ),
        body:  _widgetOptions.elementAt(currentPage),
        // body: _buildNoteList(),
          floatingActionButton: Visibility(
          visible: dialVisible,
          child: FloatingActionButton(
            
            onPressed: () {
              // Add your onPressed code here!
              Navigator.of(context).push(
              _newNoteAnimation()
              );
              //  Navigator.pushReplacementNamed(context, '/create');
            },
            // label: Text('New'),
            child: Icon(Icons.add),
            backgroundColor: Theme.of(context).accentColor,
          ),
          
        
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.devices, title: "Local Device"),
            TabData(iconData: Icons.cloud_download, title: "Online")
          ],
          onTabChangedListener: (position) {
            print('position $currentPage');
              setState(() {
                currentPage = position;
                if (position == 0) {
                print('position too $currentPage');
                  model.fetchNotes();
                } else {
                  model.fetchOnlineNotes();
                }
              });

          })
      );
    });
    
  }
}