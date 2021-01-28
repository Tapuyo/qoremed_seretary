import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/pages/notifications/notdetails.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import '../../../routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AppFinish extends StatefulWidget {

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<AppFinish> {
  String scancode = "";
  double prescon;
  double excon;

  int _test;

  bool scanbool;
  bool _goodna;

  final String serverToken = 'AAAAHneu0yg:APA91bH_NMmvgS0Z52XW4KQxAbgEwh0Hiv-TWV_NZM-fl3TyZtlROew3DEwx9UoRJwy9F6zVw9JsoJ1X-dMdP2WY546ZmUMC88gHmXdT3ekGqOgd2Vra3kWcVqI5eiL7RQ705ZNSeWrS';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  void sendAndRetrieveMessage(String toks) async {
    var send = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Appointment',
            'body': 'Your appointment from Dr.' + AppVar.userfullname + 'is now paid.'
          },
          /*'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },*/
          'to': toks,
        },
      ),
    );
    print(send);
    myown();
  }
  void myown() async {
    var send = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': 'Appointment',
            'body': 'You just paid an appointment'
          },
          /*'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },*/
          'to': AppVar.ufcm,
        },
      ),
    );
    print(send);

  }



  @override
  void initState() {
    super.initState();
    _goodna = false;
    _test = 0;

  }
  Future<List<Appoint>> getSchedServe() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments?period_id=" + AppVar.periodid;
    final response = await http.get(url,headers: headers);

    List<Appoint> appoint = [];
    var jsondata = json.decode(response.body);

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,reference,starttime,endtime,que,meet,payment,uid;
      if(u['client']['id'].toString() == null){
        uid = "";
      }else{
        uid = u['client']['id'].toString();
      }

      if(u['id'].toString() == null){
        appid = "none";
      }else{
        appid = u['id'].toString();
      }
      if(u['payment_status'].toString() == null){
        payment = "Unpaid";
      }else{
        payment = u['payment_status'].toString();
      }
      if(u['appointable']['doctor']['profile']['full_name'] == null){
        docname = "none";
      }else{
        docname = u['appointable']['doctor']['profile']['full_name'] ;
      }
      if(u['appointable']['doctor']['google_meet'] == null){
        meet = "";
      }else{
        meet = u['appointable']['doctor']['google_meet'];
      }
      if(u['date'] == null){
        appdate = "none";
      }else{
        appdate = u['date'];
      }
      if(u['appointable']['doctor']['photo_url'] == null){
        docimg = "none";
      }else{
        docimg = u['appointable']['doctor']['photo_url'];
      }
      if(u['appointable']['doctor']['doctor_type']['name'] == null){
        special = "none";
      }else{
        special = u['appointable']['doctor']['doctor_type']['name'];
      }

      if(u['appointable']['name'] == null){
        hostpital = "none";
      }else{
        hostpital = u['appointable']['name'];
      }
      if(u['client']['profile']['full_name'] == null){
        name = "none";
      }else{
        name = u['client']['profile']['full_name'];
      }

      if(u['status'] == null){
        status = "none";
      }else{
        status = u['status'];
      }
      if(u['period']['consultation_type']['name'] == null){
        consult = "none";
      }else{
        consult = u['period']['consultation_type']['name'];
      }

      if(u['reference_no'] == null){
        reference = "none";
      }else{
        reference = u['reference_no'];
      }

      if(status == "queued"){
        if(u['queue']['start_time'] == null){
          starttime = "none";
        }else{
          starttime = u['queue']['start_time'];
        }
        if(u['queue']['number'] == null){
          que = "none";
        }else{
          que = u['queue']['number'];
        }
      }else{
        if(u['start_time'] == null){
          starttime = "none";
        }else{
          starttime = u['start_time'];
        }
        que = "none";
      }


      if(u['end_time'] == null){
        endtime = "none";
      }else{
        endtime = u['end_time'];
      }

      if(status == "completed" && payment == "Paid" ) {
        Appoint apps = Appoint(
            appid,
            docname,
            appdate,
            docimg,
            special,
            hostpital,
            name,
            status,
            consult,
            reference,
            starttime,
            endtime,
            que,
            meet,payment,uid
        );

        appoint.add(apps);
      }

    }


    print(appoint.length.toString());
    return appoint;
  }
  Future<List<Appointu>> getSchedServeu() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments?period_id=" + AppVar.periodid;
    final response = await http.get(url,headers: headers);

    List<Appointu> appoint = [];
    var jsondata = json.decode(response.body);

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,reference,starttime,endtime,que,meet,payment,uid;
      if(u['client']['id'].toString() == null){
        uid = "";
      }else{
        uid = u['client']['id'].toString();
      }

      if(u['id'].toString() == null){
        appid = "none";
      }else{
        appid = u['id'].toString();
      }
      if(u['payment_status'].toString() == null){
        payment = "Unpaid";
      }else{
        payment = u['payment_status'].toString();
      }
      if(u['appointable']['doctor']['profile']['full_name'] == null){
        docname = "none";
      }else{
        docname = u['appointable']['doctor']['profile']['full_name'] ;
      }
      if(u['appointable']['doctor']['google_meet'] == null){
        meet = "";
      }else{
        meet = u['appointable']['doctor']['google_meet'];
      }
      if(u['date'] == null){
        appdate = "none";
      }else{
        appdate = u['date'];
      }
      if(u['appointable']['doctor']['photo_url'] == null){
        docimg = "none";
      }else{
        docimg = u['appointable']['doctor']['photo_url'];
      }
      if(u['appointable']['doctor']['doctor_type']['name'] == null){
        special = "none";
      }else{
        special = u['appointable']['doctor']['doctor_type']['name'];
      }

      if(u['appointable']['name'] == null){
        hostpital = "none";
      }else{
        hostpital = u['appointable']['name'];
      }
      if(u['client']['profile']['full_name'] == null){
        name = "none";
      }else{
        name = u['client']['profile']['full_name'];
      }

      if(u['status'] == null){
        status = "none";
      }else{
        status = u['status'];
      }
      if(u['period']['consultation_type']['name'] == null){
        consult = "none";
      }else{
        consult = u['period']['consultation_type']['name'];
      }

      if(u['reference_no'] == null){
        reference = "none";
      }else{
        reference = u['reference_no'];
      }

      if(status == "queued"){
        if(u['queue']['start_time'] == null){
          starttime = "none";
        }else{
          starttime = u['queue']['start_time'];
        }
        if(u['queue']['number'] == null){
          que = "none";
        }else{
          que = u['queue']['number'];
        }
      }else{
        if(u['start_time'] == null){
          starttime = "none";
        }else{
          starttime = u['start_time'];
        }
        que = "none";
      }


      if(u['end_time'] == null){
        endtime = "none";
      }else{
        endtime = u['end_time'];
      }

      if(status == "Unpaid" || payment == "Unpaid" && status != "queued" && status != "serving") {
        Appointu apps = Appointu(
            appid,
            docname,
            appdate,
            docimg,
            special,
            hostpital,
            name,
            status,
            consult,
            reference,
            starttime,
            endtime,
            que,
            meet,payment,uid
        );

        appoint.add(apps);
      }

    }


    print(appoint.length.toString());
    return appoint;
  }




  updatestat(String appid,stat,uid)async{

    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/appointments/"+ appid +"/"+stat;

    final response = await http.post(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }
    getfcmuser(uid);
  }
  getfcmuser(String uid)async{

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/" + uid;
    final response = await http.get(url,headers: headers);
    print(response.body.toString());
    if(response.statusCode == 200){
      sendAndRetrieveMessage(jsonDecode(response.body)['user']['fcm_token']);

    }

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
                        "Checking Appointment",
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

  @override
  void dispose() {

    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Complete Appointment'),

        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(AppVar.sclinicname,style: TextStyle(fontSize: 16),),
                Text(AppVar.sclinddes,style: TextStyle(fontSize: 12),),
                Text(AppVar.sclinictype,style: TextStyle(fontSize: 12),),
                Text(AppVar.sclinicslot,style: TextStyle(fontSize: 12),),
                Divider(),
                SizedBox(height: 5,),



                Text('Complete Appointments',style: TextStyle(fontSize: 16),),
                SizedBox(height: 2,),
                Text('Paid',style: TextStyle(fontSize: 16),),
                Container(

                  child: FutureBuilder(
                      future: getSchedServe(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text("Loading"),
                                ),
                                Container(
                                  height: 10,
                                ),
                                CircularProgressIndicator()
                              ],
                            ),
                          );
                        }else{
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(

                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[


                                    IconSlideAction(
                                        caption: 'View Details',
                                        color: Colors.white,
                                        icon: Icons.remove_red_eye,
                                        onTap: (){

                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => NotDetails(snapshot.data[index].appid),
                                              ),
                                            );
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
                                                    snapshot.data[index].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(fontWeight: FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Reason: ' + snapshot.data[index].consult,
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
                                                    'Payment Status: Complete',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }


                      }
                  ),
                ),
                SizedBox(height: 2,),
                Text('Unpaid',style: TextStyle(fontSize: 16),),
                Container(

                  child: FutureBuilder(
                      future: getSchedServeu(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Text("Loading"),
                                ),
                                Container(
                                  height: 10,
                                ),
                                CircularProgressIndicator()
                              ],
                            ),
                          );
                        }else{
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(

                                child: Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.25,
                                  secondaryActions: <Widget>[

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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => NotDetails(snapshot.data[index].appid),
                                              ),
                                            );
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
                                                    snapshot.data[index].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(fontWeight: FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    'Reason: ' + snapshot.data[index].consult,
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
                                                    'Payment Status: ' + snapshot.data[index].status,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            mystatst(snapshot.data[index].appid,snapshot.data[index].status,snapshot.data[index].payment,snapshot.data[index].uid),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }


                      }
                  ),
                ),

              ],
            ),
          ),
        )

    );
  }


  mystatst(String appid,stat,payment,uid) {
    if (payment == "Unpaid") {
      return GestureDetector(
        onTap: () {
          updatestat(appid, "paid",uid);
        },
        child: Container(
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Icon(Icons.view_compact_sharp, size: 30,),
              ),
              Text('Pay', style: TextStyle(
                fontSize: 12,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
    if (payment == "Paid") {
      return GestureDetector(
        onTap: () {
          //updatestat(appid, "paid");
        },
        child: Container(
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Icon(Icons.view_compact_sharp, size: 30,),
              ),
              Text('Paid', style: TextStyle(
                fontSize: 12,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }
  }

}

class Appoint{
  final String appid;
  final String docname;
  final String appdate;
  final String docimg;
  final String special;
  final String hospital;
  final String name;
  final String status;
  final String consult;
  final String ref;
  final String starttime;
  final String endtime;
  final String que;
  final String meet;
  final String payment;
  final String uid;


  Appoint(this.appid, this.docname, this.appdate,this.docimg,this.special,this.hospital,this.name,this.status,this.consult,this.ref,
      this.starttime,this.endtime,this.que, this.meet,this.payment,this.uid);
}

class Appointu{
  final String appid;
  final String docname;
  final String appdate;
  final String docimg;
  final String special;
  final String hospital;
  final String name;
  final String status;
  final String consult;
  final String ref;
  final String starttime;
  final String endtime;
  final String que;
  final String meet;
  final String payment;
  final String uid;

  Appointu(this.appid, this.docname, this.appdate,this.docimg,this.special,this.hospital,this.name,this.status,this.consult,this.ref,
      this.starttime,this.endtime,this.que, this.meet,this.payment,this.uid);
}