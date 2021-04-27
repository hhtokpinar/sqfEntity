import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:points_of_sale/localization/localization_delegate.dart';
import 'package:points_of_sale/providers/auth.dart';
import 'package:points_of_sale/services/navigationService.dart';
import 'package:points_of_sale/ui/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'constants/config.dart';
import 'constants/route.dart';
import 'constants/themes.dart';
import 'helpers/data.dart';
import 'helpers/service_locator.dart';
import 'providers/language.dart';
import 'providers/mainprovider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_sim_country_code/flutter_sim_country_code.dart';
import 'ui/home.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await data.getData('loggedin').then<dynamic>((String auth) {
    print("auth what :$auth");

    if (auth.isEmpty) {
      config.loggedin = false;
    } else {
      config.loggedin = true;
    }
  });
  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<ChangeNotifier>>[
        ChangeNotifierProvider<Language>(create: (_) => Language()),
        ChangeNotifierProvider<Auth>.value(value: getIt<Auth>()),
        ChangeNotifierProvider<MainProvider>.value(value: getIt<MainProvider>())
      ],
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorState = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Language lang;
  @override
  void initState() {
    super.initState();
    lang = Provider.of<Language>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);
    somefuture(lang, auth);
  }

  Future<void> initPlatformState(Auth auth) async {
    String platformVersion;
    try {
      platformVersion = await FlutterSimCountryCode.simCountryCode;
      print("platform country code : $platformVersion");
      auth.dialCodeFav = platformVersion;

      auth.getCountry(platformVersion);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: getIt<NavigationService>().navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('ar'),
        Locale('en'),
        Locale('tr'),
      ],
      locale: lang.currentLanguage, //config.userLnag,
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        if (locale == null) {
          data.setData("initlang", supportedLocales.first.countryCode);
          return supportedLocales.first;
        }

        for (final Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            data.setData("initlang", supportedLocale.languageCode);
            return supportedLocale;
          }
        }

        data.setData("initlang", supportedLocales.first.countryCode);
        return supportedLocales.first;
      },
      theme: mainThemeData(),
      onGenerateRoute: onGenerateRoute,
      home: SplashScreen(
          seconds: 4,
          navigateAfterSeconds: config.loggedin ? Home() : LoginScreen(),
          image: Image.asset("assets/images/splash.png", fit: BoxFit.contain),
          backgroundColor: Colors.white,
          photoSize: 250,
          title: Text("Point of Sale"),
          loaderColor: Colors.blue
          // navigateAfterFuture: somefuture(lang, auth)
          ),
    );
  }

  Future<String> somefuture(Language lang, Auth auth) async {
    String value = await data.getData("lang");
    if (value.isEmpty) {
    } else {
      config.userLnag = Locale(value);
      await lang.setLanguage(Locale(value));
    }

    await initPlatformState(auth);
    return config.loggedin ? "/Home" : "/login";
  }
}

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title)),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[

//           ],
//         ),
//       ),
//     );
//   }
// }
