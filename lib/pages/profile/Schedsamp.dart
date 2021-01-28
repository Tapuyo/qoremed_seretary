import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/data/pref_manager.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchedSamp extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<SchedSamp>
    with AutomaticKeepAliveClientMixin<SchedSamp> {
  final _kTabTextStyle = TextStyle(
    color: kColorBlue,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> _events;
  int _selectedIndex = -1;
  var _isDark;


  @override
  void initState() {
    super.initState();
    _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
  }

  Future<List<Doctor>> getclinics() async{
    List<Doctor> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors/" + sample + "/clinics/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body);



    print(jsondata.toString());

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment"),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
              children: [
                Container(
                  child: Container(

                    color: kColorDarkBlue,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.0),
                        ),
                        color: Colors.white,
                      ),
                      child: TableCalendar(

                        events: _events,

                        initialCalendarFormat: CalendarFormat.week,
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
                        ),
                        calendarController: _calendarController,
                      ),
                    ),
                  ),

                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                    ),
                    color: kColorDarkBlue,
                  ),
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /*Text('Clinic',style: TextStyle(color: Colors.white,fontSize: 16),),
                      SizedBox(height: 2,),
                      clinic(),
                      Divider(),*/

                      Text('Book Appointment',style: TextStyle(color: Colors.white,fontSize: 16),),
                      SizedBox(height: 2,),

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Slidable(
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
                                    caption: 'Mark As Paid',
                                    color: Colors.white,
                                    icon: Icons.money,
                                    onTap: (){

                                      setState(() {

                                      });

                                    }
                                ),
                              ],
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: AssetImage('assets/images/icon_man.png'),
                                          //child: Image.network(snapshot.data[index].hosimage),
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
                                                'Payment Status: Unpaid',
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
                                                Text('Proof of Payments', style: TextStyle(
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
                            Slidable(
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
                                    caption: 'Mark As Paid',
                                    color: Colors.white,
                                    icon: Icons.money,
                                    onTap: (){

                                      setState(() {

                                      });

                                    }
                                ),
                              ],
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0,0,0,0),
                                child: Card(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 25,
                                          backgroundImage: AssetImage('assets/images/icon_doctor_4.png'),
                                          //child: Image.network(snapshot.data[index].hosimage),
                                        ),
                                        SizedBox(
                                          width: 15,
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
                                                'Payment Status: Unpaid',
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
                                                Text('Proof of Payments', style: TextStyle(
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

                          ],
                        ),
                      ),
                    ],
                  ),
                ),



              ],
            )
        ),
      ),
    );
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
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Container(
                        //child: Text(snapshot.data[index].start_time),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              _selectedIndex = index;
                            });



                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 25,
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