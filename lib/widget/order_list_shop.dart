import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rabbitfood/model/order_model.dart';
import 'package:rabbitfood/model/user_model.dart';
import 'package:rabbitfood/utility/my_api.dart';
import 'package:rabbitfood/utility/my_constant.dart';
import 'package:rabbitfood/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListShop extends StatefulWidget {
  const OrderListShop({super.key});

  @override
  State<OrderListShop> createState() => _OrderListShopState();
}

class _OrderListShopState extends State<OrderListShop> {
  bool loadStatus = true; //โหลดยังไม่เสร็จ
  bool status = true; //มีข้อมูล

  String? idShop;
  List<OrderModel> orderModels = [];
  List<List<String>> listNameFoods = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> listTotals = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findIdShopAndReadOrder();
  }

  Future findIdShopAndReadOrder() async {
    if (orderModels.length != 0) {
      orderModels.clear();
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    idShop = preferences.getString(MyConstant().keyId);
    print('idShop ===> $idShop');

    String url =
        '${MyConstant().domain}/rabbitfood/getOrderWhereIdShop.php/?isAdd=true&idShop=$idShop';

    await Dio().get(url).then((value) {
      setState(() {
        loadStatus = false;
      });

      if (value.toString() != 'null') {
        // print('value ===> $value');
        var result = json.decode(value.data);
        // print('result ===> $result');

        for (var item in result) {
          OrderModel model = OrderModel.fromJson(item);
          // print('orderdatetime ==> ${model.orderDateTime}');
          List<String> nameFoods =
              MyAPI().createStringArrays(model.nameFood.toString());
          List<String> prices =
              MyAPI().createStringArrays(model.price.toString());
          List<String> amounts =
              MyAPI().createStringArrays(model.amount.toString());
          List<String> sums = MyAPI().createStringArrays(model.sum.toString());

          int total = 0;
          for (var item in sums) {
            total += int.parse(item.toString());
          }

          setState(() {
            orderModels.add(model);
            listNameFoods.add(nameFoods);
            listPrices.add(prices);
            listAmounts.add(amounts);
            listSums.add(sums);
            listTotals.add(total);
          });
        }
      } else {
        setState(() {
          status = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        loadStatus ? MyStyle().showProgress() : showContent(),
      ],
    );
  }

  Widget showContent() {
    return status
        ? showListOrder()
        : Center(
            child: Text(
              'ยังไม่มีรายการออเดอร์อาหารเข้ามาครับ',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          );
  }

  Widget showListOrder() {
    return Scaffold(
      body: orderModels.length == 0
          ? MyStyle().showProgress()
          : ListView.builder(
              itemCount: orderModels.length,
              itemBuilder: (context, index) => Card(
                color: index % 2 == 0
                    ? Colors.yellow.shade200
                    : Colors.yellow.shade300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(orderModels[index].nameUser.toString()),
                      Text(orderModels[index].orderDateTime.toString()),
                      bulidTitle(),
                      bulidContent(index),
                      bulidTotal(index),
                      bulidButton(index),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row bulidButton(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: 120.0,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.deepOrangeAccent, // Background color
            ),
            icon: Icon(Icons.cancel),
            label: Text('Cancel'),
            onPressed: () {
              deleteOrder(orderModels[index]);
            },
          ),
        ),
        Container(
          width: 120.0,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightGreenAccent, // Background color
            ),
            icon: Icon(Icons.restaurant),
            label: Text('Cooking'),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget bulidTotal(int index) {
    return Row(
      children: [
        Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'รวมราคาอาหาร : ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            )),
        Expanded(
          flex: 1,
          child: Text(listTotals[index].toString()),
        ),
      ],
    );
  }

  ListView bulidContent(int index) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      itemCount: listNameFoods[index].length,
      itemBuilder: (context, index2) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(flex: 3, child: Text(listNameFoods[index][index2])),
            Expanded(flex: 1, child: Text(listPrices[index][index2])),
            Expanded(flex: 1, child: Text(listAmounts[index][index2])),
            Expanded(flex: 1, child: Text(listSums[index][index2])),
          ],
        ),
      ),
    );
  }

  Container bulidTitle() {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.yellow.shade700),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('nameFood')),
          Expanded(flex: 1, child: Text('price')),
          Expanded(flex: 1, child: Text('amount')),
          Expanded(flex: 1, child: Text('sum')),
        ],
      ),
    );
  }

  Future deleteOrder(OrderModel orderModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
            'ยืนยันที่จะยกเลิกออเดอร์ ของ ${orderModel.nameUser} ใช่หรือไม่?',
            style: TextStyle(color: Colors.red)),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: (() async {
                    Navigator.pop(context);

                    String url =
                        '${MyConstant().domain}/rabbitfood/deleteOrderWhereId.php?isAdd=true&id=${orderModel.id}';
                    await Dio().get(url).then((value) {
                      print('delete order ${orderModel.nameUser} Success');
                      findIdShopAndReadOrder();
                    });
                  }),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(color: Colors.red),
                  )),
              SizedBox(width: 40.0),
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
