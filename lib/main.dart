/**
 *
 * An app that showcases a custom list view which has two modes of access
 *
 * QuickAccess: When double tapped the list displays item in compact form
 *              i.e. all items are vertically scrollable means showing
 *              less items on the screen.
 *
 * DetailedAccess: When swiped the list displays item in detailed form
 *                 i.e. all items are horizontally scrollable means showing
 *                 more items on the screen.
 *
 **/

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

var itemHeight = 90.0; // list item height
var itemWidth = 160.0; // list item width

/// The function that runs the app (main function)
void main() => runApp(TwoWayScroll());

/// list item
class ListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      width: itemWidth,
      height: itemHeight,
    ); // Container
  }
}

/// This widget is for the basic appearance of the app
class TwoWayScroll extends StatelessWidget {
  // title of the application
  static final title = 'Two Way Scroll';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: MyHomePage(title: title),
        ),
      ),
    );
  }
}

/**
 *
 *  I didn't find any way to make a list item rotate properly in sliver list
 *  even though the item themselves rotated but the list only scrolled when
 *  the items were horizontal and couldn't adjust elements when they were
 *  vertical.
 *
 *  What is done to make this word is I have used the rotated box (which get's
 *  the job done of scrolling horizontally as well as vertically) and then rotated
 *  the rotated box using Transform.rotate for a smooth rotation along with a
 *  Transform.translate to keep everything in place.
 *
 *  To orchestrate the animation each item some calculations were took in consideration
 *  keeping the item's height and width in mind and some factors were taken in
 *  account which can be observed in the code below to make the code flexible
 *  enough for item of any height and width.
 *
 **/

/// Class containing the animations of a list item
class ListItemAnimation extends AnimatedWidget {
  // the x and y movement of list item
  static final double end = (itemHeight - itemWidth) / 2;

  // rotate the item to 90 degree
  static final _angleTween = Tween<double>(begin: 0, end: Math.pi / 2);

  // displacement of list items
  static final _translateTween = Tween<double>(begin: 0, end: end);

  final displacementFactor; // displacement factor needed to keep items in place

  // Constructor including the factor element
  ListItemAnimation(
      {Key key, Animation<double> animation, this.displacementFactor})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return Transform.translate(
      offset: (_translateTween.evaluate(animation) == end ||
              _translateTween.evaluate(animation) == 0)
          ? Offset(0, 0)
          : Offset(_translateTween.evaluate(animation),
              _translateTween.evaluate(animation) * displacementFactor),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Transform.rotate(
            angle: _angleTween.evaluate(animation) == Math.pi / 2
                ? 0
                : _angleTween.evaluate(animation),
            child: RotatedBox(
              quarterTurns:
                  _angleTween.evaluate(animation) == Math.pi / 2 ? 0 : 3,
              child: ListItem(),
            ),
          ),
        ],
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    // set the controller for 2 seconds duration
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    // set the animation to be of type ease in and out curve
    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              ListItemAnimation(animation: animation, displacementFactor: 1),
              ListItemAnimation(animation: animation, displacementFactor: 3),
              ListItemAnimation(animation: animation, displacementFactor: 5),
              ListItemAnimation(animation: animation, displacementFactor: 7),
              ListItemAnimation(animation: animation, displacementFactor: 9),
              ListItemAnimation(animation: animation, displacementFactor: 11),
              ListItemAnimation(animation: animation, displacementFactor: 13),
              ListItemAnimation(animation: animation, displacementFactor: 15),
            ]),
          ),
        ],
      ),
      onTap: () {
        if (animation.status == AnimationStatus.completed)
          controller.reverse();
        else if (animation.status == AnimationStatus.dismissed)
          controller.forward();
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
