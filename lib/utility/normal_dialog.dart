import 'package:flutter/material.dart';
import 'package:rabbitfood/utility/my_style.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  //โชว์แจ้งเตือนการทำงานต่างๆ
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  //style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}

Future<void> normalDialog2(
    BuildContext context, String title, String message) async {
  //โชว์แจ้งเตือนการทำงานต่างๆ
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Container(
          width: 50.0,
          child: Image.asset('images/bunny.png'),
        ),
        title: Text(title),
        subtitle: Text(message),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  //style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}
