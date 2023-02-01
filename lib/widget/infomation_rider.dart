import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/screens/add_rider_info.dart';
import 'package:rabbitfood/screens/edit_rider_info.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfomationRider extends StatefulWidget {
  const InfomationRider({super.key});

  @override
  State<InfomationRider> createState() => _InfomationRiderState();
}

class _InfomationRiderState extends State<InfomationRider> {
  UserModel? userModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readDataUser();
  }

  Future readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url =
        '${MyConstant().domain}/rabbitfood/getUserWhereID.php?isAdd=true&id=$id';
    await Dio().get(url).then((value) {
      //  print('value == $value');
      var result = jsonDecode(value.data);
      //  print('result == $result');
      for (var map in result) {
        setState(() {
          userModel = UserModel.fromJson(map);
        });
      }
    });
  }

  Future routeToAddInfo() async {
    Widget widget = userModel!.nameRider!.isEmpty
        ? AddRiderInfomation()
        : EditRiderInfomation();
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (context) => widget);
    Navigator.push(context, materialPageRoute).then((value) => readDataUser());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        userModel == null
            ? MyStyle().showProgress()
            : userModel!.nameRider!.isEmpty
                ? showNoData(context)
                : showListInfoRider(),
        addAnEditButton(),
      ],
    );
  }

  Widget showListInfoRider() => Column(
        children: [
          MyStyle().showTitleH2('ข้อมูลส่วนตัว'),
          showImage(),
          Text('ชื่อ : ${userModel!.nameRider}'),
          Text('นามสกุล : ${userModel!.lastNameRider}'),
          Text('วัน/เดือน/ปี เกิด : ${userModel!.dOBRider}'),
          Text('รหัสประจำตัวประชาชน : ${userModel!.idNumberRider}'),
          Text('เพศ : ${userModel!.genderRider}'),
          Text('เบอร์โทรศัพท์ : ${userModel!.phoneRider}'),
          Text('ที่อยู่ของร้าน : ${userModel!.addressRider}'),
          Text('เลขทะเบียนรถ : ${userModel!.motorNumberRider}'),
          // SizedBox(height: 20),
          // userModel!.lat == null ? MyStyle().showProgress() : showMap(),
        ],
      );

  Row addAnEditButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: FloatingActionButton(
                  child: Icon(Icons.edit),
                  onPressed: () {
                    routeToAddInfo();
                  }),
            ),
          ],
        ),
      ],
    );
  }

  Widget showImage() {
    return Container(
      width: 200.0,
      height: 200.0,
      child: Image.network('${MyConstant().domain}${userModel!.urlPicture.toString()}'),
    );
  }

  Widget showNoData(BuildContext context) {
    return MyStyle()
        .titleCenter(context, 'ยังไม่มี ข้อมูล กรุณาเพิ่มข้อมูลด้วย คะ');
  }
}
