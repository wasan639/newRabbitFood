import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/normal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddRiderInfomation extends StatefulWidget {
  const AddRiderInfomation({super.key});

  @override
  State<AddRiderInfomation> createState() => _AddRiderInfomationState();
}

class _AddRiderInfomationState extends State<AddRiderInfomation> {

  String? urlImage;

  String? firstNameRider;
  String? lastNameRider;
  String? addressRider;
  String? phoneRider;
  String? dateofbirthRider;
  String? genderRider;
  String? idNumberRider;
  String? motorcycleNumberRider;

  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add info Rider'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'ข้อมูลส่วนตัว',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              groupImage(),
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
              saveButton(),
            ],
          ),
        ),
      ),
    );
  }

    Widget saveButton() {
    return Container(
      height: 50.0,
      width: 370.0,
      child: ElevatedButton.icon(
        onPressed: () {
          if (firstNameRider == null ||
              firstNameRider!.isEmpty ||
              lastNameRider == null ||
              lastNameRider!.isEmpty ||
              addressRider == null ||
              addressRider!.isEmpty ||
              phoneRider == null ||
              phoneRider!.isEmpty ||
              dateofbirthRider == null ||
              dateofbirthRider!.isEmpty ||
              genderRider == null ||
              genderRider!.isEmpty ||
              idNumberRider == null ||
              idNumberRider!.isEmpty ||
              motorcycleNumberRider == null ||
              motorcycleNumberRider!.isEmpty) {
            normalDialog(context, 'กรุณากรอกข้อมูลให้ครบ');
          } else if (file == null) {
            normalDialog(context, 'กรุณาเพิ่มรูปภาพของคุณ');
          } else {
            uploadImage();
          }
        },
        icon: Icon(
          Icons.save,
          size: 28.0,
        ),
        label: Text(
          'Save Infomation',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
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

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.add_a_photo, size: 36.0),
          onPressed: () {
            chooseImage(ImageSource.camera);
          },
        ),
        Container(
            width: 200.0,
            child: file == null
                ? Image.asset('images/addimage.png')
                : Image.file(file!)),
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
    );
  }

Future uploadImage() async {
    Random random = Random();
    int i = random.nextInt(1000000);
    String nameImage = 'riderimageprofile$i.jpg';
    String url = '${MyConstant().domain}/rabbitfood/saveRider.php/';
    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) {
        print('respose ==> $value');
        urlImage = '/rabbitfood/Rider/$nameImage';
        print('urlImage === $urlImage');
        editUserShop();
      });
    } catch (e) {}
  }

 Future editUserShop() async {
    
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? id = preferences.getString('id');

    String url = '${MyConstant().domain}/rabbitfood/editRiderWhereId.php?isAdd=true&id=$id&NameRider=$firstNameRider&AddressRider=$addressRider&PhoneRider=$phoneRider&UrlPicture=$urlImage&LastNameRider=$lastNameRider&DOBRider=$dateofbirthRider&genderRider=$genderRider&IdNumberRider=$idNumberRider&MotorNumberRider=$motorcycleNumberRider';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
      } else {
        normalDialog(
            context, 'ไม่สามารถบันทึกข้อมูลของคุณได้ กรุณาลองใหม่อีกครั้ง');
      }
    });
  }

  Widget firstNameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 250.0,
            child: TextField(
              onChanged: (value) => firstNameRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => lastNameRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => addressRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => phoneRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => dateofbirthRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => genderRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => idNumberRider = value.trim(),
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
            child: TextField(
              onChanged: (value) => motorcycleNumberRider = value.trim(),
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
