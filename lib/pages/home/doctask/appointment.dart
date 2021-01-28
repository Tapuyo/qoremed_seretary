import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/utils/constants.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import '../../../routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AppToday extends StatefulWidget {
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<AppToday> {
  String scancode = "";
  bool vis1,vis2;
  String v1,v2;
  bool scanbool;
  bool _goodna;
  @override
  void initState() {
    super.initState();
    v1 = "Queue";
    v2 = "Queue";
    vis1 = false;
    vis2 = false;
    scanbool = false;
    _goodna = false;
  }

  @override
  void dispose() {

    super.dispose();

  }
  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    setState(() {
      scancode = barcode;
      if(scancode == 'vis1'){
        setState(() {
          vis1 = true;
        });
      }
      if(scancode == 'vis2'){
        setState(() {
          vis2 = true;
        });
      }
    });
  }
  qrscan(){
    if(_goodna == true) {
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/scanqrcodego.png'),
      );
    }else{
      return CircleAvatar(
        radius: 50,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/scanqrcode.png'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Appointment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                value: _goodna,
                onChanged: (_) {
                  setState(() {
                    _goodna = !_goodna;
                  });
                },
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Doctor is In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Start the queue and services',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      if(_goodna == true){
                        _scan();
                      }else{

                      }

                    },
                    child: qrscan(),
                  ),

                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                 Text("Get Queue",style: TextStyle(color: _goodna ? Colors.green:Colors.black54),)
                ],
              ),

              SizedBox(height: 10,),


              Divider(),
              Text(AppVar.sclinicname,style: TextStyle(fontSize: 16),),
              Text(AppVar.sclinddes,style: TextStyle(fontSize: 12),),
              Text(AppVar.sclinictype,style: TextStyle(fontSize: 12),),
              Text(AppVar.sclinicslot,style: TextStyle(fontSize: 12),),
              Divider(),
              SizedBox(height: 5,),



              Text('Appointment',style: TextStyle(fontSize: 16),),
              SizedBox(height: 2,),

              Container(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                      visible: vis1,
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              caption: 'Cancel',
                              color: kColorBlue,
                              icon: Icons.delete_forever,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'Edt',
                              color: Colors.white,
                              icon: Icons.edit,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'View Details',
                              color: Colors.white,
                              icon: Icons.remove_red_eye,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'Confirm',
                              color: Colors.white,
                              icon: Icons.settings_overscan,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                        ],
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[

                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 25,
                                        backgroundImage: AssetImage('assets/images/icon_man.png'),
                                        //child: Image.network(snapshot.data[index].hosimage),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -1,
                                        child: Container(
                                          width: 20,

                                          child: CircleAvatar(
                                              backgroundColor: Colors.amber[800],
                                              child: Text("1", style: TextStyle(color: Colors.white, fontSize: 8),)

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Murphy Rodger',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Reason: New Concern',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Payment Status: Paid',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        v1 = "Now \n Serving";
                                      });
                                    },
                                    child: Container(
                                      width: 70,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Icon(Icons.view_compact_sharp,size: 30,),
                                          ),
                                          Text(v1, style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: vis2,
                      child: Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              caption: 'Cancel',
                              color: kColorBlue,
                              icon: Icons.delete_forever,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'Edt',
                              color: Colors.white,
                              icon: Icons.edit,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'View Details',
                              color: Colors.white,
                              icon: Icons.remove_red_eye,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                          IconSlideAction(
                              caption: 'Confirm',
                              color: Colors.white,
                              icon: Icons.settings_overscan,
                              onTap: (){

                                setState(() {

                                });

                              }
                          ),
                        ],
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0,0,0,0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 25,
                                        backgroundImage: AssetImage('assets/images/icon_doctor_4.png'),
                                        //child: Image.network(snapshot.data[index].hosimage),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -1,
                                        child: Container(
                                          width: 20,

                                          child: CircleAvatar(
                                              backgroundColor: Colors.amber[800],
                                              child: Text("2", style: TextStyle(color: Colors.white, fontSize: 8),)

                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Metz Marilou',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2
                                              .copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Reason: Second Opinion',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Payment Status: Paid',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      width: 70,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Icon(Icons.view_compact_sharp,size: 30,),
                                          ),
                                          Text(v2, style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'NunitoSans',
                                            fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      )

    );
  }


}
