import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart' as intl;
import 'package:points_of_sale/constants/styles.dart';
import 'package:points_of_sale/helpers/functions.dart';
import 'package:points_of_sale/localization/trans.dart';
import 'package:points_of_sale/providers/mainprovider.dart';
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/ui/widgets/countryCodePicker.dart';
import '../widgets/buttonTouse.dart';
import '../widgets/text_form_input.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/helpers/data.dart';
import 'package:location/location.dart';

class Registration extends StatefulWidget {
  @override
  _MyRegistrationState createState() => _MyRegistrationState();
}

class _MyRegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  List<String> location2;
  bool _isButtonEnabled;
  bool _obscureText = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  static DateTime today = DateTime.now();
  DateTime firstDate = DateTime(today.year - 90, today.month, today.day);
  DateTime lastDate = DateTime(today.year - 18, today.month, today.day);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;
    data.getData("countryDialCodeTemp").then((String value) {});
    type = "supermarket";
    tryToAnimate();
  }

  bool serviceEnabled;
  PermissionStatus permissionGranted;
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

  Future<void> tryToAnimate() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      await location.requestService();
    } else {
      permissionGranted = await location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
      } else {
        await location.requestPermission();
      }
    }
  }

  String type = "";
  Widget customcard(
      BuildContext context, MainProvider mainProvider, Auth auth) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    final FocusNode focus = FocusNode();
    final FocusNode focusminus1 = FocusNode();
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();
    final FocusNode focus3 = FocusNode();
    return Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
        child: Form(
            autovalidateMode: AutovalidateMode.disabled,
            key: _formKey,
            // onWillPop: () {
            //   return onWillPop(context);
            // },
            child: Column(children: <Widget>[
              TextFormInput(
                  text: trans(context, 'name'),
                  cController: usernameController,
                  prefixIcon: Icons.person_outline,
                  kt: TextInputType.visiblePassword,
                  obscureText: false,
                  focusNode: focusminus1,
                  readOnly: false,
                  onFieldSubmitted: () {
                    focus.requestFocus();
                  },
                  onTab: () {
                    focusminus1.requestFocus();
                  },
                  validator: (String value) {
                    if (value.length < 3) {
                      return trans(context, 'username_more_than_3');
                    }
                    return auth.regValidationMap['name'];
                  }),
              // 0595388810
              TextFormInput(
                  text: trans(context, 'email'),
                  cController: emailController,
                  prefixIcon: Icons.mail_outline,
                  kt: TextInputType.emailAddress,
                  obscureText: false,
                  readOnly: false,
                  focusNode: focus,
                
                  onFieldSubmitted: () {
                    focus1.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_valid_email');
                    }
                    return auth.regValidationMap['email'];
                  }),
              TextFormInput(
                  text: trans(context, 'mobile_no'),
                  cController: mobileNoController,
                  prefixIcon: Icons.phone,
                  kt: TextInputType.phone,
                  obscureText: false,
                  readOnly: false,
                  onTab: () {},
                  suffixicon: CountryPickerCode(context: context, isRTL: isRTL),
                  focusNode: focus1,
                  onFieldSubmitted: () {
                    focus2.requestFocus();
                  },
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_valid_email');
                    }
                    return auth.regValidationMap['phone'];
                  }),
              TextFormInput(
                  text: trans(context, 'password'),
                  cController: passwordController,
                  prefixIcon: Icons.lock_outline,
                  kt: TextInputType.visiblePassword,
                  readOnly: false,
                  onTab: () {},
                   onFieldSubmitted: () {
                    focus3.requestFocus();
                  },
                  suffixicon: IconButton(
                    icon: Icon(
                      (_obscureText == false)
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: colors.blue,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  obscureText: _obscureText,
                  focusNode: focus2,
                  validator: (String value) {
                    if (passwordController.text.length < 6) {
                      return trans(context, 'pass_must_more_6');
                    }
                    return auth.regValidationMap['password'];
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
                  suffixicon: Icon(
                    Icons.calendar_today,
                    color: colors.blue ,
                  ),
                  focusNode: focus3,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return trans(context, 'plz_enter_birthdate');
                    }
                    return auth.regValidationMap['birthdate'];
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        dropdownColor: colors.grey,
                        value: type,
                        hint: Text(trans(context, "category")),
                        items: <String>[
                          trans(context, "supermarket"),
                          trans(context, "restaurant")
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String choice) {
                          print("type on change $choice");
                          setState(() {
                            type = choice;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    return Scaffold(
        appBar: AppBar(),
        body: Builder(
          builder: (BuildContext context) => GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod<String>('TextInput.hide');
            },
            child: Consumer<Auth>(
                builder: (BuildContext context, Auth auth, Widget child) {
              return ListView(
                children: <Widget>[
                  const SizedBox(height: 16),
                  Text(trans(context, 'account_creation'),
                      textAlign: TextAlign.center, style: styles.mystyle2),
                  const SizedBox(height: 8),
                  Text(trans(context, 'please_check'),
                      textAlign: TextAlign.center, style: styles.pleazeCheck),
                  customcard(context, mainProvider, auth),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) => colors.blue),
                            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                (Set<MaterialState> states) => RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: colors.blue))),
                            textStyle:
                                MaterialStateProperty.resolveWith<TextStyle>(
                                    (Set<MaterialState> states) =>
                                        TextStyle(color: colors.white))),
                        onPressed: () async {
                          if (_isButtonEnabled) {
                            if (_formKey.currentState.validate()) {
                              mainProvider.togelf(true);
                              setState(() {
                                _isButtonEnabled = false;
                              });
                              await auth.register(
                                  context,
                                  usernameController.text,
                                  passwordController.text,
                                  emailController.text,
                                  mobileNoController.text,
                                  birthDateController.text,
                                  type);

                              _formKey.currentState.validate();

                              auth.regValidationMap
                                  .updateAll((String key, String value) {
                                return null;
                              });
                            }
                            setState(() {
                              _isButtonEnabled = true;
                            });
                            mainProvider.togelf(false);
                          }
                        },
                        child: mainProvider
                            .returnchild(trans(context, 'regisration'))),
                  ),
                  const Padding(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      child: Divider(color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          trans(context, 'problem_in_regisration'),
                          style: styles.mystyle,
                        ),
                      ),
                      ButtonToUse(
                        trans(context, 'tech_support'),
                        fontWait: FontWeight.bold,
                        fontColors: Colors.green,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
        ));
  }
}
