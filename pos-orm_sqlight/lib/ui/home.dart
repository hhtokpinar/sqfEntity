import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:points_of_sale/localization/trans.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  @override
  void initState() {
    super.initState();
    title = "Home";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: SliderMenuContainer(
          slideDirection: SlideDirection.TOP_TO_BOTTOM,
          appBarColor: Colors.white,
          key: _key,
          sliderMenuOpenSize: 200,
          splashColor: Colors.red,
          // trailing: Text("wiejgwerg"),
          title: Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          sliderMenu: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                         Navigator.pushNamed(context, "/Items");
                      },
                      child: Text(trans(context, "items_screen")),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                         Navigator.pushNamed(context, "/Store");
                      },
                      child: Text(trans(context, "store_screen")),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                        Navigator.pushNamed(context, "/Profile");
                      },
                      child: Text(trans(context, "account")),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                        Navigator.pushNamed(context, "/Customers");
                      },
                      child: Text(trans(context, "customers")),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                        Navigator.pushNamed(context, "/Transactions");
                      },
                      child: Text(trans(context, "transactions")),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _key.currentState.closeDrawer();
                        setState(() {
                          this.title = title;
                        });
                        Navigator.pushNamed(context, "/Collections");
                      },
                      child: Text(trans(context, "collections")),
                    ),
                  ),
                ],
              ),
            ],
          ),
          sliderMain: ListView(children: []),
        ),
        floatingActionButton: FabCircularMenu(
          key: fabKey,
          // Cannot be `Alignment.center`
          alignment: Alignment.bottomRight,
          ringColor: Colors.blue.shade100,
          ringDiameter: 400.0,
          ringWidth: 100.0,
          fabSize: 64.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          fabColor: Colors.blue,

          fabOpenIcon: Icon(Icons.menu, color: Colors.white),
          fabCloseIcon: Icon(Icons.close, color: Colors.orange),
          fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.easeInOutCirc,
          onDisplayChange: (isOpen) {},
          children: <Widget>[
            RawMaterialButton(
              animationDuration: Duration(seconds: 3),
              fillColor: Colors.white,
              onPressed: () {
                fabKey.currentState.close();
                _key.currentState.closeDrawer();
                Navigator.pushNamed(context, "/AddTransaction");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.add_shopping_cart_outlined,
                  color: Colors.blue, size: 42),
            ),
            RawMaterialButton(
              animationDuration: Duration(seconds: 3),
              fillColor: Colors.white,
              onPressed: () {
                fabKey.currentState.close();
                _key.currentState.closeDrawer();
                Navigator.pushNamed(context, "/AddTransaction");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.local_shipping_outlined,
                  color: Colors.blue, size: 42),
            ),
            RawMaterialButton(
              animationDuration: Duration(seconds: 3),
              fillColor: Colors.white,
              onPressed: () {
                fabKey.currentState.close();
                _key.currentState.closeDrawer();
                Navigator.pushNamed(context, "/AddCollection");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.attach_money_outlined,
                  color: Colors.blue, size: 42),
            ),
            RawMaterialButton(
              animationDuration: Duration(seconds: 3),
              fillColor: Colors.white,
              onPressed: () {
                fabKey.currentState.close();
                _key.currentState.closeDrawer();
                Navigator.pushNamed(context, "/AddCustomer");
              },
              shape: CircleBorder(),
              padding: const EdgeInsets.all(12.0),
              child: Icon(Icons.store_mall_directory_outlined,
                  color: Colors.blue, size: 42),
            )
          ],
        ));
  }
}
