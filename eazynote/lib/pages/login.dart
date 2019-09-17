import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import '../scoped-models/main.dart';
import './signup.dart';



class AuthPage extends StatefulWidget {
  final MainModel model;
  AuthPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AuthPageState();
  }
}

class _AuthPageState extends State<AuthPage> {
  // initState() {
  //   widget.model.fetchAppMeta();
  //   // widget.model.currentDate;
  //   super.initState();
  // }
  final Map<String, dynamic> _formData = {
  'email': null,
  'password': null
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final TextEditingController _passwordTextController = TextEditingController();

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

    // animation
   Route _signupAnimation() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Signup(),
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

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
         _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      // controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
         _formData['password'] = value;
      }
    );
  }
  void _submitFunction(Function login) {
    if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
    
      // print(_formData['subtitle']);
      login(
        _formData['email'],
        _formData['password'],
      ).then((Map<String, dynamic> success) {
        if(success['success']) {
            Navigator.pushReplacementNamed(context, '/notes');
        } else {
          Flushbar(
            title:  "An Error Occured!",
            message:  success['message'],
            flushbarPosition: FlushbarPosition.TOP,
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
          // showDialog(
          //   context: context,
          //   builder: (BuildContext context) {
          //   return AlertDialog(
          //     title: Text('An Error Occured!'),
          //     content: Text(success['message']),
          //     actions: <Widget>[
          //       FlatButton(
          //         child: Text('Okay'),
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },)
          //     ],
          //   );
          // });
          //  Navigator.pushReplacementNamed(context, '/notes');
        }
      });
    }

  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final String assetName = 'assets/eazynote.svg';
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
      // appBar: AppBar(
      //   title: Text('EazyNote'),
      // ),
      body: ModalProgressHUD(
        child: Container(
           
           padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0, bottom: 10.0),
           decoration: new BoxDecoration(
          color: Colors.white
          // image: _buildBackgroundImage(),
          
        ),
          child: SingleChildScrollView(
            child: Container(
              // alignment: Alignment.centerLeft,
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'EazyNote',
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0, color: Colors.orange)
                      ),
                    ),
                    
                    SizedBox(height: 100.0,),
                    // SvgPicture.asset(
                    //   assetName,
                    //   semanticsLabel: 'Acme Logo'
                    // ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Image(
                        image: AssetImage('assets/eazynote.png'),
                        height: 120.0,
                        width: 120
                        // fit: BoxFit.cover,
                        // placeholder: AssetImage('assets/eazynote.svg')
                      ),
                    ),
                    
                    SizedBox(height: 40.0,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Let's Log You Into Your Account",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0, color:Colors.black87),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                        _buildEmailTextField(),
                        SizedBox(height: 20.0,),
                        _buildPasswordTextField(),
                        SizedBox(height: 10.0,),
                        FlatButton(
                          child: Text('Create Account', 
                          style: TextStyle(color: Colors.red)),
                          onPressed: () {
                            Navigator.of(context).push(
                            _signupAnimation()
                            );
                          }
                          ),
                        SizedBox(height: 10.0,),
                        MaterialButton( 
                          height: 40.0, 
                          minWidth: 400.0, 
                          color: Theme.of(context).primaryColor, 
                          textColor: Colors.white, 
                          child: new Text("Login"), 
                          onPressed: () {
                            _submitFunction(model.login);
                          }, 
                          splashColor: Colors.redAccent,
                        )
                      ],)
                    ),
                    SizedBox(height: 30.0,),
            
                  ]
                )
              )
            )
          )
        ),
        inAsyncCall:model.isLoading,
        opacity: 0.6,
        color:Colors.black87,
        progressIndicator: SpinKitHourGlass(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        )
        // progressIndicator: CircularProgressIndicator(backgroundColor: Theme.of(context).primaryColor),
      )
    );
  });
  }
}