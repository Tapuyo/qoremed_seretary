import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/pages/home/doctask/appfinish.dart';
import 'package:qoremed_app/pages/notifications/notdetails.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_button.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class AppTodayV extends StatefulWidget {
  String stat,questat;
  AppTodayV(this.stat,this.questat);
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState(this.stat,this.questat);
}


class _TimeSlotPageState extends State<AppTodayV> {
  String stat,questat;
  _TimeSlotPageState(this.stat,this.questat);
  String scancode = "";
  double prescon;
  double excon;
  int _test;

  bool scanbool;
  bool _goodna;
  bool _goodna1;

  final String serverToken = 'AAAAHneu0yg:APA91bH_NMmvgS0Z52XW4KQxAbgEwh0Hiv-TWV_NZM-fl3TyZtlROew3DEwx9UoRJwy9F6zVw9JsoJ1X-dMdP2WY546ZmUMC88gHmXdT3ekGqOgd2Vra3kWcVqI5eiL7RQ705ZNSeWrS';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();


  void sendAndRetrieveMessage(String stat,uid) async {
    String message = "Your appointment is now " + stat;
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
            'body': 'Your appointment is now ' + stat
          },
          /*'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },*/
          'to': uid,
        },
      ),
    );
    print(send);
    myown(stat);
  }
  void myown(String stat) async {
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
            'body': 'You just ' + stat + " an appointment"
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
  docinout(String stat)async{
    String vals;
    if(stat == "In"){
      vals = '1';
    }else{
      vals = '0';
    }
    print(stat + "|" + vals);
    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/periods/"+ AppVar.periodid +"/";
    Map<String, String> body = {
      'doctor_status': vals
    };


    final response = await http.patch(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      setState(() {
        _test = _test + 1;
      });
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }
    docisin(stat);
  }
  void docisin(String st) async {
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
            'body': 'Your Doctor ' + AppVar.userfullname + 'is now ' + st
          },
          /*'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },*/
          'to': AppVar.periodid,
        },
      ),
    );
    print(send);

  }

  queout(String stat)async{
    String vals;
    if(stat == "In"){
      vals = '1';
    }else{
      vals = '0';
    }
    print(stat + "|" + vals);
    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/periods/"+ AppVar.periodid +"/";
    Map<String, String> body = {
      'patient_queueing': vals
    };


    final response = await http.patch(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      setState(() {
        _test = _test + 1;
      });
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }
    docisin(stat);
  }
  void queisin(String st) async {
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
            'body': 'Queueing ' + AppVar.userfullname + 'is now ' + st
          },
          /*'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },*/
          'to': AppVar.periodid,
        },
      ),
    );
    print(send);

  }

  @override
  void initState() {
    super.initState();
    if(stat == "in"){
      setState(() {
        _goodna = true;
      });
    }else{
      setState(() {
        _goodna = false;
      });
    }
    if(questat == "on"){
      setState(() {
        _goodna1 = true;
      });
    }else{
      setState(() {
        _goodna1 = false;
      });
    }

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

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,reference,starttime,endtime,que,meet,uid,photo_url;
      bool pm;

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
      if(u['payment_status'] == null){
        pm = true;
      }else{
        pm = false;
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
      if(u['client']['photo_url'] == null){
        photo_url = "none";
      }else{
        photo_url = u['client']['photo_url'] ;
      }
      if(status == "serving") {
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
            meet,
            uid,
            photo_url,pm
        );

        appoint.add(apps);
      }

    }


    print(appoint.length.toString());
    return appoint;
  }

  Future<List<Appoint>> getSched() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments?period_id=" + AppVar.periodid;
    final response = await http.get(url,headers: headers);

    List<Appoint> appoint = [];
    var jsondata = json.decode(response.body);

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,reference,starttime,endtime,que,meet,uid,photo_url;
      bool pm;

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
      if(u['payment_status'] == null){
        pm = true;
      }else{
        pm = false;
      }

      if(u['end_time'] == null){
        endtime = "none";
      }else{
        endtime = u['end_time'];
      }
      if(u['client']['photo_url'] == null){
        photo_url = "none";
      }else{
        photo_url = u['client']['photo_url'] ;
      }
      //&& u['queue']['status'] != "completed"
      if(status == "pending" || status == "confirmed") {
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
            meet,
            uid,photo_url,pm
        );

        appoint.add(apps);
      }

    }


    print(appoint.length.toString());
    return appoint;
  }

  Future<List<AppointS>> getSchedPres() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments?period_id=" + AppVar.periodid;
    final response = await http.get(url,headers: headers);

    List<AppointS> appoint = [];
    var jsondata = json.decode(response.body);

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,reference,starttime,endtime,que,meet,uid,photo_url;
      bool pm;
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
      if(u['payment_status'] == null){
        pm = true;
      }else{
        pm = false;
      }

      if(u['end_time'] == null){
        endtime = "none";
      }else{
        endtime = u['end_time'];
      }
      if(u['client']['photo_url'] == null){
        photo_url = "none";
      }else{
        photo_url = u['client']['photo_url'] ;
      }
      if(status == "queued") {
        AppointS apps = AppointS(
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
            meet,uid,
            photo_url,
            pm
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
      setState(() {
        _test = _test + 1;
      });
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
    }
    getfcmuser(uid,stat);
  }
  getfcmuser(String uid,stat)async{

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/" + uid;
    final response = await http.get(url,headers: headers);
    print(response.body.toString());
    if(response.statusCode == 200){
      sendAndRetrieveMessage(stat,jsonDecode(response.body)['user']['fcm_token']);

    }

  }
  checkRef(String ref) async{
    showProgressDialog(context);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments?period_id=" + AppVar.periodid;
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body);

    print(jsondata.toString());

    for (var u in jsondata){
      String reference;

      if(u['reference_no'] == ref){

        if(u['status'] == "queued"){
          //updatestat(u['id'], "skip");
          print("Present na");
        }
        if(u['status'] == "pending"){
          Navigator.pop(context);
          yesnotconfirm(u['id'],u['client']['id']);
          print("yesnotconfirm");
          final snackBar = SnackBar(content: Text('Not Yet confirmed!'));
          Scaffold.of(context).showSnackBar(snackBar);
          Navigator.pop(context);
        }
        else {
          updatestat(u['id'], "queue",u['client']['id']);
          print("Yes meron");
        }

      }

    }
    Navigator.pop(context);
  }

  yesnotconfirm(String appid,uid) {
    Widget yesButton = FlatButton(
      child: Text("Yes"),
      onPressed:  () {
        updatestat(appid, "queue",uid);
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = FlatButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("QoreMed"),
      content: Text('This appointment not yet confirmed. Do you want to continue?'),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  postconfirm(){

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
  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    setState(() {
      scancode = barcode;
      checkRef(scancode);
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
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.library_add_check,
                //color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppFinish(),
                  ),
                );
              },
            )
          ],
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
                    if(_goodna == true) {
                      docinout("Out");
                    }else{
                      docinout("In");
                    }
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
                SwitchListTile(
                  value: _goodna1,
                  onChanged: (_) {
                    if(_goodna1 == true) {
                      queout("off");
                    }else{
                      queout("on");
                    }
                    setState(() {
                      _goodna1 = !_goodna1;
                    });
                  },

                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Patient Queuing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Start the queue',
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

                /*Row(
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
                ),*/

                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Virtual Consultation',style: TextStyle(fontSize: 20),),
                  ],
                ),

                Divider(),
                Text(AppVar.sclinicname,style: TextStyle(fontSize: 16),),
                Text(AppVar.sclinddes,style: TextStyle(fontSize: 12),),
                Text(AppVar.sclinictype,style: TextStyle(fontSize: 12),),
                Text(AppVar.sclinicslot,style: TextStyle(fontSize: 12),),
                Divider(),
                SizedBox(height: 5,),



                Text('Appointment',style: TextStyle(fontSize: 16),),
                SizedBox(height: 2,),
                Text('Serving',style: TextStyle(fontSize: 16),),
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
                                    /*  IconSlideAction(
                                        caption: 'Cancel',
                                        color: kColorBlue,
                                        icon: Icons.delete_forever,
                                        onTap: (){

                                          setState(() {

                                          });

                                        }
                                    ),*/
                                    /*  IconSlideAction(
                                        caption: 'Edt',
                                        color: Colors.white,
                                        icon: Icons.edit,
                                        onTap: (){

                                          setState(() {

                                          });

                                        }
                                    ),*/
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
                                                  child: Image.network(snapshot.data[index].photo_url),
                                                ),
                                                Positioned(
                                                  top: -10,
                                                  right: -1,
                                                  child: Container(
                                                    width: 20,

                                                    child: CircleAvatar(
                                                      backgroundColor: Colors.green[800],

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
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Start Time: ' + snapshot.data[index].starttime,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                  Text(
                                                    'End Time: ' + snapshot.data[index].endtime,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            mystatst(snapshot.data[index].appid,snapshot.data[index].status,snapshot.data[index].uid),

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
                Text('Present',style: TextStyle(fontSize: 16),),
                Container(

                  child: FutureBuilder(
                      future: getSchedPres(),
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
                                        caption: 'Cancel',
                                        color: kColorBlue,
                                        icon: Icons.delete_forever,
                                        onTap: (){

                                          setState(() {

                                          });

                                        }
                                    ),
                                    IconSlideAction(
                                        caption: 'Edit',
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
                                    IconSlideAction(
                                        caption: 'Skip',
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
                                                  child: Image.network(snapshot.data[index].photo_url),
                                                ),
                                                Positioned(
                                                  top: -10,
                                                  right: -1,
                                                  child: Container(
                                                    width: 20,

                                                    child: CircleAvatar(
                                                        backgroundColor: Colors.amber[800],
                                                        child: Text(snapshot.data[index].que, style: TextStyle(color: Colors.white, fontSize: 8),)

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
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Start Time: ' + snapshot.data[index].starttime,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                  Text(
                                                    'End Time: ' + snapshot.data[index].endtime,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily: 'NunitoSans',
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            mystatque(snapshot.data[index].appid,snapshot.data[index].status,snapshot.data[index].meet,snapshot.data[index].uid),

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
                Divider(),
                SizedBox(height: 2,),
                Text('Expected',style: TextStyle(fontSize: 16),),
                Container(

                  child: FutureBuilder(
                      future: getSched(),
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
                                        caption: 'Cancel',
                                        color: kColorBlue,
                                        icon: Icons.delete_forever,
                                        onTap: (){

                                          setState(() {
                                            updatestat(snapshot.data[index].appid, "cancel",snapshot.data[index].uid);
                                          });

                                        }
                                    ),
                                    IconSlideAction(
                                        caption: 'Edit',
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
                                                  child: Image.network(snapshot.data[index].photo_url),
                                                ),
                                                /*Positioned(
                                          top: -10,
                                          right: -1,
                                          child: Container(
                                            width: 20,

                                            child: CircleAvatar(
                                                backgroundColor: Colors.amber[800],
                                                child: Text("1", style: TextStyle(color: Colors.white, fontSize: 8),)

                                            ),
                                          ),
                                        ),*/
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
                                            mystat(snapshot.data[index].appid,snapshot.data[index].status,snapshot.data[index].uid),

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
  mystat(String appid,stat,uid){
    if(stat == "confirmed"){
      return GestureDetector(
        onTap: (){
          if(_goodna == true) {
            updatestat(appid, "queue", uid);
          }
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
              Text('Queue', style: TextStyle(
                fontSize: 12,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }else{
      return GestureDetector(
        onTap: (){
          if(_goodna == true) {
            updatestat(appid, "confirm",uid);
          }
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
              Text("Confirm", style: TextStyle(
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
  meetserve(String url)async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // iOS
      const uri = 'sms:';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }
  }
  mystatque(String appid,stat,meet,uid){

    if(stat == "queued"){
      return GestureDetector(
        onTap: (){
          if(_goodna == true) {
            updatestat(appid, "serve",uid);
            meetserve(meet);}
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
              Text('Serve', style: TextStyle(
                fontSize: 12,
                fontFamily: 'NunitoSans',
                fontWeight: FontWeight.w300,), textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    }else{
      return GestureDetector(
        onTap: (){
          if(_goodna == true) {
            updatestat(appid, "confirm", uid);
          }
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
              Text(stat, style: TextStyle(
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
  mystatst(String appid,stat,uid) {

    if (stat == "serving") {
      return GestureDetector(
        onTap: () {
          if(_goodna == true) {
            updatestat(appid, "complete", uid);
          }
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
              Text('Completed', style: TextStyle(
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
  final String uid;
  final String photo_url;
  final bool pym;


  Appoint(this.appid, this.docname, this.appdate,this.docimg,this.special,this.hospital,this.name,this.status,this.consult,this.ref,
      this.starttime,this.endtime,this.que, this.meet,this.uid,this.photo_url,this.pym);
}


class AppointS{
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
  final String uid;
  final String photo_url;
  final bool pym;

  AppointS(this.appid, this.docname, this.appdate,this.docimg,this.special,this.hospital,this.name,this.status,this.consult,this.ref,
      this.starttime,this.endtime,this.que, this.meet,this.uid,this.photo_url,this.pym);
}