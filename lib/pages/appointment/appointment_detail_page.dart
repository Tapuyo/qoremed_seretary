import 'dart:async';
//import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../components/custom_button.dart';
import '../../components/doctor_item1.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/pref_manager.dart';
import '../../model/doctor.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qoremed_app/pages/appointment/myroute.dart';

class AppointmentDetailPage extends StatefulWidget {
  String something;
  AppointmentDetailPage(this.something);
  @override
  State<StatefulWidget> createState() {

    return _AppointmentDetailPageState(this.something);
  }
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {

  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  String something;
  String scancode;
  int _counter = 0;

  bool stat = true;
  String queue = "0";
  String starttime = "00:00:00";
  String endtime = "00:00:00";
  Timer timer;
  bool loadcompdt = true;


  _AppointmentDetailPageState(this.something);

  Future _scan() async {
    String barcode = await scanner.scan();
    print("QR Code Scann");
    print(barcode);
    setState(() {
      scancode = barcode;
    });
  }

  @override
  void initState() {
    super.initState();

    queue = "0";
    starttime = "00:00:00";
    endtime = "00:00:00";
    scancode = AppVar.nxtref;
    checkstat();
    if(AppVar.nxtstatus == "queued"){
      _startTimer();
    }
  }

 /* Event event = Event(
    title: AppVar.nxthospital,
    description: AppVar.nxtconsult,
    location: AppVar.nxthospital,
    startDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(AppVar.nxtdt + " " + AppVar.nxttime),
    endDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(AppVar.nxtdt + " " + AppVar.nxtendt),
    allDay: false,
  );*/

  cancelbook()async{
    print('cancel book');
    showProgressDialog(context);
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/appointments/" + something + "/cancel/";

    final response = await http.post(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      Navigator.pop(context);
      //Navigator.of(context).popUntil((route) => route.isFirst);
    }else{
      shownosig(context);
      //Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  shownosig(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booking"),
      content: Text("Something went wrong. Please try again later."),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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



  @override
  void dispose() {
    timer.cancel();
  }

  void _startTimer() {
    //_counter = 1;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_counter < _counter+5) {
          _counter = _counter + 1;
        } else {
          timer.cancel();
        }
      });
    });
  }

  checkstat(){
    if(AppVar.nxtstatus == "queued"){
     setState(() {
       getuser();
       stat = false;
     });
    }
    if(AppVar.nxtstatus == "serving"){
      setState(() {
        stat = false;
      });
    }
    if(AppVar.nxtstatus == "completed"){
      setState(() {
        stat = false;
      });
    }
    if(AppVar.nxtstatus == "cancelled"){
      setState(() {
        stat = false;
      });
    }
   /* else{
      setState(() {
        stat = true;
      });
    }*/
  }

  getuser()async{
  setState(() {
    loadcompdt = true;
  });
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments/" + AppVar.nxtid + "/";
    final response = await http.get(url,headers: headers);
    print(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        queue = jsonDecode(response.body)['queue']['number'];
        starttime = jsonDecode(response.body)['queue']['start_time'];
        endtime = jsonDecode(response.body)['queue']['end_time'];
      });

    }else{
      setState(() {
        queue = "0";
        starttime = "00:00:00";
        endtime = "00:00:00";
      });
    }
  setState(() {
    loadcompdt = false;
  });

  }

  gtqueue()async{
    showProgressDialog(context);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments/" + AppVar.nxtid + "/queue";
    final response = await http.post(url,headers: headers);
    print(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        AppVar.nxtstatus = "queued";
        stat = true;
        queue = jsonDecode(response.body)['queue']['number'];
        starttime = jsonDecode(response.body)['queue']['start_time'];
        endtime = jsonDecode(response.body)['queue']['end_time'];
        checkstat();
      });

    }else{
      setState(() {
        queue = "0";
        starttime = "00:00:00";
        endtime = "00:00:00";
      });
    }

    Navigator.pop(context);
  }



  myqr(){
    if(stat == true) {
      if (AppVar.nxtconsult == 'Virtual Consultation') {
        return Column(
          children: <Widget>[
            Padding(
              padding:
              EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'Click button if you are already in online room.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Center(
              child: GestureDetector(
                onTap: () {
                  qrshow();
                },
                child: Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 30,
                    height: 100,
                    color: kColorBlue,
                    child: FlatButton(
                      onPressed: (){
                        showmeet(context);
                      },
                      child: Text(
                        "I'm here", style: TextStyle(color: Colors.white),),
                    )
                ),
              ),
            ),
          ],
        );
      }
      if (AppVar.nxtconsult == 'On-Site Consultation') {
        return Column(
          children: <Widget>[
            Padding(
              padding:
              EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                      'Please show your two dimensional code to assign person.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Center(
              child: GestureDetector(
                onTap: () {
                  qrshow();
                },
                child: Container(

                  child: QrImage(
                    foregroundColor: Colors.black87,
                    data: scancode,
                    version: QrVersions.auto,
                    size: MediaQuery
                        .of(context)
                        .size
                        .width - 120,
                  ),

                ),
              ),
            ),
            Center(
              child: Text(scancode,
                style: TextStyle(color: Colors.black, fontSize: 20),),
            )
          ],
        );
      }
    }else{
      if(AppVar.nxtstatus == "queued"){
        if(loadcompdt == true){
          return Center(
            child: Column(
              children: <Widget>[
                Container(height: 50,),
                Container(
                  child: Text("Computing Date Time and Queue"),
                ),
                Container(
                  height: 10,
                ),
                CircularProgressIndicator()
              ],
            ),
          );
        }else{
          DateTime dtnow = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
          DateTime dtme = DateFormat("yyyy-MM-dd hh:mm:ss").parse(AppVar.nxtdt + " " + starttime);


          return Container(
            child: Center(
                child: Column(
                  children: <Widget>[
                    Container(height: 40,),
                    Text("Queue Number", style: TextStyle(fontSize: 20, color: Colors.black),),
                    Text(queue, style: TextStyle(fontSize: 80, color: kColorBlue),),
                    Container(height: 20,),
                    Text("Estimated Serving Time", style: TextStyle(fontSize: 20, color: Colors.black),),
                    computedt(),
                    Container(height: 20,),
                    //Text(_counter.toString()),
                    /* Text("Date and Time serve", style: TextStyle(fontSize: 20, color: Colors.black),),
              Text(dtme.toString()),
              Text("Date and Time now", style: TextStyle(fontSize: 20, color: Colors.black),),
              Text(dtnow.toString()),*/

                  ],
                )
            ),
          );
        }
      }
      if(AppVar.nxtstatus == "serving"){
        return Center(
          child: Column(
            children: <Widget>[
              Container(height: 40,),
              Text("You are now serving", style: TextStyle(fontSize: 20, color: Colors.black),),
              Container(height: 40,),
              CircleAvatar(
                radius: 30,
                backgroundColor: kColorBlue,
                //backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
                child: Icon(
                  Icons.local_hospital,
                  color: Colors.white,
                ),
              ),
              //CircularProgressIndicator()
            ],
          ),
        );
      }
      if(AppVar.nxtstatus == "completed"){
        return Center(
          child: Column(
            children: <Widget>[
              Container(height: 40,),
              Text("You finished your appointment", style: TextStyle(fontSize: 20, color: Colors.black),),
              Container(height: 40,),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.green,
                //backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
              Container(height: 20,),
              //CircularProgressIndicator()
            ],
          ),
        );
      }
      if(AppVar.nxtstatus == "cancelled"){
        return Center(
          child: Column(
            children: <Widget>[
              Container(height: 40,),
              Text("Your appoinment is cancelled", style: TextStyle(fontSize: 20, color: Colors.black),),
              Container(height: 40,),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.redAccent,
                //backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
                child: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
              ),
              Container(height: 20,),
              //CircularProgressIndicator()
            ],
          ),
        );
      }

    }
  }
  computedt(){
    DateTime dtnow = DateTime.parse(DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()));
    DateTime dtme = DateFormat("yyyy-MM-dd hh:mm:ss").parse(AppVar.nxtdt + " " + starttime);
    final days = dtme.difference(dtnow).inDays;
    final dy = dtme.difference(dtnow);


    if(days > 0){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(days.toString(), style: TextStyle(fontSize: 80, color: Colors.black),),
          Text(" Day(s) to go", style: TextStyle(fontSize: 20, color: Colors.black),),
        ],
      );
    }else{
      return Text(dy.toString().split('.')[0], style: TextStyle(fontSize: 50, color: Colors.black),);
    }

  }
  qrshow() {

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
                            foregroundColor: Colors.black87,
                            data: AppVar.nxtref,
                            version: QrVersions.auto,
                            size: 200.0,
                          ),


                        ),
                      ),
                      Divider(),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                        width: MediaQuery.of(context).size.width - 50,
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

  final bool _isdark = Prefs.getBool(Prefs.DARKTHEME, def: false);

  Widget dateAndTime() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
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
                        'Clinic/Hospital',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RouteMap(AppVar.nxthospital),
                            ),
                          );
                        },
                        child: Text(
                          AppVar.nxthospital,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: _isdark ? Colors.black : Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Type of Consultation',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppVar.nxtconsult,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget practiceDetail() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            'Date and Time',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: (){
                             /* Add2Calendar.addEvent2Cal(event).then((success) {
                                scaffoldState.currentState.showSnackBar(
                                    SnackBar(content: Text(success ? 'Success' : 'Error')));
                              });*/
                            },
                            child: Icon(
                              Icons.calendar_today,size: 15,color: kColorBlue,
                            ),
                          ),
                          Container(
                            width: 5,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppVar.nxtdt,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        AppVar.nxttime,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: VerticalDivider(
                    color: _isdark ? Colors.black : Colors.grey[300],
                    width: 0.5,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppVar.nxtstatus,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget procedure() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Text(
              'Type of Consultation',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              AppVar.nxtconsult,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget bookingDetails() {
    return Container(
      width: double.infinity,
      color: _isdark ? Colors.white.withOpacity(0.12) : Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'booked_for'.tr(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      AppVar.nxtname,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: VerticalDivider(
                  color: _isdark ? Colors.black : Colors.grey[300],
                  width: 0.5,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'appointment_id'.tr(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        something,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  docavatar() {
    if (AppVar.docimg == "none") {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
      );
    } else {
      return CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
        child: Image.network(AppVar.docimg),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'appointment_details'.tr(),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: (){
              if(AppVar.nxtconsult == 'Virtual Consultation'){
                showmeet(context);
              }else{
                _scan();
              }
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Icon(Icons.settings_overscan),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: _isdark ? Colors.transparent : Colors.white,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      docavatar(),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppVar.docname,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2
                                  .copyWith(fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Text(
                              AppVar.nxtdocsp,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      dateAndTime(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      practiceDetail(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                     /* procedure(),
                      Divider(
                        color: _isdark ? Colors.black : Colors.grey[300],
                        height: 0.5,
                      ),
                      bookingDetails(),*/

                      myqr(),
                      Container(height: 30,)
                    ],
                  ),
                ),
              ),
            ),

            Container(
              height: 10,
            ),
            Visibility(
              visible: stat,
              child: myque(),
            ),
            Container(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
  myque(){
    if(AppVar.nxtstatus == "pending"){
      return  Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 25,
        child: FlatButton(

          onPressed: () {

            //Navigator.of(context).popUntil((route) => route.isFirst);
          },
          color: Colors.grey,

          child: Text('Get Queue', style: TextStyle(color: Colors.white),),
        ),
      );
    }
    if(AppVar.nxtstatus == "confirmed"){
      return  Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 25,
        child: FlatButton(

          onPressed: () {
            gtqueue();
          },
          color: kColorBlue,

          child: Text('Get Queue', style: TextStyle(color: Colors.white),),
        ),
      );
    }
    else{
      setState(() {
        stat = false;
      });
      return Container();
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
    if(AppVar.nxtmeet != ""){
      String url = AppVar.nxtmeet;

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        meeterror(context);
      }
    }else{
      meeterror(context);
    }
  }

}
