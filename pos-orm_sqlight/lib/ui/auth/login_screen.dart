import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:points_of_sale/constants/colors.dart';
import 'package:points_of_sale/constants/styles.dart';
import 'package:points_of_sale/localization/trans.dart';
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/providers/mainprovider.dart';
import '../widgets/text_form_input.dart';
import 'package:provider/provider.dart';
import '../widgets/buttonTouse.dart';

class LoginScreen extends StatefulWidget {
  @override
  _MyLoginScreenState createState() => _MyLoginScreenState();
}

class _MyLoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isButtonEnabled = true;
  bool _obscureText = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _focus1 = FocusNode();
  final FocusNode _focus2 = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  Widget customcard(BuildContext context,
      {MainProvider mainProvider, Auth auht, bool isRTL}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 30, 15, 0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormInput(
              text: trans(context, 'email'),
              cController: _usernameController,
              prefixIcon: Icons.email_outlined,
              kt: TextInputType.emailAddress,
              obscureText: false,
              readOnly: false,
              onTab: () {},
              //suffixicon: CountryPickerCode(context: context, isRTL: isRTL),
              onFieldSubmitted: () {
                _focus1.requestFocus();
              },
              validator: (String value) {
                if (value.isEmpty) {
                  return trans(context, 'enter_email');
                }
                return auht.loginValidationMap['email'];
              },
            ),
            TextFormInput(
              text: trans(context, 'password'),
              cController: _passwordController,
              prefixIcon: Icons.lock_outline,
              kt: TextInputType.visiblePassword,
              onTab: () {},
              suffixicon: IconButton(
                icon: Icon(
                  (_obscureText == false)
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
              onFieldSubmitted: () {
                _focus2.requestFocus();
              },
              obscureText: _obscureText,
              focusNode: _focus1,
              validator: (String value) {
                if (value.isEmpty) {
                  return trans(context, 'p_enter_password');
                }
                return auht.loginValidationMap['password'];
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MainProvider mainProvider = Provider.of<MainProvider>(context);
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: Image.asset("assets/images/splash.png"
                    // width: 220.0, height: 220.0,
                    ),
              ),
            ),
            Expanded(
              child: Consumer<Auth>(
                builder: (BuildContext context, Auth auth, Widget child) {
                  return Column(
                    children: <Widget>[
                      customcard(context,
                          mainProvider: mainProvider, isRTL: isRTL, auht: auth),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        alignment: isRTL
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: ButtonToUse(
                          trans(context, 'forget_password'),
                          fontWait: FontWeight.w500,
                          fontColors: colors.black,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/forget_pass');
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) => colors.blue),
                                shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
                                    (Set<MaterialState> states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: BorderSide(color: colors.blue))),
                                textStyle:
                                    MaterialStateProperty.resolveWith<TextStyle>(
                                        (Set<MaterialState> states) =>
                                            TextStyle(color: colors.white))),
                            onPressed: () async {
                              print(
                                  "_usernameController.text : ${_usernameController.text}");
                              if (_isButtonEnabled) {
                                if (_formKey.currentState.validate()) {
                                  mainProvider.togelf(true);
                                  setState(() {
                                    _isButtonEnabled = false;
                                  });
                                  if (await auth.login(_usernameController.text,
                                      _passwordController.text, context)) {
                                    print("wghats wrong");
                                    Navigator.popAndPushNamed(
                                        context, '/Home');
                                  } else {
                                    _formKey.currentState.validate();
                                  }
                                  auth.loginValidationMap
                                      .updateAll((String key, String value) {
                                    return null;
                                  });
                                  setState(() {
                                    _isButtonEnabled = true;
                                  });
                                  mainProvider.togelf(false);
                                }
                              }
                            },
                            child: mainProvider
                                .returnchild(trans(context, 'login'))),
                      ),
                      const SizedBox(height: 40),
                      Text(trans(context, 'dont_have_account'),
                          style: styles.mystyle),
                      ButtonToUse(trans(context, 'create_account'),
                          fontWait: FontWeight.bold,
                          fontColors: Colors.black,
                          width: MediaQuery.of(context).size.width,
                          onPressed: () {
                        Navigator.pushNamed(context, '/Registration');
                      }),
                    ],
                  );
                },
              ),
            ),
            // Expanded(
            //   child: Container()
            // ),
          ]),
        ));
  }
}
