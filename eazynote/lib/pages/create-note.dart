import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:zefyr/zefyr.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// import 'dart:convert';
// import '../models/notes-model.dart';
import '../scoped-models/main.dart';
import '../widgets/helpers/ensure_visible.dart';
// import '../models/notes-model.dart';


class NewNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewNotePageState();
  }
}

class _NewNotePageState extends State<NewNotePage> {
       // define formdata
    int _radioValue1 = 1;
    final Map<String, dynamic> _formData = {
      'title': null,
      'subtitle': null,
      'category': '1'

     };
     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
     final _titleFocusNode = FocusNode();
     final _subtitleFocusNode = FocusNode();
     ZefyrController _controller;
     FocusNode _focusNode;
     bool _lights = false;



    @override
    void initState() {
      super.initState();
      final document = new NotusDocument();
      _controller = new ZefyrController(document);
      _focusNode = new FocusNode();
    }

    Widget _buildTitleTextField() {
      return Container(
        // focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(
            labelText: 'Title',
            border: InputBorder.none,
            hintText: 'Title here..',
            ),
          initialValue: '',
          validator: (String value) {
            if (value.isEmpty || value.length < 5) {
              return 'Title is required and should be 5+ characters long.';
            }
          },
          onSaved: (String value) {
            _formData['title'] = value;
          }
        )
      );
    }

  // Widget _buildSubtitleTextField1 () {
  //   return ZefyrScaffold(
  //     child: ZefyrEditor(
  //       controller: _controller,
  //       focusNode: _focusNode,
  //     ),
  //   );
  // }

    Widget _buildSubtitleTextField() {
      return Container(
        // focusNode: _subtitleFocusNode,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          focusNode: _subtitleFocusNode,
          maxLines: null,
          decoration: InputDecoration(
            labelText: 'Content',
            border: InputBorder.none,
            hintText: 'Content here..',
            ),
          initialValue: '',
          validator: (String value) {
            if (value.isEmpty || value.length < 10) {
              return 'Note content is required and should be 10+ characters long.';
            }
          },
          onSaved: (String value) {
            _formData['subtitle'] = value;
          }
        )
      );
    }
    void _handleRadioValueChange1(int value) {
      print('picked $value');
      setState(() {
        _radioValue1 = value;
        _formData['category'] = value.toString();
      });
    }
    Widget _buildRadioButton() {
      return new Row(children: <Widget>[
        new Radio(
          value: 1,
          activeColor: Theme.of(context).buttonColor,
          // activeColor: Colors.blue,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Uncategorized',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 2,
          activeColor: Theme.of(context).buttonColor,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Study',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        new Radio(
          value: 3,
          activeColor: Theme.of(context).buttonColor,
          groupValue: _radioValue1,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Work',
          style: new TextStyle(fontSize: 16.0),
        ),
      ],);
    }
    // Widget _buildDropDown() {
    //   // String dropdownValue = 'Uncategorized';
    //   return EnsureVisibleWhenFocused(
    //     focusNode: _titleFocusNode,
    //     child: DropdownButton<String>(
    //       isExpanded: true,
    //       icon: Icon(Icons.keyboard_arrow_down), 
    //       onChanged: (String value) {
    //         setState(() {
    //          _formData['category']  = value;
    //         //  print(_formData['category']);
    //         });
    //       },
    //        value: _formData['category'],
    //       items: [
    //       DropdownMenuItem(
    //         value: "1",
    //         child: Row(
    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Icon(Icons.layers),
    //             SizedBox(width: 10),
    //             Text(
    //               "Uncategorized",
    //             ),
    //           ],
    //         ),
    //       ),
    //       DropdownMenuItem(
    //         value: "2",
    //         child: Row(
    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Icon(Icons.book),
    //             SizedBox(width: 10),
    //             Text(
    //               "Study",
    //             ),
    //           ],
    //         ),
    //       ),
    //       DropdownMenuItem(
    //         value: "3",
    //         child: Row(
    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Icon(Icons.home),
    //             SizedBox(width: 10),
    //             Text(
    //               "Work",
    //             ),
    //           ],
    //         ),
    //       ),
    //       DropdownMenuItem(
    //         value: "4",
    //         child: Row(
    //           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //           children: <Widget>[
    //             Icon(Icons.person),
    //             SizedBox(width: 10),
    //             Text(
    //               "Personal",
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //     ),
    //   );
    // }

    Widget _buildStorageLocationSwitch() {
      return SwitchListTile(
      title: const Text("Don't Save On Device"),
      value: _lights,
      onChanged: (bool value) { 
        print('toggled $value');
        setState(() {
         _lights = value;
        }); 
      },
      secondary: const Icon(Icons.devices),
    );
    }


    Widget _buildSubmitButton() {
      return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return
          model.isLoading
          ? Center(child: CircularProgressIndicator())
          : FloatingActionButton(
            onPressed: () {
            _submitFunction(model.addNote);
            },
            // label: Text('Save'),
            child: Icon(Icons.save),
            backgroundColor: Theme.of(context).primaryColor,
          );
        },
      );
    }

    void _submitFunction(Function addNote) {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        print(_formData['subtitle']);
        addNote(
          _formData['title'],
          _formData['subtitle'],
          _formData['category'],
          _lights
        ).then((bool success) {
          if(success) {
              // Scaffold.of(context).showSnackBar(SnackBar(
              //   content: Text('Show Snackbar'),
              //   duration: Duration(seconds: 3),
              // ));
             Navigator.pushReplacementNamed(context, '/notes');
          } else {
            print('save failed');
          }
        });
    }

    Widget _buildFormContent(BuildContext context) {
      final double deviceWidth = MediaQuery.of(context).size.width;
      final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
      final double targetPadding = deviceWidth - targetWidth;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // Container(
                    // child: _buildStorageLocationSwitch(),
                    // ),
                    Container(
                      child: _buildRadioButton()
                    ),
                    Divider(),
                    // SizedBox(height:10.0),
                    Container(
                    child: _buildTitleTextField(),
                    ),
                    SizedBox(height:10.0),
                    Divider(),
                    Container(
                      child: Expanded(
                      child: _buildSubtitleTextField(),
                      ),
                    ), 
                  ]  
                ),           
                // _buildDropDown(),
                SizedBox(height:10.0),
                
                // Positioned(
                //   child: new Align(
                //     alignment: FractionalOffset.bottomCenter,
                //       child:  _buildRadioButton(),                
                //   )
                // )
                //  alignment: FractionalOffset.bottomCenter,
                // _buildSubmitButton()
              ],
            )
          )
        )
      );
    }

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
            appBar: AppBar(
                title: Text('New Note'),
                actions: <Widget>[
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                      _submitFunction(model.addNote);
                      },
                    ) 
                ],
            ),
            body:ModalProgressHUD(
              child: _buildFormContent(context),
              inAsyncCall:model.isLoading,
              opacity: 0.6,
              color:Colors.black87,
              progressIndicator: SpinKitHourGlass(
                color: Theme.of(context).primaryColor,
                size: 50.0,
              )
            )
            // floatingActionButton: _buildSubmitButton(),
          );
        });
  }

}