import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:rabbitfood/utility/signout_process.dart';
import 'package:rabbitfood/widget/infomation_shop.dart';
import 'package:rabbitfood/widget/list_food_menu_shop.dart';
import 'package:rabbitfood/widget/order_list_shop.dart';

class MainShop extends StatefulWidget {
  const MainShop({super.key});

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  Widget currentWidget = OrderListShop();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aboutNotification();
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print('aboutNoti Work Android');

      // onMessage: When the app is open and it receives a push notification
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("onMessage data: ${message.data}");
        String title = message.data['title'];
        String body = message.data['body'];
        normalDialog2(context, title, body);
      });

      // replacement for onResume: When the app is in the background and opened directly from the push notification.
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('onMessageOpenedApp data: ${message.data}');
        String title = message.data['title'];
        String body = message.data['body'];
        normalDialog2(context, title, body);
      });
    } else if (Platform.isIOS) {
      print('aboutNoti Work iOS');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Shop'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => signOutProcess(context),
          )
        ],
      ),
      drawer: showDrawer(),
      body: currentWidget,
    );
  }

  Drawer showDrawer() => Drawer(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                showHead(),
                homeMenu(),
                foodMenu(),
                infomationMenu(),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                signOutMenu(),
              ],
            ),
          ],
        ),
      );

  ListTile homeMenu() => ListTile(
        leading: Icon(Icons.home),
        title: Text('รายการอาหารที่ ลูกค้าสั่ง'),
        subtitle: Text('รายการอาหารที่ยังไม่ได้ ทำส่งลูกค้า'),
        onTap: () {
          setState(() {
            currentWidget = OrderListShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile foodMenu() => ListTile(
        leading: Icon(Icons.fastfood),
        title: Text('รายการอาหาร'),
        subtitle: Text('รายการอาหาร ของร้าน'),
        onTap: () {
          setState(() {
            currentWidget = ListFoodMenuShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile infomationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('รายละเอียด ของร้าน'),
        subtitle: Text('รายละเอียด ของร้าน พร้อม Edit'),
        onTap: () {
          setState(() {
            currentWidget = InfomationShop();
          });
          Navigator.pop(context);
        },
      );

  ListTile signOutMenu() => ListTile(
        leading: Icon(Icons.exit_to_app),
        title: Text('Sign Out'),
        subtitle: Text('Sign Out และ กลับไป หน้าแรก'),
        onTap: () => signOutProcess(context),
      );

  UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('shop.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'Name Shop',
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
