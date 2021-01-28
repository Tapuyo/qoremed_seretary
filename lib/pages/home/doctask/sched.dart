import 'package:flutter/cupertino.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/pages/home/doctask/appointment.dart';
import 'package:qoremed_app/pages/home/doctask/appointments.dart';
import 'package:qoremed_app/pages/home/doctask/appointmentv.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';
import '../../../routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/custom_button.dart';

class SchClinic extends StatefulWidget {
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<SchClinic> {
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  SharedPreferences prefs;
  int dtme = 0;
  List<DateTime> markedDates = [];
  List datesData = [];
  List mylist =  [];
  bool loadme = true;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    getSched();
  }


  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();

    AppVar.sclinic = "";
  }




  getSched() async{
    print("Clinic ID:" + AppVar.sclinic);
    setState(() {
      loadme = true;
    });
    _events = {};
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + AppVar.sclinic + "/periods/";
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
            print(_selectedEvents.toString());
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
      );
    }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Clinic Schedule'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                child: mycalendar()
            ),
            Divider(),
            /* ..._selectedEvents.map((event) => ListTile(
              title: mydata(event),
            )),*/


            mydataview(),


            /*Container(
              height: 70,
              child: Card
                (
                  color: Colors.pinkAccent,
                  child: GestureDetector(
                    onTap: (){
                      AppVar.sclinicslot = 'October 24, 2020 12:00 - 1:00';
                      AppVar.sclinictype = 'On-Site Consultation';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppTodayS(),
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
                            child: Text('October 24, 2020 12:00 - 1:00', style: TextStyle(color: Colors.white),)
                        ),
                      ],
                    ),
                  )
              ),
            ),
            Container(
              height: 70,
              child: Card
                (
                  color: Colors.indigoAccent,
                  child: GestureDetector(
                    onTap: (){
                      AppVar.sclinicslot = 'October 24, 2020 4:00 - 5:00';
                      AppVar.sclinictype = 'Virtual Consultation';
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppTodayV(),
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
                            child: Text('October 24, 2020 4:00 - 5:00', style: TextStyle(color: Colors.white),)
                        ),
                      ],
                    ),
                  )
              ),
            ),*/
          ],
        ),
      ),

    );
  }

  mydata(String event,id, starttime, endtime, dateme, docstat, questat){
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
                AppVar.periodid = id;
                AppVar.periodtype = "On-Site Consultation";
                AppVar.perioddt = mo + " " + dt + " " + starttime;
                print(id);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppTodayS(docstat,questat),
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
                  MaterialPageRoute(builder: (context) => AppTodayV(docstat,questat),
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
    print(mylist.toString());
    dtme = mylist.length;
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

              //Text("Select other date", style: TextStyle(fontSize: 14, color: Colors.black45),),
              //Text("No data found", style: TextStyle(fontSize: 20, color: Colors.black45, fontStyle: FontStyle.italic),),
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

                                  mydata(datesData[i]['consultation_type']['id'].toString(),datesData[i]['id'],datesData[i]['start_time'],datesData[i]['end_time'],datesData[i]['date'],datesData[i]['doctor_status'],datesData[i]['patient_queueing']),
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

}
