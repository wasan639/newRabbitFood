import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/screens/main_rider.dart';
import 'package:rabbitfood/screens/main_shop.dart';
import 'package:rabbitfood/screens/main_user.dart';
import 'package:rabbitfood/screens/signin.dart';
import 'package:rabbitfood/screens/signup.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //String token = " ";
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPreferance();
  }

  // void getToken() async{
  //   await FirebaseMessaging.instance.getToken().then((value) {
  //     setState(() {
  //       token = value!;
  //       print('this is my token ==> $token');
  //     });
  //   });
  // }

  Future checkPreferance() async {
    try {
      // getToken();
      String? token = await FirebaseMessaging.instance.getToken();
      print('this is my token ==> $token');

      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString('ChooseType').toString();
      String? idLogin = preferences.getString('id');
      print('idLogin = $idLogin');

      if (idLogin != null && idLogin.isNotEmpty) {
        String url =
            '${MyConstant().domain}/rabbitfood/editTokenWhereId.php?isAdd=true&id=$idLogin&Token=$token';

        await Dio().get(url).then((value) => print('##### Update Token Success #####'));

      }

      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'User') {
          routeToService(MainUser());
        } else if (chooseType == 'Shop') {
          routeToService(MainShop());
        } else if (chooseType == 'Rider') {
          routeToService(MainRider());
        }
        // else {
        //   normalDialog(context, 'Error User Type');
        // }
      }
    } catch (e) {}
  }

  void routeToService(Widget myWidget) {
    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: showDrawer(),
    );
  }

  Drawer showDrawer() => Drawer(
        child: ListView(
          children: <Widget>[
            showHeadDrawer(),
            signInMenu(),
            signUpMenu(),
          ],
        ),
      );

  ListTile signInMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign In'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignIn());
        Navigator.push(context, route);
      },
    );
  }

  ListTile signUpMenu() {
    return ListTile(
      leading: Icon(Icons.android),
      title: Text('Sign Up'),
      onTap: () {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (value) => SignUp());
        Navigator.push(context, route);
      },
    );
  }

  UserAccountsDrawerHeader showHeadDrawer() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('guestuser.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text('Guest', style: TextStyle(color: Colors.white)),
      accountEmail: Text('Please Login', style: TextStyle(color: Colors.white)),
    );
  }
  
  
}
  

