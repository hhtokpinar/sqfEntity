import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/constants/config.dart';
import 'package:points_of_sale/constants/styles.dart';
import 'package:points_of_sale/localization/trans.dart';
import 'package:intl/intl.dart' as intl;
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/providers/mainprovider.dart';
import 'package:points_of_sale/helpers/service_locator.dart';
import 'package:provider/provider.dart';
import 'package:points_of_sale/ui/widgets/text_form_input.dart';
import 'package:points_of_sale/helpers/functions.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_svg/svg.dart';

class MyAccount extends StatefulWidget {
  @override
  MyAccountPage createState() => MyAccountPage();
}

class MyAccountPage extends State<MyAccount> with TickerProviderStateMixin {
  List<String> location2;
  SnackBar snackBar = SnackBar(
    content: const Text("Location Service was not aloowed  !"),
    action: SnackBarAction(
      label: 'Ok !',
      onPressed: () {},
    ),
  );
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  static DateTime today = DateTime.now();
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final FocusNode focus = FocusNode();
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();
  File myimage;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: lastDate,
        firstDate: firstDate,
        lastDate: lastDate);
    if (picked != null && picked != today)
      setState(() {
        today = picked;
        birthDateController.text = intl.DateFormat('yyyy-MM-dd').format(picked);
        FocusScope.of(context).requestFocus(FocusNode());
      });
    if (picked == null || picked != today)
      FocusScope.of(context).requestFocus(FocusNode());
  }

  String tempPhone;
  bool showImageOptions = false;
  bool _isButtonEnabled;
  String imageUrl;
  bool imageUplaoding = true;
  AnimationController animationController1,
      animationController2,
      animationController3;

  Animation<double> animation1, animation2, animation3;

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;

    imageUrl = getIt<Auth>().userPicture ?? config.profileUrl;
  }

  void shoeTosted() {
    showToast('new Phone number was Not Verfiyed!',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        startOffset: const Offset(0.0, 3.0),
        reverseEndOffset: const Offset(0.0, 3.0),
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 4),
        animDuration: const Duration(seconds: 1),
        curve: Curves.elasticOut,
        reverseCurve: Curves.fastOutSlowIn);
    return;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
        appBar: AppBar(
            title: Text(trans(context, "my_account"), style: styles.appBars),
            centerTitle: true),
        body: Builder(
            builder: (BuildContext context) => GestureDetector(
                onTap: () {
                  SystemChannels.textInput
                      .invokeMethod<String>('TextInput.hide');
                  if (showImageOptions)
                    setState(() {
                      showImageOptions = false;
                    });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ClipPath(
                      clipper: HeaderColor(),
                      child: Container(
                        color: Colors.orange[300].withOpacity(0.3),
                      ),
                    ),
                    ListView(children: <Widget>[
                      const SizedBox(height: 6),
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {},
                              child: Visibility(
                                visible: imageUplaoding,
                                child: Hero(
                                  child:
                                      Image.asset("assets/images/splash.png"),
                                  tag: "generate_a_unique_tag",
                                ),
                                replacement: Stack(
                                  children: <Widget>[
                                    SizedBox(
                                        child: CircularProgressIndicator(
                                            backgroundColor: colors.trans),
                                        height: 160,
                                        width: 160),
                                    Container(
                                      height: 160,
                                      width: 160,
                                      child: Center(
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: LoadingIndicator(
                                            color: Colors.orange,
                                            indicatorType: Indicator.values[19],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 100,
                            left: MediaQuery.of(context).size.width / 2 + 52,
                            child: InkWell(
                              highlightColor: colors.trans,
                              splashColor: colors.trans,
                              onTap: () {
                                setState(() {
                                  showImageOptions = !showImageOptions;
                                });
                              },
                              child: SvgPicture.asset(
                                  'assets/images/add_profile_pic.svg',
                                  width: 36,
                                  height: 36),
                            ),
                          ),
                        ],
                      ),
                      if (showImageOptions)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            children: <Widget>[
                              TextButton(
                                  child: Text(trans(context, 'open_gallery'),
                                      style: styles.mysmall),
                                  onPressed: () async {
                                    getImage(ImageSource.gallery, mainProvider);
                                  }),
                              TextButton(
                                child: Text(trans(context, "take_photo"),
                                    style: styles.mysmall),
                                onPressed: () async {
                                  getImage(ImageSource.camera, mainProvider);
                                },
                              ),
                              if (myimage == null)
                                Container()
                              else
                                Image.file(myimage),
                            ],
                          ),
                        )
                      else
                        Container(),
                      const SizedBox(height: 24),
                      Consumer<Auth>(
                        builder:
                            (BuildContext context, Auth auth, Widget child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 34),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  TextFormInput(
                                      text: trans(context, 'name'),
                                      cController: usernameController,
                                      prefixIcon: Icons.person_outline,
                                      kt: TextInputType.visiblePassword,
                                      obscureText: false,
                                      readOnly: false,
                                      onFieldSubmitted: () {
                                        focus.requestFocus();
                                      },
                                      onTab: () {},
                                      validator: (String value) {
                                        if (value.length < 3) {
                                          return "username must be more than 3 letters";
                                        }
                                        return auth
                                            .profileValidationMap['name'];
                                      }),
                                  TextFormInput(
                                      text: trans(context, 'email'),
                                      cController: emailController,
                                      prefixIcon: Icons.mail_outline,
                                      kt: TextInputType.emailAddress,
                                      obscureText: false,
                                      readOnly: true,
                                      focusNode: focus,
                                      suffixicon: IconButton(
                                        icon: Icon(Icons.edit,
                                            color: colors.orange),
                                        onPressed: () {},
                                      ),
                                      onTab: () {},
                                      onFieldSubmitted: () {
                                        focus1.requestFocus();
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter a valid email ";
                                        }
                                        return auth
                                            .profileValidationMap['email'];
                                      }),
                                  TextFormInput(
                                      text: trans(context, 'mobile_no'),
                                      cController: mobileNoController,
                                      prefixIcon: Icons.phone,
                                      kt: TextInputType.phone,
                                      obscureText: false,
                                      readOnly: true,
                                      onTab: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/pinForProfile',
                                          arguments: <String, String>{
                                            'mobileNo': mobileNoController.text
                                          },
                                        );
                                      },
                                      suffixicon: IconButton(
                                        icon: Icon(Icons.edit,
                                            color: colors.orange),
                                        onPressed: () {},
                                      ),
                                      focusNode: focus1,
                                      onFieldSubmitted: () {
                                        focus2.requestFocus();
                                      },
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter your mobile Number  ";
                                        }
                                        return auth
                                            .profileValidationMap['phone'];
                                      }),
                                  TextFormInput(
                                      text: trans(context, 'birth_date'),
                                      cController: birthDateController,
                                      prefixIcon: Icons.date_range,
                                      kt: TextInputType.visiblePassword,
                                      obscureText: false,
                                      readOnly: true,
                                      onTab: () {
                                        _selectDate(context);
                                      },
                                      suffixicon: IconButton(
                                        color: colors.orange,
                                        icon: const Icon(Icons.calendar_today),
                                        onPressed: () {
                                          //   _selectDate(context);
                                        },
                                      ),
                                      focusNode: focus3,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "please enter your Birth Date ";
                                        }
                                        return auth
                                            .profileValidationMap['birthdate'];
                                      }),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: mainProvider.visibilityObs
                                        ? Row(
                                            children: <Widget>[
                                              Expanded(child: spinkit),
                                            ],
                                          )
                                        : Container(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: colors.orange)),
                                onPrimary: colors.orange,
                                textStyle: TextStyle(color: colors.white)),
                            onPressed: () async {
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  mainProvider.togelf(true);
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });
                                  print(
                                      " birthDateController.text ${birthDateController.text}");
                                  await getIt<Auth>()
                                      .updateProfile(
                                          usernameController.text,
                                          birthDateController.text,
                                          emailController.text)
                                      .then((bool value) {
                                    setState(() {
                                      _isButtonEnabled = true;
                                    });
                                    if (value) {
                                      ifUpdateTur(context,
                                          "information_updated_successfully");
                                    } else {
                                      _formKey.currentState.validate();
                                    }
                                    getIt<Auth>()
                                        .profileValidationMap
                                        .updateAll((String key, String value) {
                                      return null;
                                    });
                                    mainProvider.togelf(false);
                                  });
                                }
                              }
                            },
                            child: mainProvider.returnchildforProfile(
                              trans(context, 'save_changes'),
                              //  style: styles.notificationNO,
                            )),
                      ),
                    ]),
                  ],
                ))));
  }

  Future<void> getImage(ImageSource imageSource, MainProvider bolc) async {
    final PickedFile image = await ImagePicker().getImage(source: imageSource);
    if (image != null) {
      setState(() {
        imageUrl = "";
        imageUplaoding = false;
      });
    }
  }
}

class HeaderColor extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0.0, size.height - 400);
    path.lineTo(size.width, size.height - 460);
    path.lineTo(size.width, size.height - 560);
    path.lineTo(0.0, size.height - 500);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
