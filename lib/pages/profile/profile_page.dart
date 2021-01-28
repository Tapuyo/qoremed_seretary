import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/pages/profile/patient/patientbook.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage> {
  final _kTabTextStyle = TextStyle(
    color: kColorBlue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  int _selectedIndex = -1;
  var _isDark;
  bool loadme = true;
  List mylist =  [];
  int dtme = 0;
  List datesData = [];



  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];

  }
  getSched(String clinicid) async{
    print("Clinic ID:" + AppVar.sclinic);
    setState(() {
      loadme = true;
    });
    _events = {};
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + clinicid + "/periods/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    var tagObjsJson = jsonDecode(response.body) as List;
    setState(() {
      mylist = tagObjsJson;
    });
    for(int i = 0; i < mylist.length; i++) {
      setState(() {
        datesData.add(mylist[i]);
      });
    }

    for (var u in jsondata){
      List eve = [];
      if(u['date'].toString() != null){
        DateTime dtme = DateFormat("yyyy-MM-dd").parse(u['date']);

        if (_events[dtme] != null) {
          print(dtme.toString());
          setState(() {
            _events[dtme]
                .add(u['id'].toString());

          });

        }
        else {
          _events[dtme] = [
            u['id'].toString()
          ];

        }

        setState(() {

          _selectedEvents = _events[dtme];
        });


      }else
      {
        print("not");
      }
    }
    setState(() {
      loadme = false;
    });

  }
  mycalendar(){
    if(loadme == true){
      return Column(
        children: <Widget>[
          Container(height: 50,),
          Container(
            child: Text("Loading"),
          ),
          Container(
            height: 10,
          ),
          CircularProgressIndicator()
        ],
      );
    }else{
      return TableCalendar(

        events: _events,

        initialCalendarFormat: CalendarFormat.month,
        calendarStyle: CalendarStyle(
            canEventMarkersOverflow: true,
            todayColor: kColorPink,
            selectedColor: Theme.of(context).buttonColor,
            todayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: kColorDarkBlue)),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonDecoration: BoxDecoration(
            color: kColorBlue,
            borderRadius: BorderRadius.circular(20.0),
          ),
          formatButtonTextStyle: TextStyle(color: Colors.white),
          formatButtonShowsNext: false,
        ),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        onDaySelected: (date, events, _) {
          setState(() {
            onSelect(date);
            _selectedEvents = events;

          });
        },
        builders: CalendarBuilders(
          selectedDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
          todayDayBuilder: (context, date, events) => Container(
              margin: const EdgeInsets.all(4.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: kColorBlue,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white),
              )),
        ),
        calendarController: _calendarController,
      );
    }
  }


  Future<List<Doctor>> getclinics() async{
    List<Doctor> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];



    print(jsondata.toString());

    Doctor doctors = Doctor(" All ","clinic","");

    doctor.add(doctors);

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String names,desc,clinicid;

      if(u['name'] == null){
        names = "none";
      }else{
        names = u['name'];
      }
      if(u['description'] == null){
        desc = "none";
      }else{
        desc = u['description'];
      }
      if(u['id']== null){
        clinicid = "none";
      }else{
        clinicid = u['id'];
      }

      Doctor doctors = Doctor(names,desc,clinicid);

      doctor.add(doctors);
    }
    //}

    //print(doctor.length.toString());
    return doctor;
  }

  onSelect(data) {
    setState(() {
      datesData.clear();
    });
    print("Selected Date -> $data");


    for(int i = 0; i < mylist.length; i++){
      DateTime mydt;
      if(mylist[i]['date'] == null){
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      }else{
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(mylist[i]['date'])));
      }

      if(DateTime.parse(DateFormat('yyyy-MM-dd').format(data)) == DateTime.parse(DateFormat('yyyy-MM-dd').format(mydt))){
        setState(() {
          datesData.add(mylist[i]);
        });
      }
    }
    dtme = mylist.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 110,
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('Clinic',style: TextStyle(fontSize: 16),),
                    SizedBox(height: 2,),
                    clinic(),




                  ],
                ),
              ),
              Divider(),
              Container(
                child: Container(

                 // color: kColorDarkBlue,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                      ),
                      //color: Colors.white,
                    ),
                    child: TableCalendar(

                      events: _events,

                      initialCalendarFormat: CalendarFormat.twoWeeks,
                      calendarStyle: CalendarStyle(
                          canEventMarkersOverflow: true,
                          todayColor: kColorPink,
                          selectedColor: Theme.of(context).primaryColor,
                          todayStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: kColorDarkBlue)),
                      headerStyle: HeaderStyle(
                        centerHeaderTitle: true,
                        formatButtonDecoration: BoxDecoration(
                          color: kColorBlue,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                      ),
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      onDaySelected: (date, events, _) {
                        setState(() {
                          onSelect(date);
                          _selectedEvents = events;

                          // AppVar.periodid = events[0].toString();
                          //  print(AppVar.periodid);
                          //Navigator.of(context).pushNamed(Routes.bookingStep4);
                        });
                      },
                      builders: CalendarBuilders(
                        selectedDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).buttonColor,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                        todayDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: kColorBlue,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(color: Colors.white),
                            )),
                          markersBuilder: (context, date, events, holidays) {
                            final children = <Widget>[];

                            if (events.isNotEmpty) {
                              children.add(
                                Positioned(
                                  right: 1,
                                  bottom: 1,
                                  child: _buildEventsMarker(date, events),
                                ),
                              );
                            }
                            return children;

                          }
                      ),
                      calendarController: _calendarController,
                    ),
                  ),
                ),

              ),
              Divider(),


              mydataview(),



            ],
          )
        ),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
            ? Colors.brown[300]
            :  Colors.amber[800],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  mydataview(){
    if (dtme == 0){
      return Container(

        padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
        child: Center(
          child: Column(
            children: <Widget>[
              //Image.asset('images/truckgif.gif'),
              //CircularProgressIndicator(),

              Text("Select other date", style: TextStyle(fontSize: 14, color: Colors.black45),),
              Text("No data found", style: TextStyle(fontSize: 20, color: Colors.black45, fontStyle: FontStyle.italic),),
            ],
          ),
        ),
      );
    }else{
      return ListView.builder(

          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: datesData.length,
          itemBuilder: (BuildContext context, i){
            return Card(
              //color: Color.fromRGBO(240, 233, 251, 1),
              child: GestureDetector(
                child: new Column(

                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Expanded(
                          flex:1,
                          child: Card(
                            //color: Color.fromRGBO(240, 233, 251, 1),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(10,5,0,2),
                              // height: 120,

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //Text(datesData[i]['id'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                                  mydata(datesData[i]['consultation_type']['id'].toString(),datesData[i]['id'],datesData[i]['start_time'],datesData[i]['end_time'],datesData[i]['date']),
                                  Container(height: 10,),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            );
          });
    }


  }

  mydata(String event,id, starttime, endtime, dateme){
    if(event == "1"){
      DateTime dtme = DateFormat("yyyy-MM-dd").parse(dateme);

      int dtmo = dtme.month;
      String dt = dtme.day.toString();
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

      return Container(
        height: 70,
        child: Card
          (
            color: Colors.pinkAccent,
            child: GestureDetector(
              onTap: (){
                AppVar.perioddt = mo + " " + dt + " " + starttime;
                AppVar.periodtype = "Virtual Consultation";
                AppVar.periodid = id;
                print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientBook(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  Center(
                      child: Text("On-Site Consultation", style: TextStyle(color: Colors.white),)
                  ),
                  Center(
                      child: Text(mo + " " + dt + " " + starttime + " - " + endtime, style: TextStyle(color: Colors.white),)
                  ),
                ],
              ),
            )
        ),
      );
    }
    if(event == "2"){
      DateTime dtme = DateFormat("yyyy-MM-dd").parse(dateme);
      int dtmo = dtme.month;
      String dt = dtme.day.toString();
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
      return Container(

        height: 70,
        child: Card
          (
            color: Colors.indigoAccent,
            child: GestureDetector(
              onTap: (){
                AppVar.perioddt = mo + " " + dt + " " + starttime;
                AppVar.periodtype = "Virtual Consultation";
                AppVar.periodid = id;
                print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientBook(),
                  ),
                );
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  Center(
                      child: Text("Virtual Consultation", style: TextStyle(color: Colors.white),)
                  ),
                  Center(
                      child: Text(mo + " " + dt + " " + starttime + " - " + endtime, style: TextStyle(color: Colors.white),)
                  ),
                ],
              ),
            )
        ),
      );
    }

  }




  @override
  bool get wantKeepAlive => true;
  widgetdt(String dtn){
    DateTime dtme = DateFormat("yyyy-MM-dd").parse(dtn);
    int mo = dtme.month;
    String mon = "";
    if(mo == 1){
      mon = "January";
    }
    if(mo == 2){
      mon = "February";
    }
    if(mo == 3){
      mon = "March";
    }
    if(mo == 4){
      mon = "April";
    }
    if(mo == 5){
      mon = "May";
    }
    if(mo == 6){
      mon = "June";
    }
    if(mo == 7){
      mon = "July";
    }
    if(mo == 8){
      mon = "August";
    }
    if(mo == 9){
      mon = "September";
    }
    if(mo == 10){
      mon = "October";
    }
    if(mo == 11){
      mon = "November";
    }
    if(mo == 12){
      mon = "December";
    }
    var dt = dtme.day;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mon.toString() + " " + dt.toString(),style: TextStyle(fontSize: 18, color: Colors.white),
        ),


      ],
    );
  }


  clinic(){
    return Container(
        width: double.infinity,
        height: 85,
        padding: EdgeInsets.symmetric(
          vertical: 10,
        ),
   /*     color: Prefs.getBool(Prefs.DARKTHEME, def: false)
            ? Colors.white.withOpacity(0.12)
            : Colors.grey[300],*/
        child: FutureBuilder(
          //snapshot.data[index].clinicid
            future: getclinics(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if (snapshot.data == null && snapshot.connectionState == ConnectionState.none) {
                return Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text("No Data"),
                      ),
                      Container(

                        height: 10,
                      ),
                      //CircularProgressIndicator()
                    ],
                  ),
                );
              }
              if(snapshot.connectionState == ConnectionState.waiting){
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
              }
              else{
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  scrollDirection: Axis.horizontal,
                  //padding: EdgeInsets.symmetric(horizontal: 20),

                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Container(
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
                        //child: Text(snapshot.data[index].start_time),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              AppVar.sclinddes  = snapshot.data[index].desc;
                              AppVar.sclinicname = snapshot.data[index].name;
                              AppVar.sclinic = snapshot.data[index].clinicid;
                              _selectedIndex = index;
                              getSched(snapshot.data[index].clinicid);
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: _selectedIndex != null && _selectedIndex == index ? kColorBlue : Colors.grey,
                                width: 2, //selected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),

                            child: Center(
                              child: Text(
                                //snapshot.data[index].daym,
                                snapshot.data[index].name,
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                    fontWeight: FontWeight.w600, color: _isDark ? kColorBlue : Colors.black54),
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
        )
    );
  }
}

class Doctor{
  final String name;
  final String desc;
  final String clinicid;

  Doctor(this.name, this.desc, this.clinicid);
}