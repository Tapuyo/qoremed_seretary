import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qoremed_app/pages/booking/step3.5/step3.5.dart';
import 'package:qoremed_app/utils/constants.dart';
import '../../../routes/routes.dart';
import 'package:qoremed_app/myvars.dart';
import '../../../components/custom_button.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:instant/instant.dart';


class TimeSlotPage extends StatefulWidget {
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  CalendarController _calendarController = CalendarController();
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  TextEditingController _eventController;
  int dtme = 0;
  List<DateTime> markedDates = [];
  List datesData = [];
  List mylistcal =  [];
  bool loadme = true;
  List scheddata = [];
  List mylist =  [];
  int _selectedIndex = -1;
  bool selected;
  String clinicid = "";
  bool getsch = true;

  var _isDark;
  @override
  void initState() {
    _isDark = Prefs.getBool(Prefs.DARKTHEME, def: false);
    super.initState();
    AppVar.sclinicname = "";
    _calendarController = CalendarController();
    _eventController = TextEditingController();
    _events = {};
    _selectedEvents = [];
    getsch = true;

  }



  getSchedcal(String clinicid) async{
    print(clinicid.toString());
    mylistcal.clear();
    datesData.clear();
    setState(() {
      loadme = true;
    });
    _events = {};
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + clinicid + "/periods/";
    final response = await http.get(url,headers: headers);

   if(response.statusCode == 200){
     var jsondata = json.decode(response.body);
     print(jsondata.toString());

     var tagObjsJson = jsonDecode(response.body) as List;
     setState(() {
       mylistcal = tagObjsJson;
     });
     for(int i = 0; i < mylistcal.length; i++) {
       setState(() {
         datesData.add(mylistcal[i]);
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
            child: Text("Select Clinic"),
          ),
          Container(
            height: 10,
          ),
          //CircularProgressIndicator()
        ],
      );
    }else{
      return TableCalendar(

        events: _events,

        initialCalendarFormat: CalendarFormat.twoWeeks,
        calendarStyle: CalendarStyle(
            canEventMarkersOverflow: true,
            todayColor: Colors.orange,
            selectedColor: Theme.of(context).primaryColor,
            todayStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white)),
        headerStyle: HeaderStyle(
          centerHeaderTitle: true,
          formatButtonDecoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20.0),
          ),
          formatButtonTextStyle: TextStyle(color: Colors.white),
          formatButtonShowsNext: false,
        ),
        startingDayOfWeek: StartingDayOfWeek.sunday,
        onDaySelected: (date, events, _) {
          setState(() {
            onSelect(date);
            //_selectedEvents = events;

            //AppVar.periodid = events[0].toString();

            /* print(AppVar.periodid);
                    Navigator.of(context).pushNamed(Routes.bookingStep4);*/
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
                  color: Colors.orange,
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

  mydays(String dy){
    if(dy == '0'){
      return Text(
        "Monday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '1'){
      return Text(
        "Tuesday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '2'){
      return Text(
        "Wednesday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '3'){
      return Text(
        "Thursday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '4'){
      return Text(
        "Friday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '5'){
      return Text(
        "Saturday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }
    if(dy == '6'){
      return Text(
        "Sunday",
        style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w600),
      );
    }

  }
  shedday(String dy, startd, stopd, ctyp){
    DateTime ststart =  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").parse(startd);
    DateTime ststop =  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z").parse(stopd);
    var dt = ststart.hour;
    var min = ststart.minute;
    var dts = ststop.hour;
    var mins = ststop.minute;

    String amd = dt.toString() + ":" + min.toString();
    String pmd = dts.toString() + ":" + mins.toString();

    if(dy == '0'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              'Monday',
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '1'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Tuesday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '2'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Wednesday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '3'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Thursday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '4'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Friday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '5'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Saturday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }
    if(dy == '6'){
      return Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "Sunday",
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Container(width: 20,),
          Row(
            children: <Widget>[
              Text(
                amd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(" - "),
              Text(
                pmd,
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Container(width: 20,),
          Expanded(
            child: Text(
              ctyp,
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      );
    }

  }


  Future<List<Sched>> getSched(String sh) async{
    List<Sched> sched = [];
    setState(() {
      sched = [];
    });
    print("you call me");
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/" + clinicid + "/schedule/slots/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    print(jsondata.toString());




   if(response.statusCode == 200){
     for (var u in jsondata){
       String id,schedid,daym,start,stopday,ctype;

       if(u['id'].toString() == null){
         id = "none";
       }else{
         id = u['id'].toString();
       }
       if(u['schedule_id'].toString() == null){
         schedid = "none";
       }else{
         schedid = u['schedule_id'].toString();
       }
       if(u['day'].toString() == null){
         daym = "none";
       }else{
         daym = u['day'].toString();
       }
       if(u['start_time'].toString() == null){
         start = "none";
       }else{
         start = u['start_time'].toString();
       }
       if(u['end_time'].toString() == null){
         stopday = "none";
       }else{
         stopday = u['end_time'].toString();
       }
       if(u['consultation_type']['name'].toString() == null){
         ctype = "none";
       }else{
         ctype = u['consultation_type']['name'].toString();
       }

       Sched sch = Sched(id,schedid,daym,start,stopday,ctype);

       sched.add(sch);
     }
   }


    print(sched.length.toString());
    return sched;

  }


  Future<List<Doctor>> getclinics() async{
    List<Doctor> doctor = [];
    String sample = AppVar.docid;
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




 /* Widget _slot(String time, int slots, String hour) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            text: TextSpan(
              children: [

                TextSpan(
                  text: '$time ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '$slots ${'slots'.tr().toLowerCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: '$time ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 15,
        ),
        StaggeredGridView.countBuilder(
          padding: EdgeInsets.symmetric(horizontal: 10),
          crossAxisCount: 4,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: slots,
          staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemBuilder: (context, index) {
            return TimeSlotItem(
              time: hour,
              onTap: () {
                Navigator.of(context).pushNamed(Routes.bookingStep4);
              },
            );
          },
        ),
      ],
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppVar.docname),
      ),
      body: SingleChildScrollView(
        //scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
                width: double.infinity,
                height: 85,
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                ),
                color: Prefs.getBool(Prefs.DARKTHEME, def: false)
                    ? Colors.white.withOpacity(0.12)
                    : Colors.grey[300],
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
                          padding: EdgeInsets.symmetric(horizontal: 20),

                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              child: Container(
                                //child: Text(snapshot.data[index].start_time),
                                child: GestureDetector(
                                  onTap: (){



                                        clinicid = snapshot.data[index].clinicid;
                                        AppVar.sclinic =  snapshot.data[index].clinicid;
                                        AppVar.sclinicname = snapshot.data[index].name;

                                        getSched(clinicid);


                                    _selectedIndex = index;


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
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  AppVar.sclinicname,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isDark ? kColorBlue : Colors.black54
                  ),
                ),
              ),
            ),

            Divider(
              color: Colors.grey,
              height: 1,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 10,
            ),
            //Sched monday to
            mycl(),

            Divider(
              color: Colors.grey,
              height: 1,
              indent: 15,
              endIndent: 15,
            ),
            SizedBox(
              height: 10,
            ),

            Container(
              //color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: CustomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchClin(),
                    ),
                  );
                },
                text: 'Book Now'.tr(),
              ),
            ),



          ],
        ),
      ),
    );
  }
  mycl(){

      return Container(
          width: double.infinity,
          height: 300,
          padding: EdgeInsets.symmetric(
            vertical: 10,
          ),
          color: Prefs.getBool(Prefs.DARKTHEME, def: false)
              ? Colors.white.withOpacity(0.12)
              : Colors.white,
          child: FutureBuilder(
              future: getSched(clinicid),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.data == null) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Text("Select Clinic"),
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
//                                      scrollDirection: Axis.vertical,
//                                      padding: EdgeInsets.symmetric(horizontal: 20),

                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Container(
                          //child: Text(snapshot.data[index].start_time),
                          child: GestureDetector(
                              onTap: (){

                              },
                              child: Column(
                                children: <Widget>[
//                                                  Center(
//                                                    child: shedday(snapshot.data[index].daym,snapshot.data[index].start_time,snapshot.data[index].stop_time,snapshot.data[index].ctype),
//
//                                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          snapshot.data[index].daym,
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(width: 20,),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].start_time,
                                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(" - "),
                                          Text(
                                            snapshot.data[index].stop_time,
                                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Container(width: 20,),
                                      Expanded(
                                        child: Text(
                                          snapshot.data[index].ctype,
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
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

  mycalendarv(){
    return Container(
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

        ],
      ),
    );
  }

  onSelect(data) {
    setState(() {
      datesData.clear();
    });
    print("Selected Date -> $data");


    for(int i = 0; i < mylistcal.length; i++){
      DateTime mydt;
      if(mylistcal[i]['date'] == null){
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateTime.now()));
      }else{
        mydt = DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat("yyyy-MM-dd").parse(mylistcal[i]['date'])));
      }

      if(DateTime.parse(DateFormat('yyyy-MM-dd').format(data)) == DateTime.parse(DateFormat('yyyy-MM-dd').format(mydt))){
        setState(() {
          datesData.add(mylistcal[i]);
        });
      }
    }
    dtme = mylistcal.length;
  }

  mydataview(){
    if (dtme == 0){
      return Container(

        padding: const EdgeInsets.fromLTRB(10, 70, 10, 20),
        child: Center(
          child: Column(
            children: <Widget>[
              //Image.asset('images/truckgif.gif'),

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
                AppVar.periodid = id;
                AppVar.periodtype = "On-Site Consultation";
                AppVar.perioddt = mo + " " + dt + " " + starttime;
                print(event);
                Navigator.of(context).pushNamed(Routes.bookingStep4);
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
                Navigator.of(context).pushNamed(Routes.bookingStep4);
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
}


class Doctor{
  final String name;
  final String desc;
  final String clinicid;

  Doctor(this.name, this.desc, this.clinicid);
}

class Sched{
  final String id;
  final String schedule_id;
  final String daym;
  final String start_time;
  final String stop_time;
  final String ctype;

  Sched(this.id, this.schedule_id,this.daym , this.start_time,this.stop_time,this.ctype);
}