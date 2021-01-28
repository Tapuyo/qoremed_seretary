import 'package:flutter_html/flutter_html.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:qoremed_app/components/custom_button.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/pages/clinics/cliniclist.dart';
import 'package:qoremed_app/pages/doctor/my_doctor_list_page.dart';
import 'package:qoremed_app/pages/home/doctask/sched.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:qoremed_app/utils/constants.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../../components/round_icon_button.dart';
import 'package:qoremed_app/data/database_user.dart';
import 'package:qoremed_app/data/database_nxt.dart';
import 'widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';
import 'package:qoremed_app/pages/appointment/appointment_detail_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qoremed_app/pages/patient/patientprofile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  final bool _noAppoints = false;
  final dbHelper = DatabaseHelper.instance;
  final dbHelper1 = DatabaseHelper1.instance;

  bool visible = false ;
  bool visible1 = false ;
  bool visible2 = false ;
  List mylist =  [];
  double numnotice = 0;

  String nxtdt = "";
  String nxtdoc = "";
  String nxttime = "";
  String nxtdocsp = "";
  String nxtdocimg = "";
  String nxtid = "";
  String nxthospital = "";
  String nxtname = "";
  String nxtstatus = "";
  String nxtconsult = "";
  String nxtref = "";
  String que = "";
  String nxtmeet = "";

  int notif = 0;


  String starttime = "";
  String nxtendt = "";

  Future<List> _future;
  Future<List> _note;

  DateTime datenow;
  int yr;



  @override
  void initState() {
    datenow = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    yr = datenow.year % 100;
    super.initState();
    if(AppVar.online == true){
      _delete();
      _note = getNote();
      getuser();
      getnxtsched();

    }else{
      _query();
    }
    notif = 0;
    getNotif();
    print("firebase init 0000000000000000000000000000000000000000000000000000000000000000000000000000000");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final mynotif = message['notification'];
        String mtitle = mynotif['title'];
        String mbody = mynotif['body'];
        shownotif(mtitle,mbody);
        /*     if(mbody == "New Appointment book"){

        }else{

        }*/
        final getbody = message['data'];
        String bods = getbody['body'];
        print("onMessage: $bods");

        final notification = message['notification'];
        setState(() {
          messages.add(Message(
              title: notification['title'], body: notification['body']));
        });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        final notification = message['data'];
        setState(() {
          messages.add(Message(
            title: '${notification['title']}',
            body: '${notification['body']}',
          ));
        });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    fcmtoken();

    fcmSubscribe();
  }

  shownotif(String title,body){

    showOverlayNotification((context) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: SafeArea(
          child: ListTile(
            leading: SizedBox.fromSize(
                size: const Size(40, 40),
                child: ClipOval(
                    child: Container(
                      color: Colors.white,
                    ))),
            title: Text(title),
            subtitle: Text(body),
            trailing: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  OverlaySupportEntry.of(context).dismiss();
                }),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 4000));
  }

  void fcmSubscribe() {
    _firebaseMessaging.subscribeToTopic('TopicToListen');
  }

  void fcmtoken()async{
    String fcmtoken = await _firebaseMessaging.getToken();
    print("Your firebase token is: "+ fcmtoken);
    AppVar.ufcm = fcmtoken;

    Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/user/";
    Map<String, String> body = {
      "fcm_token": fcmtoken,
    }; //
    final response = await http.patch(url,headers: headers, body: body);
    print(response.body.toString());
    if(response.statusCode == 200){
      print('FCM token has been updated' + response.body.toString());
    }else{
      print('FCM token not yet updated' + response.body.toString());
    }
  }

  void _delete() async {
    // Assuming that the number of rows is the id for the last row.
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
    //_query();
  }

  void _insert(String name,pass,one,aut,email,drive,exp) async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnName : name,//username
      DatabaseHelper.columnPass  : pass,//user password
      DatabaseHelper.columnOne  : one,//user id
      DatabaseHelper.columnAuth  : aut + " ",//user first name
      DatabaseHelper.columnEmail  : email + " ",//user middle name
      DatabaseHelper.columnDrive  : drive + " ",// user last name
      DatabaseHelper.columnExp  : exp + " ",//user unknown pa
    };
    final id = await dbHelper.insert(row);

    print('inserted row id: $id');

  }


  rfr(){
    print('refresh');
    getuser();
    getnxtsched();
    setState(() {
      _note = getNote();
    });
   /* Navigator.pushReplacement(context,
        MaterialPageRoute(
            builder: (BuildContext context) => super.widget));*/
  }


  getNotif() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/notifications/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    int ne = 0;
    for (var u in jsondata){
      if(u['read_at']== null){
        if(u['created_at'] != null){
          DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(u['created_at']);
          DateTime dtnow = new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
          print("Date from notification"+ tempDate.toString());
          print("Date from now"+dtnow.toString());
          if(tempDate == dtnow){

            ne = ne + 1;

          }
        }
      }

    }
    setState(() {
      notif = ne;
    });

  }


  getuser()async{

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/user/";
    final response = await http.get(url,headers: headers);
    print(response.body.toString());
    if(response.statusCode == 200){
     setState(() {

       AppVar.userfullname = json.decode(response.body)['first_name'].toString() + " " + json.decode(response.body)['last_name'].toString();
       if(json.decode(response.body)['userable_id'] == null){
         AppVar.did = "";
       }else{
         AppVar.did = json.decode(response.body)['userable_id'].toString();
       }
       if(json.decode(response.body)['first_name'] == null){
         AppVar.fname = "none";
       }else{
         AppVar.fname = json.decode(response.body)['first_name'].toString();
       }
       if(jsonDecode(response.body)['photo_url'] == null){
         AppVar.photo = "";
       }else{
         AppVar.photo = jsonDecode(response.body)['photo_url'].toString();
       }
      if(jsonDecode(response.body)['userable_id'] == null){
        AppVar.userid = "none";
      }else{
        AppVar.userid = jsonDecode(response.body)['userable_id'].toString();
      }
       if(jsonDecode(response.body)['email'] == null){
         AppVar.useremail =  "none";
       }else{
         AppVar.useremail =  jsonDecode(response.body)['email'].toString();
       }
       if(jsonDecode(response.body)['userable']['profile']['gender'] == null){
         AppVar.ugender = "none";
       }else{
         AppVar.ugender = jsonDecode(response.body)['userable']['profile']['gender'].toString();
       }
       if(jsonDecode(response.body)['userable']['profile']['birthday'] == null){
         AppVar.ubdate = "none";
       }else{
         AppVar.ubdate = jsonDecode(response.body)['userable']['profile']['birthday'].toString();
       }
       if( jsonDecode(response.body)['userable']['profile']['blood_type_id'] == null){
         AppVar.ublood = "none";
       }else{
         AppVar.ublood = jsonDecode(response.body)['userable']['profile']['blood_type_id'].toString();
       }
       if(jsonDecode(response.body)['userable']['profile']['civil_status_id'] == null){
         AppVar.ustatus = "none";
       }else{
         AppVar.ustatus = jsonDecode(response.body)['userable']['profile']['civil_status_id'].toString();
       }
       if(jsonDecode(response.body)['mobile'] == null){
         AppVar.ucontact = "none";
       }else{
         AppVar.ucontact = jsonDecode(response.body)['mobile'].toString();
       }
       if(jsonDecode(response.body)['userable']['address']['full_address'] == null){
         AppVar.uaddress = "none";
       }else{
         AppVar.uaddress = jsonDecode(response.body)['userable']['address']['full_address'].toString();
       }

       AppVar.uheight = "none";
       AppVar.uweight = "none";

       _insert(AppVar.useremail,AppVar.upass,AppVar.userid,json.decode(response.body)['first_name'].toString(),"none",json.decode(response.body)['last_name'].toString(),"none");
       print("My fullname" + AppVar.userfullname);
     });

    }/*else{
     setState(() {
       AppVar.userfullname = "";
       AppVar.fname = "";
       AppVar.photo = "";
       AppVar.userid = "";
     });
    }*/


  }

  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);


    setState(() {

    });
  }


  qrshow() {
    print(AppVar.nxtref);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Center(child: Text('Scan QR',style: TextStyle(fontSize:25),),),
              content: Container(
                height: 250,
                child: Column(
                    children: <Widget>[
                      Flexible(
                        child: Container(

                          child:  QrImage(
                            foregroundColor: kColorBlue,
                            data: AppVar.nxtref,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),


                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        width: MediaQuery.of(context).size.width - 100,
                        child: FlatButton(

                          color: kColorBlue,
                          child: new Text('OK', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        ),
                      )
                    ]
                ),
              )
          );
        }
    );

  }

  void _insertnxt() async {
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper1.nxtdt : nxtdt,//username
      DatabaseHelper1.nxtdoc  : nxtdoc,//user password
      DatabaseHelper1.nxttime  : nxttime,//user id
      DatabaseHelper1.nxtdocimg  : nxtendt,//user first name
      DatabaseHelper1.nxtid  : nxtid,//user middle name
      DatabaseHelper1.nxthospital  : nxthospital,// user last nameasd
      DatabaseHelper1.nxtdocsp  : nxtdocsp,//user unknown pa
      DatabaseHelper1.nxtname  : AppVar.userfullname,//user id
      DatabaseHelper1.nxtstatus  : nxtstatus,//user first name
      DatabaseHelper1.nxtref  : nxtref,//user middle name
      DatabaseHelper1.que  : que,// user last name
      DatabaseHelper1.consult : nxtconsult,
      DatabaseHelper1.starttime  : starttime,//user unknown pa
    };
    final id = await dbHelper1.insert(row);

    print('inserted row id: $id');
    _query();
  }


  void _deletenxt() async {

    final id = await dbHelper1.queryRowCount();
    final rowsDeleted = await dbHelper1.delete(id);
    print('deleted $rowsDeleted row(s): row $id');

  }

  void _query() async {
    final allRows = await dbHelper1.queryAllRows();
    print('query all rows:');

    if(allRows.length == 0){
      print("awallalasldlasdklaskdlaksdlkqwlkalkdlasklkalskdlsakdlaksldkasd");
    }else {
      print(allRows[0]['_id']);
      print(allRows[0]['nxtdt']);
      print(allRows[0]['nxtdoc']);
      print(allRows[0]['nxttime']);
      print(allRows[0]['nxtdocimg']);
      print(allRows[0]['nxtid']);
      print(allRows[0]['nxthospital']);
      print(allRows[0]['nxtdocsp']);
      print(allRows[0]['nxtname']);
      print(allRows[0]['nxtstatus']);
      print(allRows[0]['nxtref']);
      print(allRows[0]['que']);
      print(allRows[0]['starttime']);

     setState(() {
       nxtdt = allRows[0]['nxtdt'];
       nxttime = allRows[0]['nxttime'];
       nxtendt = allRows[0]['nxtdocimg'];
       nxtdoc = allRows[0]['nxtdoc'];
       nxtdocimg = allRows[0]['nxtdocimg'];
       nxtid = allRows[0]['nxtid'];
       nxthospital =allRows[0]['nxthospital'];
       nxtdocsp = allRows[0]['nxtdocsp'];
       nxtname = allRows[0]['nxtname'];
       nxtstatus = allRows[0]['nxtstatus'];
       nxtconsult = allRows[0]['consult'];
       nxtref = allRows[0]['nxtref'];
       if(nxtstatus == "queued"){
         que = allRows[0]['que'];
         starttime = allRows[0]['starttime'];
       }else{
         que = "none";
         starttime = "none";
       }

     });
    }
  }


  getnxtsched() async{
    _deletenxt();
    setState(() {
      mylist.clear();
      visible1 = false;
      nxtdt =  "none";
      nxtdoc = "none";
      nxttime = "none";
      nxtdocimg = "none";
      nxtid = "none";
      nxthospital = "none";
      nxtdocsp =  "none";
      nxtname =  "none";
      nxtstatus =  "none";
      nxtref = "none";
      que = "none";
      starttime = "none";
    });
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments/upcoming/";
    final response = await http.get(url,headers: headers);

    var tagObjsJson = jsonDecode(response.body)['data'] as List;
    print("Appointment List" + jsonDecode(response.body)['data'].toString());

    if(tagObjsJson.length > 0){
      for (var u in tagObjsJson){
        if(u['status'] != "cancelled")
        {
          setState(() {
            mylist = tagObjsJson;
          });
        }
      }



      if(mylist.length > 0){

        setState(() {
          visible1 = true;

          for(int i = 0; i < mylist.length; i++) {
            nxtdt = mylist[0]['date'];
            nxttime = mylist[0]['start_time'];
            nxtendt = mylist[0]['end_time'];
            nxtdoc = mylist[0]['appointable']['doctor']['profile']['full_name'];
            nxtdocimg = mylist[0]['appointable']['doctor']['photo_url'];
            nxtid = mylist[0]['id'].toString();
            nxthospital = mylist[0]['appointable']['name'];
            if(mylist[0]['appointable']['doctor']['doctor_type']['name'] == null){
              nxtdocsp = "none";
            }else {
              nxtdocsp =
              mylist[0]['appointable']['doctor']['doctor_type']['name'];
            }
            nxtname = mylist[0]['client']['profile']['full_name'];
            nxtstatus = mylist[0]['status'];
            nxtconsult = mylist[0]['period']['consultation_type']['name'];
            nxtref = mylist[0]['reference_no'].toString();
            nxtmeet = mylist[0]['appointable']['doctor']['google_meet'];

            if(nxtstatus == "queued"){
              que = mylist[0]['queue']['number'].toString();
              starttime = mylist[0]['queue']['start_time'].toString();
            }else{
              que = "none";
              starttime = "none";
            }

          }

        });
        _insertnxt();
      }else
      {
        setState(() {
          visible1 = false;
          nxtdt =  "none";
          nxttime = "none";
          nxttime = "none";
          nxtdoc = "none";
          nxtdocimg = "none";
          nxtid = "none";
          nxthospital = "none";
          nxtdocsp =  "none";
          nxtname =  "none";
          nxtstatus =  "none";
        });

      }
    }



  }


  mynxtdocimg(){
    if(nxtdocimg == ""){
      return Container(
        width: 56,
        height: 56,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/images/icon_doctor_1.png',
            fit: BoxFit.fill,
          ),
        ),
      );
    }else {
      return Container(
        width: 56,
        height: 56,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
          child: Image.network(nxtdocimg),
        ),
      );
    }

  }
  mynxtdocimgoff(){

      return Container(
        width: 56,
        height: 56,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/images/icon_doctor_1.png',
            fit: BoxFit.fill,
          ),
        ),
      );

  }


  mynxtdt(){
   if(nxtdt != ""){
     DateTime ststart =  DateFormat("yyyy-MM-dd").parse(nxtdt);
     int dtmo = ststart.month;
     String mo = "";
     if(dtmo == 1){
       mo = "January";
     }
     if(dtmo == 2){
       mo = "February";
     }
     if(dtmo == 3){
       mo = "March";
     }
     if(dtmo == 4){
       mo = "April";
     }
     if(dtmo == 5){
       mo = "May";
     }
     if(dtmo == 6){
       mo = "June";
     }
     if(dtmo == 7){
       mo = "July";
     }
     if(dtmo == 8){
       mo = "August";
     }
     if(dtmo == 9){
       mo = "September";
     }
     if(dtmo == 10){
       mo = "October";
     }
     if(dtmo == 11){
       mo = "November";
     }
     if(dtmo == 12){
       mo = "December";
     }

     String comdt = ststart.day.toString() + " " + mo.toString() + " " + ststart.year.toString();
     return Text(
       //'28 August 2020, 8:00 AM',
       comdt.toString(),
       style: TextStyle(
         color: Colors.white,
         fontSize: 14,
         fontWeight: FontWeight.w300,
       ),
     );
   }
  }

  myqr(){
   if(nxtconsult == "Virtual Consultation"){
     if(nxtstatus == "unpaid"){
       return GestureDetector(
         onTap: (){
           showmeet(context);
         },
         child: Container(
           child: Container(

               child: Column(
                 children: <Widget>[
                   Text("You are unpaid", style: TextStyle(color: Colors.white, fontSize: 12),),
                   Text("Please pay", style: TextStyle(color: Colors.white),),

                 ],
               )

           ),
         ),
       );
     }
     if(nxtstatus == "completed"){
       return GestureDetector(
         onTap: (){
           showmeet(context);
         },
         child: Container(
           child: Container(

               child: Column(
                 children: <Widget>[
                   Text("You are now done", style: TextStyle(color: Colors.white, fontSize: 12),),
                   Text("Done Appointment", style: TextStyle(color: Colors.white),),

                 ],
               )

           ),
         ),
       );
     }
     if(nxtstatus == "serving"){
       return Container(
         child: Container(

             child: Column(
               children: <Widget>[
                 Text("You are now serving", style: TextStyle(color: Colors.white, fontSize: 12),),
                 Text("Serving", style: TextStyle(color: Colors.white),),

               ],
             )

         ),
       );
     }
     if(nxtstatus == "queued"){
       DateTime dtnow = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
       DateTime dtme = DateFormat("yyyy-MM-dd hh:mm:ss").parse(nxtdt + " " + starttime);
       print(dtme.toString());
       final days = dtme.difference(dtnow).inDays;
       final dy = dtme.difference(dtnow);
       if(days > 0){
         return GestureDetector(
           onTap: (){
             showmeet(context);
           },
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[

               Text("Queue Number", style: TextStyle(color: Colors.white, fontSize: 12),),
               Text(que, style: TextStyle(color: Colors.white),),
               Divider(),
               Text(days.toString() + " Day(s) to go", style: TextStyle(fontSize: 12, color: Colors.white),),
             ],
           ),
         );
       }else{
         return GestureDetector(
           onTap: (){
             showmeet(context);
           },
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[

               Text("Queue Number", style: TextStyle(color: Colors.white, fontSize: 12),),
               Text(que, style: TextStyle(color: Colors.white),),
               Divider(),
               Text(dy.toString().split('.')[0], style: TextStyle(fontSize: 12, color: Colors.white),),
             ],
           ),
         );

       }


     }
     if(nxtstatus == "pending"){
       return FlatButton(

         color: Colors.white70,
         child: new Text('Get Queue', style: TextStyle(color: kColorBlue, fontSize: 12, fontWeight: FontWeight.bold),),
         onPressed: (){
           //showmeet(context);
         },
         shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
       );
     }
     if(nxtstatus == "confirmed"){
       return FlatButton(

         color: Colors.white70,
         child: new Text('Im here', style: TextStyle(color: kColorBlue, fontSize: 12, fontWeight: FontWeight.bold),),
         onPressed: (){
           showmeet(context);
         },
         shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
       );
     }

   }
   if(nxtconsult == "On-Site Consultation"){
     if(nxtstatus == "unpaid"){
       return Container(
         child: Container(

             child: Column(
               children: <Widget>[
                 Text("You are unpaid", style: TextStyle(color: Colors.white, fontSize: 12),),
                 Text("Please pay", style: TextStyle(color: Colors.white),),

               ],
             )

         ),
       );
     }
     if(nxtstatus == "completed"){
       return Container(
         child: Container(

             child: Column(
               children: <Widget>[
                 Text("You are now done", style: TextStyle(color: Colors.white, fontSize: 12),),
                 Text("Done Appointment", style: TextStyle(color: Colors.white),),

               ],
             )

         ),
       );
     }
     if(nxtstatus == "serving"){
       return Container(
         child: Container(

             child: Column(
               children: <Widget>[
                 Text("You are now serving", style: TextStyle(color: Colors.white, fontSize: 12),),
                 Text("Serving", style: TextStyle(color: Colors.white),),

               ],
             )

         ),
       );
     }
     if(nxtstatus == "queued"){
       DateTime dtnow = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
       DateTime dtme = DateFormat("yyyy-MM-dd hh:mm:ss").parse(nxtdt + " " + starttime);
       final days = dtme.difference(dtnow).inDays;
       final dy = dtme.difference(dtnow);
       if(days > 0){
         return Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[

             Text("Queue Number", style: TextStyle(color: Colors.white, fontSize: 12),),
             Text(que, style: TextStyle(color: Colors.white),),
             Divider(),
             Text(days.toString() + " Day(s) to go", style: TextStyle(fontSize: 12, color: Colors.white),),
            // Text(nxtdt + ": " + starttime, style: TextStyle(color: Colors.white),),
           ],
         );
       }else{
         return Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[

             Text("Queue Number", style: TextStyle(color: Colors.white, fontSize: 12),),
             Text(que, style: TextStyle(color: Colors.white),),
             Divider(),
             Text(dy.toString().split('.')[0], style: TextStyle(fontSize: 12, color: Colors.white),),
             //Text(nxtdt + ": " + starttime, style: TextStyle(color: Colors.white),),
           ],
         );

       }


     }
     if(nxtstatus == "pending"){
       return GestureDetector(
         onTap: (){
           qrshow();
         },
         child: Container(
           color: Colors.white,
           child:  QrImage(
             foregroundColor: Colors.black87,
             data: nxtref,
             version: QrVersions.auto,
             size: 90,
           ),

         ),
       );
     }
     if(nxtstatus == "confirmed"){
       return GestureDetector(
         onTap: (){
           qrshow();
         },
         child: Container(
           color: Colors.white,
           child:  QrImage(
             foregroundColor: Colors.black87,
             data: nxtref,
             version: QrVersions.auto,
             size: 90,
           ),

         ),
       );
     }

   }
  }

  meeterror(BuildContext context) {

    Widget zoomButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text("QoreMed  "),
          Icon(Icons.warning, color: Colors.redAccent,)
        ],
      ),
      content: Text("No link detected ?"),
      actions: [
        zoomButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _Meet() async {
    if(nxtmeet != ""){
      String url = nxtmeet;
      //String url = "https://www.google.com/";
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        meeterror(context);
      }
    }else{
      meeterror(context);
    }
  }


  showmeet(BuildContext context) {
    Widget meetButton = FlatButton(
      child: Text("Open"),
      onPressed:  () {
        _Meet();
        Navigator.of(context).pop();
      },
    );
    Widget zoomButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Row(
        children: [
          Text("QoreMed  "),
          Icon(Icons.video_call, color: kColorBlue,)
        ],
      ),
      content: Text("Would you like to open the meeting room?"),
      actions: [
        meetButton,
        zoomButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  mynextapp(){
    var _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    if(visible1 == true){
      return Visibility(
        visible: visible1,
        child: Column(
          children: <Widget>[
            SectionHeaderWidget(
              title: 'Next Appointment',
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _isDark ? kColorBlue : kColorPink,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            mynxtdt(),
                          ],
                        ),
                      ),
                      Divider(),

                      myqr(),

                    ],
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 30,
                    thickness: 0.5,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            mynxtdocimg(),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    nxtdoc,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    nxtdocsp,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      FlatButton(

                        color: Colors.white,
                        child: new Text('View', style: TextStyle(color: kColorBlue, fontSize: 12, fontWeight: FontWeight.bold),),
                        onPressed: (){

                          AppVar.nxtmeet = nxtmeet;
                          AppVar.nxtdt = nxtdt;
                          AppVar.nxtdocsp = nxtdocsp;
                          AppVar.nxtid = nxtid;
                          AppVar.nxthospital = nxthospital;
                          AppVar.nxtname = nxtname;
                          AppVar.nxtstatus = nxtstatus;
                          AppVar.nxtconsult = nxtconsult;
                          AppVar.nxtref = nxtref;
                          AppVar.nxttime = nxttime;

                          AppVar.nxtendt = nxtendt;

                          AppVar.docname = nxtdoc;
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AppointmentDetailPage(nxtid),
                            ),
                          );
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }else{
      return Container(

      );
    }

  }



  Future<List<Notice>> getNote() async{
    List<Notice> notice = [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/notices/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];


   print(jsondata.toString());

    for (var u in jsondata){
      String ids,titles,bodys,photos;

      if(u['id']== null){
        ids = "none";
      }else{
        ids = u['id'];
      }
      if(u['title']== null){
        titles = "none";
      }else{
        titles = u['title'];
      }
      if(u['body']== null){
        bodys = "none";
      }else{
        bodys = u['body'];
      }
      if(u['photo_url']== null){
        photos = "https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg";
      }else{
        photos = u['photo_url'];
      }


      Notice not = Notice(ids,titles,bodys,photos);

      notice.add(not);


    }
    if(notice.length > 0){
      setState(() {
        visible2 = true;
      });
    }else
    {
      setState(() {
        visible2 = false;
      });
    }
    print("number of notices" + notice.length.toString());
    setState(() {
      numnotice = notice.length.toDouble();
    });
    return notice;
  }
  patientavatar(String netimage){
    if(netimage == "none"){
      return Container(
        child: CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/person.png'),
        ),
      );
    }else
    {
      // return Container(
      //   width: 60,
      //   height: 60,
      //   decoration: BoxDecoration(
      //       shape: BoxShape.circle,
      //       color: Color(0xFFe0f2f1)),
      //   child: Image.network(netimage),
      // );
      return ClipOval(
        child: Image.network(
          netimage,
          height: 80,
          width: 80,
          fit: BoxFit.cover,
        ),
      );
    }


//return Image.network(netimage);
  }

  docavatar(String netimage){
    if(netimage == "none"){
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/clinic.png'),
      );
    }else
      {
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/clinic.png'),
          child: Image.network(netimage),
        );
      }

