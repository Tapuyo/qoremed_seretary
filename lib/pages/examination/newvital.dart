import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qoremed_app/utils/constants.dart';


class NewVital extends StatefulWidget {

  @override
  _NewVit createState() => _NewVit();
}

class _NewVit extends State<NewVital> {

  String allmap = "";

  List<Item> itemList = [];


  Map<String, String> quantities = {};


  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata()async{
    List<Item> it = [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/references/vital-types";
    final response = await http.get(url,headers: headers);
    var jsondata = json.decode(response.body);
    for(var u in jsondata){
      String des,id,name,unit;
      des = u['name'].toString();
      id = "vital" + u['id'].toString();
      name = "";
      unit = u['unit'].toString();
      Item item = Item(des,id,name,unit);
      it.add(item);
    }

    setState(() {
      itemList = it;
    });
  }
  void takeNumber(String text, String itemId) {
    try {
      String number = text;
      quantities[itemId] = number;
      print(quantities);


    } on FormatException {

    }
  }

  printingdata(){
    print(quantities.toString());
    setState(() {
      allmap = quantities.toString();
    });
    booknow();
  }
  static showProgressDialog(BuildContext context) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }

  booknow()async{
    showProgressDialog(context);
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/patients/" + AppVar.patient_id + "/vitals/";
    Map<String, String> body = quantities; //
    final response = await http.post(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    //print("Vital adding "+ jsondata.toString());

    if(response.statusCode == 200){
      print("Vital adding ssssss"+ response.body.toString());
      Navigator.pop(context);
    }else{
      //print(response.body);
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  Widget singleItemList(int index) {
    Item item = itemList[index];

    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(flex: 2,
                  child: Text(item.des)
              ),
        /*      Expanded(flex: 1,
                  child: Text(item.id)
              ),*/
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 3,
                child: TextField(
                  onChanged: (text) {
                    takeNumber(text, item.id);
                  },
                  decoration: InputDecoration(
                    labelText: item.unit,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Vitals"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,size: 30,
              color: kColorBlue,
            ),
            onPressed: () {
              printingdata();
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              height: 50,
              color: kColorDarkBlue,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text("Enter your new vital report",style: TextStyle(fontSize: 18,color: Colors.white),),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    if (itemList.isEmpty) {
                      return Center(
                          child: CircularProgressIndicator());
                    } else {
                      return singleItemList(index);
                    }
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item {
  final String des;
  final String id;
  final String name;
  final String unit;

  Item(this.des, this.id, this.name,this.unit);
}