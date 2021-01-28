import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class Getque extends StatefulWidget {
  String qcode;

  Getque(this.qcode);

  State<StatefulWidget> createState() {

    return MyPage(this.qcode);
  }
}
class MyPage extends State<Getque> {

  String something;
  MyPage(this.something);
  String scancode = "";


  @override
  void initState() {
    super.initState();
    scancode = something;
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    setState(() {
      scancode = barcode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Queue'),
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              _scan();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(Icons.settings_overscan),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                padding: EdgeInsets.all(20.0),
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Text('Scan QR Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          child: Divider(),
                        ),
                        Text('Please show your two dimensional code to assign person.', textAlign: TextAlign.center,),


                      ],
                    ),
                  ),
                ),
              ),
            ),

            Container(
              child: Container(

                child:  QrImage(
                  foregroundColor: Colors.black87,
                  data: scancode,
                  version: QrVersions.auto,
                  size: MediaQuery.of(context).size.width - 120,
                ),

              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Divider(),
            ),
            Container(height: 50,),
            Container(

              width: MediaQuery.of(context).size.width - 100,
              height: 50,
              child: FlatButton(

                color: Colors.blue,
                child: new Text('Scan QR', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                onPressed: (){
                  _scan();
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            Container(height: 50,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
              child: Text("Scan code result: " + scancode, textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),),
            ),
          ],
        ),

      )
    );
  }
}
