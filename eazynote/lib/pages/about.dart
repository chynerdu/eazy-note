import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flushbar/flushbar.dart';
// import '../scoped-models/main.dart';



class AboutDev extends StatefulWidget {
  final MainModel model;
  AboutDev(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AboutDevState();
  }
}

class _AboutDevState extends State<AboutDev> {
  final Map<String, dynamic> _formData = {
      'message': null,

     };
        final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // initState() {
  //   widget.model.deleteDatabase();
  //   // widget.model.currentDate;
  //   super.initState();
  // }
  // components
  DecorationImage _buildBackgroundImage() {
    return new DecorationImage(
      // fit: BoxFit.cover,
      colorFilter:
      ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
      image: AssetImage('assets/note.jpg'),
      // image: new ExactAssetImage("assets/note.jpg"),
      fit: BoxFit.cover,
 
    );
  }

   void callFlushbar(title, message) {
     Flushbar(
      title:  title,
      message:  message,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      boxShadows: [BoxShadow(color: Colors.green[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      icon: Icon(
        Icons.check,
        color: Colors.greenAccent,
      ),

      duration:  Duration(seconds: 6),              
    )..show(context);
   }

    void _sendMessage(context, Function sendMessage) {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        // print(_formData['subtitle']);
        sendMessage(
          _formData['message'],
        ).then((bool success) {
          if(success) {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content: Text('Message received'),
              //   duration: Duration(seconds: 3),
              // ));
            Navigator.pop(context);
            String title = 'Message Sent';
            String message = 'Thanks for your feedback';
            callFlushbar(title, message);
             
          } else {
            print('save failed');
          }
        });
    }

    _showMessageBox() {
    Alert(
      context: context,
      title: "Drop a Message",
      content: Form(
        key: _formKey,
         child: Column(
          children: <Widget>[
            Divider(),
            // Text('Feel free to send a message', 
            // style: TextStyle(fontSize: 16,)),
            // SizedBox(height: 10.0),
            TextFormField(
               maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                // icon: Icon(Icons.account_circle),
                labelText: 'Message',
              ),
              validator: (String value) {
                if (value.isEmpty || value.length < 10) {
                  return 'Note content is required and should be 10+ characters long.';
                }
              },
              onSaved: (String value) {
                _formData['message'] = value;
              }
            ),
          ]
      ),
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Close",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () => Navigator.pop(context),
          color: Colors.black
        ),
        DialogButton(
          child: Text(
            "Send Message",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: () => _sendMessage(context, widget.model.SendMessage),
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
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final String assetName = 'assets/chi3.jpg';
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Stack(    
        children:<Widget>[
          Container( 
            // padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0, bottom: 10.0),
            decoration: new BoxDecoration(
              color: Theme.of(context).buttonColor,
              
            ),
          ),
          Positioned(
            bottom: 0.0,
            top:10.0,
            left: 20.0,
            right: 20.0,
            child: SingleChildScrollView(
              child: Container(
                // alignment: Alignment.centerLeft,
                width: targetWidth,
                  child: Column(
                    children: <Widget>[                   
                      SizedBox(height: 20.0,),                   
                      Container(
                        width: 150.0,
                        height: 150.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: new AssetImage(
                                  assetName)
                          )
                        )),
                        SizedBox(height: 30.0),
                        new Text("Chinedu Uche",
                          textScaleFactor: 1.5, 
                          style: TextStyle(color:Colors.white)
                        ),
                        SizedBox(height: 30.0,),
                      Container(
                        // alignment: Alignment.centerLeft,
                        child: Text(
                          "Web | Mobile App Developer, Gamer and Foodie.",
                          textAlign: TextAlign.center,
                          // overflow: TextOverflow.ellipsis,
                          style: new TextStyle(fontSize: 20.0, color:Colors.white),
                        ),
                      ),
                      SizedBox(height: 10.0,),
                      Divider(color: Colors.white),
                      SizedBox(height: 10.0,),
                      Container(
                        child: Text("Sometimes I like to go out and see new places, try out new dishes.",
                            style: TextStyle(fontSize: 17.0, color:Colors.white, fontStyle: FontStyle.italic)
                          ),
                      ),
                      SizedBox(height: 10.0,),
                      Divider(color: Colors.white),
                      SizedBox(height: 30.0,),
                      new IconButton(icon: new Icon(Icons.email, color: Colors.white,), 
                      onPressed: () {
                        _showMessageBox();
                      }),

              
                    ]
                  )
                
              )
            )
            //  )
          )
        ]
      )
    );
  });
  }
}