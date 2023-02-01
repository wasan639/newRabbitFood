import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/signout_process.dart';
import 'package:rabbitfood/widget/infomation_rider.dart';
import 'package:rabbitfood/widget/order_list_shop.dart';

class MainRider extends StatefulWidget {
  const MainRider({super.key});

  @override
  State<MainRider> createState() => _MainRiderState();
}

class _MainRiderState extends State<MainRider> {
Widget currentWidget = OrderListShop();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Rider'),
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


UserAccountsDrawerHeader showHead() {
    return UserAccountsDrawerHeader(
      decoration: MyStyle().myBoxDecoration('rider.jpg'),
      currentAccountPicture: MyStyle().showLogo(),
      accountName: Text(
        'Name Rider',
        style: TextStyle(color: Colors.white),
      ),
      accountEmail: Text(
        'Login',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

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

  ListTile infomationMenu() => ListTile(
        leading: Icon(Icons.info),
        title: Text('ข้อมูลส่วนตัวไรเดอร์'),
        subtitle: Text('รายละเอียดข้อมูลส่วนตัวของไรเดอร์ พร้อม Edit'),
        onTap: () {
          setState(() {
            currentWidget = InfomationRider();
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


}