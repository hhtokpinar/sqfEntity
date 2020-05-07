import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helper.dart';

/*

Thanks to WINSON friend for this popup tool
Source: https://www.coderblog.in/2019/04/how-to-create-popup-window-in-flutter/

*/

class PopupLayout extends ModalRoute {
  PopupLayout(
      {this.bgColor,
      @required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

 double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

 
  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    top = top ?? 10;
    bottom = bottom ?? 20;
    left = left ?? 20;
    right = right ?? 20;

    return GestureDetector(
      onTap: () {
        // call this method here to hide soft keyboard
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        // This makes sure that text and other content follows the material style
        type: MaterialType.transparency,
        //type: MaterialType.canvas,
        // make sure that the overlay content is not cut off
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: bottom,
          left: left,
          right: right,
          top: top),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}

class PopupContent extends StatefulWidget {
  PopupContent({
    Key key,
    this.content,
  }) : super(key: key);
  final Widget content;
  @override
  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}

    void showPopup(BuildContext context, Widget widget, String title,
      {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 20,
        child: PopupContent(
          content: Scaffold(
            appBar: AppBar(
              title: Text(title,style: TextStyle(fontSize: UITools(context).scaleWidth(10)),),
              leading: Builder(builder: (context) {
                return IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                      Navigator.pop(context); //close the popup
                  },
                );
              }),
              brightness: Brightness.light,
            ),
            //resizeToAvoidBottomPadding: true,
            body: widget,
          ),
        ),
      ),
    );
  }