//return Image.network(netimage);
  }
  onofapp(){
    if(AppVar.online == true){
     return mynextapp();
    }else{
      if(nxtdt != ""){
        return Container(
          child: Column(
            children: <Widget>[
              SectionHeaderWidget(
                title: 'Next Appointment',
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: kColorBlue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Date',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              mynxtdt(),
                            ],
                          ),
                        ),
                        Divider(),

                        myqr(),

                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 40,
                      thickness: 0.5,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              mynxtdocimgoff(),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      nxtdoc,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Text(
                                      nxtdocsp,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        FlatButton(

                          color: Colors.white,
                          child: new Text('View', style: TextStyle(color: kColorBlue, fontSize: 12, fontWeight: FontWeight.bold),),
                          onPressed: (){


                            AppVar.nxtdt = nxtdt;
                            AppVar.nxtdocsp = nxtdocsp;
                            AppVar.nxtid = nxtid;
                            AppVar.nxthospital = nxthospital;
                            AppVar.nxtname = nxtname;
                            AppVar.nxtstatus = nxtstatus;
                            AppVar.nxtconsult = nxtconsult;
                            AppVar.nxtref = nxtref;
                            AppVar.nxttime = nxttime;

                            AppVar.nxtendt = nxtendt;

                            AppVar.docname = nxtdoc;
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AppointmentDetailPage(nxtid),
                              ),
                            );
                          },
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }else{
        return Container(
          child: null,
        );
      }
    }
  }

  notifString(){
    if(notif > 0) {
      return CircleAvatar(
          backgroundColor: kColorBlue,
          child: Text(notif.toString(),
            style: TextStyle(color: Colors.white, fontSize: 8),)

      );
    }else{
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onDoubleTap: (){
                        rfr();
                      },
                      child: Image.asset('assets/images/hand.png')
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Hello ' + AppVar.fname,
                        style: Theme.of(context).textTheme.headline6.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      Text(
                        'how_are_you_today'.tr(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontFamily: 'NunitoSans',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Card(
                                  child: Container(

                                    height: 100,
                                    width: 90,

                                    child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(datenow.month.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                                            Text("Month", style: TextStyle(fontSize: 16),)
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                                Card(
                                  child: GestureDetector(
                                    onTap: (){
                                      getNotif();
                                    },
                                    child: Container(
                                      height: 110,
                                      width: 100,
                                      child: Stack(
                                        children: [

                                          Center(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(datenow.day.toString(), style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),),
                                                  Text("Day", style: TextStyle(fontSize: 16),)
                                                ],
                                              )
                                          ),
                                          Positioned(
                                            top: 1,
                                            right: 10,
                                            child: Container(
                                              width: 20,

                                              child: notifString(),
                                            ),
                                          ),
                                        ],
                                      )
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    height: 100,
                                    width: 90,
                                    child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(yr.toString(), style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                                            Text("Year", style: TextStyle(fontSize: 16),)
                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //onofapp(),
                            SectionHeaderWidget(
                                title: "Patient'\s",
                                onPressed: (){
                                  print("docts");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MyDoctorListPage(),
                                    ),
                                  );
                                }
                            ),

                            patients(),

                            SectionHeaderWidget(
                                title: "Clinic'\s",
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ClinicList(),
                                    ),
                                  );
                                }
                            ),

                            cliniclist(),



                          ],
                        ),
                      ),



                    ],
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[


                  SectionHeaderWidget(
                    title: 'Notice Board',
                    onPressed: (){

                    }
                  ),
                ],
              ),
            ),
            onofnot(),



          ],
        ),
      ),
    );
  }
  patients(){
    return Container(
      height: 160,
      child: FutureBuilder(
          future: getpatients(),
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
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20),

                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
                    child: Container(
                      width: 140,
                      height: 140,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x0c000000),
                              offset: Offset(0, 5),
                              blurRadius: 5,
                              spreadRadius: 0),
                          BoxShadow(
                              color: Color(0x0c000000),
                              offset: Offset(0, -5),
                              blurRadius: 5,
                              spreadRadius: 0),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          paava(snapshot.data[index].image,snapshot.data[index].id,snapshot.data[index].name,snapshot.data[index].email),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            snapshot.data[index].email,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 8,
                              fontWeight: FontWeight.w300,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),);
                },
              );

            }
          }

      ),
    );
  }

  paava(String netimage, id,name,mail){
    if(netimage == "none"){
      return GestureDetector(
        onTap: (){
          AppVar.patient_id = id;
          AppVar.patient_name = name;
          AppVar.patient_img = netimage;
          AppVar.patient_email = mail;
          //PatientProfile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientProfile(id),
            ),
          );
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/person.png'),
        ),
      );
    }else
    {
      return GestureDetector(
        onTap: (){
          AppVar.patient_id = id;
          AppVar.patient_name = name;
          AppVar.patient_img = netimage;
          AppVar.patient_email = mail;
          //PatientProfile
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientProfile(id),
            ),
          );
        },
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/person.png'),
          child: Image.network(netimage),
        ),
      );
    }

