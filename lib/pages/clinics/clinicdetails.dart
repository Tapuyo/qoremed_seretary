import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../myvars.dart';
import '../../utils/constants.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class ClinicDetails extends StatefulWidget {
  String did,name,add,img;
  ClinicDetails(this.did,this.name,this.add,this.img);
  @override
  _ClinicDetailsPageState createState() => _ClinicDetailsPageState(this.did,this.name,this.add,this.img);
}

class _ClinicDetailsPageState extends State<ClinicDetails> {
  String did,name,add,img;
  bool showimg = false;
  double zooming = 6;

  _ClinicDetailsPageState(this.did,this.name,this.add,this.img);

  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  String _mapStyle;

  static  LatLng _lastMapPosition;

  @override
  void initState() {
    super.initState();
    GoogleMap.init(AppVar.googlemapid);
    getcord();

  }

  getcord()async{
    final query = add + ", Philippines";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    //print("${first.featureName} : ${first.coordinates}");
    print(first.coordinates.latitude.toString() + "," + first.coordinates.longitude.toString());
    setState(() {
      zooming = 8;
      _lastMapPosition = new LatLng(first.coordinates.latitude, first.coordinates.longitude);
      GoogleMap.of(_key).addMarker(Marker(
          GeoCoord(first.coordinates.latitude, first.coordinates.longitude),
          label: name,
      )
      );


    });
  }


  Future<List<Sch>> getclinics() async{
    List<Sch> doctor = [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + did + "/schedule/slots/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];

    print(jsondata.toString());

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String daysc,type,starttime,endtime;

      if(u['day'] == null){
        daysc = "";
      }else{
        daysc = u['day'];
      }
      if(u['consultation_type']['name'] == null){
        type = "";
      }else{
        type = u['consultation_type']['name'];
      }
      if(u['start_time'] == null){
        starttime = "";
      }else{
        starttime = u['start_time'];
      }
      if(u['end_time']== null){
        endtime = "";
      }else{
        endtime = u['end_time'];
      }

      Sch doctors = Sch(daysc,type,starttime,endtime);

      doctor.add(doctors);
    }
    //}

    print(doctor.length.toString());
    return doctor;
  }

