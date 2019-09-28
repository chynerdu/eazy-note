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
import './about.dart';

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
    String _connectionStatus;

  @override
  initState() {
    //  widget.model.networkStatus();
     widget.model.fetchAppMeta();
      
     widget.model.getUpdateAvailability.listen((bool updateAvailable) {
       setState(() {  
        if (updateAvailable) {
            // print('update available');
            WidgetsBinding.instance
          .addPostFrameCallback((_) => _showUpdateAlert(widget.model.appMetaData.appVersion));
             
        }
     });
      // setState(() {  
      //    print('update availabel $updateAvailable');
      // });
     });
    //   widget.model.getNetworkStatus.listen((String connectionStatus) {
    //   setState(() {  
    //     _connectionStatus = connectionStatus;
    //     print('connection here in notes $_connectionStatus');
    //   });
      
    // });
    widget.model.fetchNotes();
    // widget.model.getNetworkStatus;
    // widget.model.currentDate;
    super.initState();
    // widget.model.networkStatus();
    //   widget.model.getNetworkStatus.listen((String connectionStatus) {
    //   setState(() {  
    //     _connectionStatus = connectionStatus;
    //     print('connection here in notes $_connectionStatus');
    //   });
    //   if (_connectionStatus == 'ConnectivityResult.none') {
    //     print('Criteria matched');
    //     WidgetsBinding.instance
    //       .addPostFrameCallback((_) => _showAlert());
    // }
    // });
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

  Route _aboutAnimation(model) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => AboutDev(model),
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
       color: Theme.of(context).buttonColor,
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
      Widget  content = Center(child:CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor));
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
        content = Center(child:CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor));
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
                Text('EazPad', 
                style: TextStyle(color:Colors.white, fontSize: 30.0,),
                ),
                Text(model.user.email,
                  style: new TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500, color:Colors.white),
                  ),
              ],)
            
          ),
          Container(
          child: Stack(
           children: <Widget>[
             Column(
               children: <Widget>[
                  Container(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.note_add, size:18),
                      title: Text('Create Note'),
                      onTap: () {
                        Navigator.of(context).push(
                          _newNoteAnimation()
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Container(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.lock, size:18),
                      title: Text('EazyTask (Coming Soon)'),
                      onTap: () {
                        
                      },
                    ),
                  ),     
                  Divider(),
                  Container(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.palette, size:18),
                      title: Text('Change App Theme'),
                    ),
                  ),
                  Container(
                    child: Row(
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
                  ),
                  SizedBox(height: 5.0),
                
                  Divider(),
                  Container(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.apps, size:18),
                      title: Text('App Version: ${model.deviceAppVersion}'),
                      onTap: () {
                        // model.logout();
                        //   Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                  ),
                  Container(
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.person_pin, size:18),
                      title: Text('Developer'),
                      onTap: () {
                        Navigator.of(context).push(
                          _aboutAnimation(model)
                        );
                      },
                    ),
                  ),
                  Container(
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app, color: Colors.red, size:18),
                      title: Text('Logout', 
                      style: TextStyle(color: Colors.red)),
                      onTap: () {
                        model.logout();
                          Navigator.of(context).pushReplacementNamed('/');
                      },
                    ),
                  ), 
              //     Container(
              //     child: new Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   verticalDirection: VerticalDirection.up,
              //   children: <Widget>[
              //   // alignment: FractionalOffset.bottomCenter,
              //     Container(
              //       // color: Colors.white,
              //       child: ListTile(
              //         dense: true,
              //         leading: Icon(Icons.apps, size:18),
              //         title: Text('EazyNote ${model.appMetaData.appVersion} available'),
              //         onTap: () {
              //           // model.logout();
              //           //   Navigator.of(context).pushReplacementNamed('/');
              //         },
              //       ),
              //     ) 
              //   ]               
              // )
              //     )
                ]  // LogoutListTile()
            ),
            // Positioned(         
              // child: new Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   verticalDirection: VerticalDirection.up,
              //   children: <Widget>[
              //   // alignment: FractionalOffset.bottomCenter,
              //     Container(
              //       // color: Colors.white,
              //       child: ListTile(
              //         dense: true,
              //         leading: Icon(Icons.apps, size:18),
              //         title: Text('App Version: ${model.deviceAppVersion}'),
              //         onTap: () {
              //           // model.logout();
              //           //   Navigator.of(context).pushReplacementNamed('/');
              //         },
              //       ),
              //     ) 
              //   ]               
              // )
            // )
           ]
          )
          )
        ],
      ),
    );
  }
 
  _showUpdateAlert(appVersion) {
    Alert(
      context: context,
      title: "New Update Available!!",
      desc: "Update $appVersion is available to download, downloading the latest update you will get latest features, improvements and bug fixes",
      buttons: [
        DialogButton(
          child: Text(
            "Okay",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.pop(context);
             widget.model.toggleUpdateStatus();
          },
          color: Theme.of(context).buttonColor,
        ),],
      style: AlertStyle(
        descStyle: TextStyle(fontSize: 16, color:Colors.black54),
        titleStyle: TextStyle(fontSize: 19,),
        // animationDuration: Duration(milliseconds: 400),
        animationType: AnimationType.fromTop,
        isCloseButton: false,
        isOverlayTapDismiss: false,
      )
    ).show();
  }
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
          
          title:  currentPage == 0 ? Text('On Local Device') : Text('Online'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.note_add),
              onPressed: () {
                Navigator.of(context).push(
                  _newNoteAnimation()
                );
              }
            ) 
          ],
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
            child: Icon(Icons.note_add),
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