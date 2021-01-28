import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/pages/test/labimage.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/custom_profile_item.dart';
import 'package:qoremed_app/myvars.dart';


class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage>
    with AutomaticKeepAliveClientMixin<TestPage> {

  Future<List<Lab>> getConsult() async{
    print("Fetching Consultation");
    List<Lab> lab = [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/" + AppVar.patient_id + "/lab-results/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];


    print(jsondata.toString());

    for (var u in jsondata){
      String name,remarks,date,laba,ur;

      if(u['name'] == null){
        laba = "none";
      }else{
        laba = u['name'];
      }
      if(u['lab_type']['name'] == null){
        name = "none";
      }else{
        name = u['lab_type']['name'];
      }
      if(u['remarks'] == null){
        remarks = "none";
      }else{
        remarks = u['remarks'];
      }
      if(u['date']== null){
        date = "none";
      }else{
        date = u['date'];
      }
      if(u['media']['url']== null){
        ur = "none";
      }else{
        ur = u['media']['url'];
      }

      Lab consult = Lab(name,remarks,date,laba,ur);

      lab.add(consult);


    }


    print(lab.length.toString());
    return lab;
  }

  givenat(String dtn){
    DateTime dtme = DateFormat("yyyy-MM-dd").parse(dtn);
    String fn = dtme.day.toString() + "/" + dtme.month.toString() + "/" + dtme.year.toString();
    return Container(
      child:  Text(
        fn,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'NunitoSans',
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
            future: getConsult(),
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
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 25,
                                  child: Image.asset(
                                    'assets/images/icon_medical_check_up.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].lab,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        snapshot.data[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      givenat(snapshot.data[index].date),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        snapshot.data[index].remarks,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'NunitoSans',
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),



                                      /*  Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'See reports',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(fontSize: 14),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                              Icons.arrow_forward,
                                            ),
                                          ],
                                        ),*/
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    print(snapshot.data[index].ur);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => LabImage( snapshot.data[index].ur),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                      ),
                                    ],
                                  ),
                                ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kColorBlue,
        foregroundColor: Colors.white,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return MyDialog();
            },
          );
        },
        label: Text('New Lab Result', style: TextStyle(fontSize: 12),),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;



  @override
  void initState() {
    super.initState();
  }
}
class Lab{
  final String name;
  final String remarks;
  final String date;
  final String lab;
  final String ur;

  Lab(this.name, this.remarks, this.date,this.lab,this.ur);
}


class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  CalendarController _calendarController = CalendarController();
  TextEditingController mylab = new TextEditingController();
  TextEditingController myrem = new TextEditingController();
  List mylist =   List();
  String dateselect = "";
  String _mySelection;
  var _currencies = [
    "Food",
    "Transport",
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
    String labname = mylab.text;
    String remarks = myrem.text;

    print(_mySelection + "|" + labname + "|" + remarks + "|" + date);

    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/patients/" + AppVar.patient_id + "/lab-results/";
    Map<String, String> body = {
      "lab_type_id": _mySelection,
      "name": labname,
      "date": date,
      "remarks": remarks,
    }; //
    final response = await http.post(url, headers: headers, body: body);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      print("save naaaahhhhhhhhhhhhhh");
      Navigator.pop(context);

    }else{
      print("EROROROROROROROROOOOOOOOOOOOOOOOOOOORR");
      Navigator.pop(context);
    }
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    getSched();
    //getConsult();
    dateselect = DateTime.now().month.toString() + "/" + DateTime.now().day.toString() + "/" + DateTime.now().year.toString();
  }




  getSched() async {
    _currencies.clear();
    print("Doctor ID " + AppVar.docid);
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/references/lab-types/";
    final response = await http.get(url, headers: headers);

    var jsondata = jsonDecode(response.body);
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

  _onpick()async{

  }



  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20.0)), //this right here
      child: Container(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(

            children: [
              Text("Select Clinic and Date"),
              /* TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ''),
              ),*/
              Container(
                height: 50,
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
              ),
               TextField(
                 controller: mylab,
                 decoration: new InputDecoration(
                     hintText: "Laboratory Name",
                     labelStyle: new TextStyle(
                         color: const Color(0xFF424242)
                     )
                 ),
              ),
              Container(

                  child: TableCalendar(
                    headerVisible: true,
                    initialCalendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                        canEventMarkersOverflow: true,
                        todayColor: Colors.orange,
                        selectedColor: Theme.of(context).primaryColor,
                        todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                            color: Colors.white)),
                    headerStyle: HeaderStyle(
                        centerHeaderTitle: false,
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        formatButtonShowsNext: false,
                        titleTextStyle: TextStyle(fontSize: 12)
                    ),
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    onDaySelected: (date, events, _) {
                      setState(() {
                        print(date);
                        dateselect =  date.month.toString() + "/" + date.day.toString() + "/" + date.year.toString();
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
                  )
              ),
              TextField(
                controller: myrem,
                decoration: new InputDecoration(
                    hintText: "Remarks",
                    labelStyle: new TextStyle(
                        color: const Color(0xFF424242)
                    )
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    width: 150.0,
                    child: RaisedButton(
                      onPressed: () {
                        _onpick();
                      },
                      child: Text(
                        "Upload File",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: kColorBlue,
                    ),
                  ),
                  Container(
                    width: 50.0,

                  ),
                ],
              ),
              SizedBox(height: 20,),
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