  sched(){
    return Container(
        child: SingleChildScrollView(
          child: Container(
            child: Container(padding: EdgeInsets.all(5.0),
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
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                            child: Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              actionExtentRatio: 0.25,
                              secondaryActions: <Widget>[

                                IconSlideAction(
                                    caption: 'Delete',
                                    color: Colors.white,
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
                                    caption: 'Alarm',
                                    color: Colors.white,
                                    icon: Icons.alarm,
                                    onTap: (){
                                    /*  Event event = Event(
                                        title: name,
                                        description: snapshot.data[index].type,
                                        location: add,
                                        startDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateTime.now().toString() + " " + snapshot.data[index].starttime),
                                        endDate: DateFormat("yyyy-MM-dd hh:mm:ss").parse(DateTime.now().toString() + " " + snapshot.data[index].endtime,),
                                        allDay: true,
                                      );*/

                                      setState(() {
                                      /*  Add2Calendar.addEvent2Cal(event).then((success) {
                                          scaffoldState.currentState.showSnackBar(
                                              SnackBar(content: Text(success ? 'Success' : 'Error')));
                                        });*/
                                      });

                                    }
                                ),

                              ],
                              child: GestureDetector(
                                onTap: (){

                                },
                                child: Row(
                                  children: <Widget>[

                                    Expanded(
                                      child: Container(

                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].daysc,
                                              style: TextStyle(
                                                color: kColorPrimaryDark,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data[index].starttime + "-" + snapshot.data[index].endtime,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(width: 50,),
                                                Text(
                                                  snapshot.data[index].type,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            )
                        ),
                      );
                    }
                );

              }
            }

        )
    ),
  ),
),
    );
  }

  myback(String clinicimg){
    if(showimg == true){
      return Container(
        child: GoogleMap(
          key: _key,


          initialZoom: zooming,
          initialPosition: GeoCoord(
              _lastMapPosition.latitude, _lastMapPosition.longitude),
          mapType: MapType.roadmap,
          mapStyle: _mapStyle,

          interactive: true,
          onTap: (coord) =>
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content: Text(coord?.toString()),
                duration: const Duration(seconds: 2),
              )),
          mobilePreferences: const MobileMapPreferences(
            trafficEnabled: true,
            zoomControlsEnabled: false,
          ),
          webPreferences: WebMapPreferences(
            fullscreenControl: true,
            zoomControl: true,
          ),


        ),
      );
    }else {
      if (clinicimg == "") {
        return Container(
          child: GoogleMap(
            key: _key,


            initialZoom: zooming,
            initialPosition: GeoCoord(
                _lastMapPosition.latitude, _lastMapPosition.longitude),
            mapType: MapType.roadmap,
            mapStyle: _mapStyle,

            interactive: true,
            onTap: (coord) =>
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(coord?.toString()),
                  duration: const Duration(seconds: 2),
                )),
            mobilePreferences: const MobileMapPreferences(
              trafficEnabled: true,
              zoomControlsEnabled: false,
            ),
            webPreferences: WebMapPreferences(
              fullscreenControl: true,
              zoomControl: true,
            ),


          ),
        );
      } else {
        return Container(
          child: Image.network(clinicimg),
        );
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
                title: Text("Clinic Details"),
                expandedHeight: 280,
                floating: false,
                pinned: true,
                //backgroundColor: Colors.white,
                elevation: 1,
                flexibleSpace: Stack(
                  children: [
                    FlexibleSpaceBar(
                      background:  myback(img)


                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                        child: Container(
                          width: 100,
                          height: 40,
                          child: RawMaterialButton(
                            onPressed: () {


                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            fillColor: kColorBlue,
                            child: Container(
                                height: 48,
                                child: GestureDetector(
                                  onTap: (){
                                    if(showimg == true){
                                      print("on map");
                                      setState(() {
                                        getcord();
                                        showimg = false;
                                      });
                                    }
                                    if(showimg == false){
                                      print("off map");
                                      setState(() {
                                        showimg = true;
                                      });
                                    }
                                  },
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.directions_outlined,color: Colors.white,),
                                        SizedBox(width: 5,),
                                        Text(
                                          "Map",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )


            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
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
                            name,
                            style:
                            Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            add,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),


                sched(),

                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[

                    Expanded(
                      child: SizedBox(
                        width: 50,
                      ),
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return MyDialog(did);
                            },
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: Container(
                          height: 48,
                          child: Center(
                            child: Text(
                              'Add Schedule'.tr().toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
class Sch{
  final String daysc;
  final String type;
  final String starttime;
  final String endtime;

  Sch(this.daysc, this.type, this.starttime, this.endtime);
}


class MyDialog extends StatefulWidget {
  String did;
  MyDialog(this.did);
  @override
  _MyDialogState createState() => _MyDialogState(this.did);
}

class _MyDialogState extends State<MyDialog> {
  String did;
  _MyDialogState(this.did);

  List mylist =   List();
  String dateselect = "";
  String _mySelection;
  String _mySelection1;
  String strt;
  String endt;
  var _currencies = [
    "On-Site Consultation",
    "Virtual Consultation",
  ];
  var _days = [
    "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday",
  ];


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
  booknow(String date)async{
    print(_mySelection + "|" + _mySelection1 + "|" + strt + "|" + endt);
    String myday;
    if(_mySelection1 == "Sunday"){
      myday = "6";
    }
    if(_mySelection1 == "Monday"){
      myday = "0";
    }
    if(_mySelection1 == "Tuesday"){
      myday = "1";
    }
    if(_mySelection1 == "Wednesday"){
      myday = "2";
    }
    if(_mySelection1 == "Thursday"){
      myday = "3";
    }
    if(_mySelection1 == "Friday"){
      myday = "4";
    }
    if(_mySelection1 == "Saturday"){
      myday = "5";
    }
   // showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/clinics/" + did + "/schedule/slots";
    Map<String, String> body = {
      "consultation_type_id": _mySelection,
      "day": myday,
      "start_time": strt,
      "end_time": endt,
    }; //
    final response = await http.post(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      Navigator.pop(context);

    }else{
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    getSched();
    dateselect = DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString();
  }


  getSched() async {
    _currencies.clear();
    print("Doctor ID " + AppVar.userid);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/references/consultation-types/";
    final response = await http.get(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    var tagObjsJson = jsonDecode(response.body) as List;
    setState(() {
      mylist = tagObjsJson;
    });


    for (var u in jsondata) {
      setState(() {
        _currencies.add(u['name']);
      });
    }

  }



  myconres(){
    return  Container(
      child: Container(
        child: new DropdownButton(
          isExpanded: true,
          items: mylist.map((item) {
            return new DropdownMenuItem(
              child: new Text(item['name'], style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),),
              value: item['id'].toString(),
            );
          }).toList(),
          onChanged: (newVal) {
            setState(() {
              _mySelection = newVal;
              print(_mySelection);
            });
          },
          value: _mySelection,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 430,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Consultation"),
              /* TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ''),
              ),*/
              Container(

                child: myconres(),
              ),
              Text("Select Day"),
              /* TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ''),
              ),*/
              Container(

                child: Container(
                  child: new DropdownButton(
                    isExpanded: true,
                    items: _days.map((item1) {
                      return new DropdownMenuItem(
                        child: new Text(item1, style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),),
                        value: item1.toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection1 = newVal;
                        print(_mySelection1);

                      });
                    },
                    value: _mySelection1,
                  ),
                ),
              ),
              Text("Time Start"),
              TimePickerSpinner(
                is24HourMode: false,
                normalTextStyle: TextStyle(
                    fontSize: 14,
                    color: kColorDarkBlue
                ),
                highlightedTextStyle: TextStyle(
                    fontSize: 16,
                    color: kColorBlue
                ),
                spacing: 10,
                itemHeight: 30,
                isForce2Digits: true,
                onTimeChange: (time) {
                  setState(() {
                    strt = time.hour.toString() + ":" + time.minute.toString();
                  });
                },
              ),
              Text("Time End"),
              TimePickerSpinner(
                is24HourMode: false,
                normalTextStyle: TextStyle(
                    fontSize: 14,
                    color: kColorDarkBlue
                ),
                highlightedTextStyle: TextStyle(
                    fontSize: 16,
                    color: kColorBlue
                ),
                spacing: 10,
                itemHeight: 30,
                isForce2Digits: true,
                onTimeChange: (times) {
                  setState(() {
                    endt = times.hour.toString() + ":" + times.minute.toString();
                  });
                },
              ),

              SizedBox(
                width: 320.0,
                child: RaisedButton(
                  onPressed: () {
                    booknow(dateselect);
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: kColorBlue,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}