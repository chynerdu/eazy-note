import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
// import '../scoped-models/main.dart';



class AboutDev extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _AboutDevState();
  }
}

class _AboutDevState extends State<AboutDev> {
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
                      new IconButton(icon: new Icon(Icons.email, color: Colors.white,), onPressed: () {

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