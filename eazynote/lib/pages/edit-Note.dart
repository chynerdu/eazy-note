
import 'package:eazynote/models/notes-model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'dart:convert';
// import '../models/notes-model.dart';
import '../scoped-models/main.dart';
import '../widgets/helpers/ensure_visible.dart';
// import '../models/notes-model.dart';


class EditNotePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EditNotePageState();
  }
}

class _EditNotePageState extends State<EditNotePage> {
       // define formdata
    int _radioValue1 = 2;
    final Map<String, dynamic> _formData = {
      'title': null,
      'subtitle': null,
      'category': "2"

     };
     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
     final _titleFocusNode = FocusNode();
     final _subtitleFocusNode = FocusNode();

    Widget _buildTitleTextField(NotesModel note) {
      return Container(
        // focusNode: _titleFocusNode,
        child: TextFormField(
          focusNode: _titleFocusNode,
          decoration: InputDecoration(labelText: 'Title'),
          initialValue: note.title,
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

    Widget _buildSubtitleTextField(NotesModel note) {
      return Container(
        // focusNode: _subtitleFocusNode,
        child: TextFormField(
          keyboardType: TextInputType.multiline,
          focusNode: _subtitleFocusNode,
          maxLines: null,
          decoration: InputDecoration(labelText: 'Content'),
          initialValue: note.subtitle,
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
    // Widget _buildDropDown(NotesModel note) {
    //   //  _formData['category'] = note.category;
    //   // String dropdownValue = 'Uncategorized';
    //   return EnsureVisibleWhenFocused(
    //     focusNode: _titleFocusNode,
    //     child: DropdownButton<String>(
    //       isExpanded: true,
    //       icon: Icon(Icons.keyboard_arrow_down), 
    //       onChanged: (String value) {
    //         setState(() {
    //          _formData['category']  = value;
    //          print(_formData['category']);
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
    //       // items: <String>['Uncategorized', 'Work', 'Study', 'Personal']
    //       //   .map<DropdownMenuItem<String>>((String value) {
    //       //     return DropdownMenuItem<String>(
    //       //       value: value,
    //       //       child: Text(value),
    //       //     );
    //       //   })
    //       //   .toList(),
    //     ),
    //   );
    // }

    // Widget _buildSubmitButton() {
    //   return ScopedModelDescendant<MainModel>(
    //     builder: (BuildContext context, Widget child, MainModel model) {
    //       return
    //       FloatingActionButton(
    //         onPressed: () {
    //         _submitFunction(model.updateNote, model.selectNote);
    //         },
    //         child: Text('Done'),
    //         // child: Icon(Icons.save),
    //         backgroundColor: Theme.of(context).primaryColor,
    //       );
    //     },
    //   );
    // }

    void _submitFunction(Function updateNote, Function selectNote) {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        print(_formData['subtitle']);
        updateNote(
          _formData['title'],
          _formData['subtitle'],
          _formData['category']
        ).then((bool success) {
          if(success) {
            print('update success');
            Navigator.pushReplacementNamed(context, '/notes').then((_) => selectNote(null));
          } else {
            print('update failed');
          }
        });
    }

    Widget _buildFormContent(BuildContext context, NotesModel note) {
      final double deviceWidth = MediaQuery.of(context).size.width;
      final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
      final double targetPadding = deviceWidth - targetWidth;
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // SizedBox(height:10.0),
                    Container(
                      child: _buildRadioButton()
                    ),
                    Divider(),
                    Container(
                    child: _buildTitleTextField(note),
                    ),
                    SizedBox(height:10.0),
                    Container(
                      child: Expanded(
                      child: _buildSubtitleTextField(note),
                      ),
                    ), 
                  ]  
                ),           
                // _buildDropDown(),
                // SizedBox(height:10.0),
                
                // Positioned(
                  
                //   child: new Align(
                //     alignment: FractionalOffset.bottomCenter,
                //       child: Container(
                //        color: Colors.white,
                //        child: _buildRadioButton(),
                //       )                
                //   )
                // )
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
            title: Text('Edit'),
            actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                    _submitFunction(model.updateNote, model.selectNote);
                    },
                  ) 
            ],
          ),
          body: ModalProgressHUD(
           child: _buildFormContent(context, model.selectedNote),
            inAsyncCall:model.isLoading,
            opacity: 0.6,
            color:Colors.black87,
            progressIndicator: SpinKitHourGlass(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            )
          ),
          // floatingActionButton: _buildSubmitButton(),
        );
      });
  }

}