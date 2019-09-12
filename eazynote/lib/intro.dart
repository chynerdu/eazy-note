import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

import './scoped-models/main.dart';
import './pages/login.dart';



class IntroScreen extends StatefulWidget {
  final MainModel model;
  IntroScreen(this.model);

  @override
  State<StatefulWidget> createState() {
    return _IntroScreenState();
  }
}


class _IntroScreenState extends State<IntroScreen> {
  final MainModel _model = MainModel();
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();

    slides.add(
      new Slide(
        title: "EAZYNOTE",
        description: "Take important notes and jottings on the go, never loose track of important information",
        pathImage: "assets/intro1.png",
        colorBegin: Color(0xffFFDAB9),
        colorEnd: Color(0xFFFF9800),
        // backgroundImage: 'images/photo_eraser.png',
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        // backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      new Slide(
        title: "PERSONAL MANAGER",
        description: "Plan your schedules and keep track of your daily activities",
        pathImage: "assets/intro2.png",
        // backgroundColor: Color(0xff203152),
        colorBegin: Color(0xffFFFACD),
        colorEnd: Color(0xffFF6347),
        directionColorBegin: Alignment.topRight,
        directionColorEnd: Alignment.bottomLeft,
      ),
    );
    slides.add(
      new Slide(
        title: "Offline Access",
        description:
        "Access your data without internet even though they are backed up online",
        pathImage: "assets/intro3.png",
        colorBegin: Color(0xffFFA500),
        colorEnd: Color(0xff7FFFD4),
        directionColorBegin: Alignment.topCenter,
        directionColorEnd: Alignment.bottomCenter,
        // backgroundColor: Color(0xff9932CC),
      ),
    );
  }

  void onDonePress() {
    // print('prresded me');
     Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage(_model)),
    );
    // Do what you want
  }

  void onSkipPress() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage(_model)),
    );

  }



  @override
  Widget build(BuildContext context) {
      return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress
    );
  }
}