//return Image.network(netimage);
  }


  Future<List<Patient>> getpatients() async{
    List<Patient> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];



    print(jsondata.toString());

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String id,name,email,image;

      if(u['id'] == null){
        id = "none";
      }else{
        id = u['id'];
      }
      if(u['profile']['first_name'] == null){
        name = "none";
      }else{
        String lname = u['profile']['first_name'];
        name = u['profile']['first_name'] + " " +  lname[0];
      }
      if(u['contact']['email'] == null){
        email = "none";
      }else{
        email = u['contact']['email'];
      }
      if(u['photo_url']== null){
        image = "none";
      }else{
        image = u['photo_url'];
      }

      Patient doctors = Patient(id,name,email,image);

      doctor.add(doctors);
    }
    //}

    //print(doctor.length.toString());
    return doctor;
  }
  cliniclist(){
    return Container(

      child: FutureBuilder(
          future: getclinics(),
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
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.vertical,


                  itemBuilder: (context, index){
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(

                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                         /* boxShadow: [
                            BoxShadow(
                                color: Color(0x0c000000),
                                offset: Offset(0, 5),
                                blurRadius: 5,
                                spreadRadius: 0),
                            BoxShadow(
                                color: Color(0x0c000000),
                                offset: Offset(0, -5),
                                blurRadius: 5,
                                spreadRadius: 0),
                          ],*/
                        ),
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Row(
                            children: <Widget>[
                              docavatar(snapshot.data[index].clinicimg),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Container(

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          color: kColorPrimaryDark,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data[index].desc,
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              FlatButton(
                                color: kColorBlue,
                                shape: RoundedRectangleBorder(

                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)
                                ),
                                onPressed: () {
                                  AppVar.sclinddes  = snapshot.data[index].desc;
                                  AppVar.sclinicname = snapshot.data[index].name;
                                  AppVar.sclinic = snapshot.data[index].clinicid;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SchClinic(),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 5,
                                ),
                                child: Text("Schedule",style: TextStyle(fontSize: 12,color: Colors.white),),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              );

            }
          }

      ),
    );
  }
  Future<List<Doctor>> getclinics() async{
    List<Doctor> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];



    print(jsondata.toString());

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String names,desc,clinicid,clinicimg;

      if(u['photo_url'] == null){
        clinicimg = "none";
      }else{
        clinicimg = u['photo_url'];
      }
      if(u['name'] == null){
        names = "none";
      }else{
        names = u['name'];
      }
      if(u['address']['full_address'] == null){
        desc = "none";
      }else{
        desc = u['address']['full_address'] ;
      }
      if(u['id']== null){
        clinicid = "none";
      }else{
        clinicid = u['id'];
      }

      Doctor doctors = Doctor(names,desc,clinicid,clinicimg);

      doctor.add(doctors);
    }
    //}

    //print(doctor.length.toString());
    return doctor;
  }
  @override
  bool get wantKeepAlive => true;

  onofnot(){
    if(AppVar.online == true){
      return Container(
        height: 400,
        child: Visibility(
          visible: visible2,
          child: Container(
            child: FutureBuilder(
                future: _note,
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
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 10),

                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.40,
                            height: 400,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x0c000000),
                                    offset: Offset(0, 5),
                                    blurRadius: 5,
                                    spreadRadius: 0),
                                BoxShadow(
                                    color: Color(0x0c000000),
                                    offset: Offset(0, -5),
                                    blurRadius: 5,
                                    spreadRadius: 0),
                              ],
                            ),
                            child: Expanded(
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    child: Image.network(snapshot.data[index].photos),
                                  ),
                                  Container(height: 10,),
                                  Center(
                                    child: Text(
                                      snapshot.data[index].titles,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),

                                    ),
                                  ),
                                  Container(height: 10,),
                                  SingleChildScrollView(
                                    child: Html(
                                      data: snapshot.data[index].bodys
                                    )
                                    //child: Text( snapshot.data[index].bodys,style: TextStyle(color: Colors.black45),),
                                  ),

                                  Container(height: 20,),

                                ],
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
        ),
      );
    }else{
      return Container(
          child: Center(
            child: Text("You are in offline mode."),
          )
      );
    }
  }
}

class Doctor{
  final String name;
  final String desc;
  final String clinicid;
  final String clinicimg;

  Doctor(this.name, this.desc, this.clinicid, this.clinicimg);
}

class Appoint{
  final String appid;
  final String docname;
  final String appdate;
  final String docimg;
  final String special;
  final String apptime;

  Appoint(this.appid, this.docname, this.appdate,this.docimg,this.special,this.apptime);
}

class Notice{
  final String ids;
  final String titles;
  final String bodys;
  final String photos;

  Notice(this.ids, this.titles, this.bodys,this.photos);
}

class Patient{
  final String id;
  final String name;
  final String email;
  final String image;

  Patient(this.id, this.name, this.email, this.image);
}


class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}