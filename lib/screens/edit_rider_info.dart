import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditRiderInfomation extends StatefulWidget {
  const EditRiderInfomation({super.key});

  @override
  State<EditRiderInfomation> createState() => _EditRiderInfomationState();
}

class _EditRiderInfomationState extends State<EditRiderInfomation> {
  UserModel? userModel;

  String? urlImage;

  String? firstNameRider;
  String? lastNameRider;
  String? addressRider;
  String? phoneRider;
  String? dateofbirthRider;
  String? genderRider;
  String? idNumberRider;
  String? motorcycleNumberRider;

  File? file = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentInfo();
  }

  Future readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');
    print('id ====== $id');

    String url =
        '${MyConstant().domain}/rabbitfood/getUserWhereId.php?isAdd=true&id=$id';

    Response response = await Dio().get(url);
    print('response ==== $response');

    var result = jsonDecode(response.data);
    print('result ==== $result');

    for (var map in result) {
      print(map);
      if (mounted)
        setState(() {
          userModel = UserModel.fromJson(map);
          firstNameRider = userModel!.nameRider;
          lastNameRider = userModel!.lastNameRider;
          addressRider = userModel!.addressRider;
          phoneRider = userModel!.phoneRider;
          dateofbirthRider = userModel!.dOBRider;
          genderRider = userModel!.genderRider;
          idNumberRider = userModel!.idNumberRider;
          motorcycleNumberRider = userModel!.motorNumberRider;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขข้อมูลส่วนตัวไรเดอร์'),
      ),
      body: userModel == null ? MyStyle().showProgress() : showContent(),
    );
  }

  Widget showContent() => SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'ข้อมูลส่วนตัว',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            showImage(),
            Text(
              'รูปโปรไฟล์',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            firstNameForm(),
            SizedBox(height: 20.0),
            lastNameForm(),
            SizedBox(height: 20.0),
            addressForm(),
            SizedBox(height: 20.0),
            phoneForm(),
            SizedBox(height: 20.0),
            dateOfBirthForm(),
            SizedBox(height: 20.0),
            genDerForm(),
            SizedBox(height: 20.0),
            idNumberForm(),
            SizedBox(height: 20.0),
            motorcycleNumberForm(),
            SizedBox(height: 20.0),
            editButton(),
          ],
        ),
      );

Widget editButton() {
    return Container(
      margin: EdgeInsets.only(top: 16.0, bottom: 16.0),
      height: 50.0,
      width: 320.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (firstNameRider!.isEmpty ||
              lastNameRider!.isEmpty ||
              addressRider!.isEmpty ||
              phoneRider!.isEmpty ||
              dateofbirthRider!.isEmpty ||
              genderRider!.isEmpty ||
              idNumberRider!.isEmpty ||
              motorcycleNumberRider!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else {
            confirmDialog();
          }
        },
        icon: Icon(
          Icons.edit,
          size: 30.0,
        ),
        label: Text(
          'ยืนยันการแก้ไข',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }


  Future confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('ยืนยันการแก้ไขหรือไม่'),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    editThread();
                  }),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.black),
                  )),
              SizedBox(width: 40.0),
              OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('ยกเลิก', style: TextStyle(color: Colors.black))),
            ],
          ),
        ],
      ),
    );
  }

  Future editThread() async {
    if (file != null) {
      Random random = Random();
      int i = random.nextInt(1000000);
      String nameImage = 'riderimageprofile$i.jpg';

      try {
        Map<String, dynamic> map = Map();
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameImage);
        FormData formData = FormData.fromMap(map);

        String urlUpload = '${MyConstant().domain}/rabbitfood/saveRider.php';

        await Dio().post(urlUpload, data: formData).then((value) {
          //print('respose ==> $value');
          urlImage = '/rabbitfood/Rider/$nameImage';
          //print('urlImage === $urlImage');
        });
      } catch (e) {
        // TODO
      }
    }

    String? id = userModel!.id;

    String url =
        '${MyConstant().domain}/rabbitfood/editRiderWhereId.php?isAdd=true&id=$id&NameRider=$firstNameRider&AddressRider=$addressRider&PhoneRider=$phoneRider&UrlPicture=$urlImage&LastNameRider=$lastNameRider&DOBRider=$dateofbirthRider&genderRider=$genderRider&IdNumberRider=$idNumberRider&MotorNumberRider=$motorcycleNumberRider';

    Response response = await Dio().get(url);
    if (response.toString() == 'true') {
      Navigator.pop(context);
    } else {
      normalDialog(context, 'ไม่สามารถแก้ไขข้อมูลร้านได้ กรุณาลองใหม่อีกครั้ง');
    }
  }

  Future chooseImage(ImageSource imageSource) async {
    try {
      var pickedImage = await ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );
      setState(() {
        file = File(pickedImage!.path);
      });
    } catch (e) {}
  }

  Widget showImage() => Container(
        margin: EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add_a_photo, size: 36.0),
              onPressed: () {
                chooseImage(ImageSource.camera);
              },
            ),
            Container(
              height: 250.0,
              width: 250.0,
              child: file == null
                  ? Image.network('${MyConstant().domain}${userModel!.urlPicture}')
                  : Image.file(file!),
            ),
            IconButton(
              icon: Icon(
                Icons.add_photo_alternate,
                size: 36.0,
              ),
              onPressed: () {
                chooseImage(ImageSource.gallery);
              },
            )
          ],
        ),
      );

  Widget firstNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => firstNameRider = value,
              initialValue: firstNameRider,
              decoration: InputDecoration(
                labelText: 'ชื่อ :',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget lastNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => lastNameRider = value,
              initialValue: lastNameRider,
              decoration: InputDecoration(
                labelText: 'นามสกุล :',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => addressRider = value,
              initialValue: addressRider,
              decoration: InputDecoration(
                labelText: 'ที่อยู่ :',
                prefixIcon: Icon(Icons.home_filled),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget phoneForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => phoneRider = value,
              initialValue: phoneRider,
              decoration: InputDecoration(
                labelText: 'เบอร์โทรศัพท์ :',
                prefixIcon: Icon(Icons.phone_android),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget dateOfBirthForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => dateofbirthRider = value,
              initialValue: dateofbirthRider,
              decoration: InputDecoration(
                labelText: 'วัน/เดือน/ปี เกิด :',
                prefixIcon: Icon(Icons.cake),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget genDerForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => genderRider = value,
              initialValue: genderRider,
              decoration: InputDecoration(
                labelText: 'เพศ :',
                prefixIcon: Icon(Icons.transgender),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget idNumberForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => idNumberRider = value,
              initialValue: idNumberRider,
              decoration: InputDecoration(
                labelText: 'เลขประจำตัวประชาชน :',
                prefixIcon: Icon(Icons.add_card),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget motorcycleNumberForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextFormField(
              onChanged: (value) => motorcycleNumberRider = value,
              initialValue: motorcycleNumberRider,
              decoration: InputDecoration(
                labelText: 'ทะเบียนรถ :',
                prefixIcon: Icon(Icons.motorcycle),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}
