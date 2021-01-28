import 'dart:ffi';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/pages/visit/consultview.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/custom_profile_item.dart';
import '../../routes/routes.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qoremed_app/pages/visit/emucert.dart';

class VisitPage extends StatefulWidget {

  @override
  _VisitPageState createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage>
    with AutomaticKeepAliveClientMixin<VisitPage> {

  TextEditingController remarks = new TextEditingController();

  Future<List<Consult>> getConsult() async{
    print("Fetching Consultation");
    List<Consult> cons = [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/"+ AppVar.patient_id + "/encounters/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];


    print(jsondata.toString());

    for (var u in jsondata){
      String id,docid,date,hospital,hosimage,doctype,israted;


      if(u['id'] == null){
        id = "none";
      }else{
        id = u['id'];
      }
      //doctpr
      if(u['doctor']['profile']['full_name'] == null){
        docid = "none";
      }else{
        docid = u['doctor']['profile']['full_name'];
      }
      if(u['doctor']['doctor_type']['name'] == null){
        doctype = "none";
      }else{
        doctype = u['doctor']['doctor_type']['name'];
      }
      //date
      if(u['date']== null){
        date = "none";
      }else{
        date = u['date'];
      }
      if(u['is_rated'].toString()== 'true'){
        israted = "true";
      }else{
        israted = "false";
      }
      //clinic
      if(u['clinic']['name'] == null){
        hospital = "none";
      }else{
        hospital = u['clinic']['name'];
      }
      if(u['clinic']['photo_url'] == null){
        hosimage = "none";
      }else{
        hosimage = u['clinic']['photo_url'];
      }

      Consult consult = Consult(id,docid,date,hospital,hosimage,doctype,israted);

      cons.add(consult);


    }

    print(cons.length.toString());
    return cons;
  }


  @override
  void initState() {
    super.initState();


  }





  givenat(String dtn){
    DateTime dtme = DateFormat("yyyy-MM-dd").parse(dtn);
    String fn = dtme.day.toString() + "/" + dtme.month.toString() + "/" + dtme.year.toString();
    return Container(
      child: Text(
        'Given at ' + fn,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

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
          mon.toString() + " " + dt.toString(),
          style: Theme.of(context).textTheme.subtitle2.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),


      ],
    );
  }

  postrating(String rating,cid)async{
        double rt = double.parse(rating);
        String mrt = rt.toStringAsFixed(0);

        String rema = remarks.text;
        print(cid);
        print(rating);
        Map<String, String> headers = {
          "Accept": "application/json",
          'Authorization': 'Bearer ' + AppVar.token
        };
        String url = "https://qoremed.qoreit.com/api/patient/encounters/" + cid + "/rate";
        Map<String, String> body = {
          'rating' : mrt.toString(),
          'remarks' : rema,
        };
        final response = await http.post(url, headers: headers, body: body);

        print(response.body.toString());
  }
  getencounter(){
    return Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              widgetdt(snapshot.data[index].date),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0,0,0,0),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 25,
                                      backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
                                      child: Image.network(snapshot.data[index].hosimage),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].docid,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2
                                                .copyWith(fontWeight: FontWeight.w700),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            snapshot.data[index].hospital,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'NunitoSans',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Visibility(
                                            visible: true,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                givenat(snapshot.data[index].date),

                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          myrate(snapshot.data[index].id,snapshot.data[index].israted),



                                        ],
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),

                                        Center(
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConsultView(snapshot
                                                          .data[index]
                                                          .id,snapshot
                                                          .data[index]
                                                          .docid, snapshot
                                                          .data[index].date,
                                                          snapshot
                                                              .data[index]
                                                              .hospital,
                                                          snapshot
                                                              .data[index]
                                                              .hosimage,
                                                          snapshot
                                                              .data[index]
                                                              .doctype),
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.arrow_forward,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )

                        ],
                      ),
                    );
                  }
              );
            }
          }
      ),
    );
  }


  signaturedialog(String str1,str2) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Remarks'),
              content: Container(
                height: 150,
                child: Column(
                    children: <Widget>[
                      Container(
                          height: 100,
                          child: TextField(
                            controller: remarks,
                            maxLines: 2,
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.amber[800],
                        child: FlatButton(
                          onPressed: (){
                            postrating(str1,str2);
                            Navigator.of(context).pop();
                          },
                          child: Text("Rate Now", style: TextStyle(color: Colors.white),),
                        ),
                      )
                    ]
                ),
              )
          );
        }
    );

  }
  myrate(String rate,String rat){
    if(rat != 'true'){
      return Container(

      );
    }else {
      return Container(

        child: RatingBar(
          initialRating: 0,
          minRating: 1,
          itemSize: 30,
          unratedColor: Colors.white,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
         /* itemBuilder: (context, _) =>
              Icon(
                Icons.star,
                color: Colors.amber,
              ),*/
          onRatingUpdate: (rating) {
            print(rating);
            signaturedialog(rating.toString(), rate);
          },
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        child: Column(
          children: [

            getencounter(),
          ],
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
        label: Text('New Encounters', style: TextStyle(fontSize: 12),),
      ),
    );

  }

  @override
  bool get wantKeepAlive => false;
}


class Consult{
  final String id;
  final String docid;
  final String date;
  final String hospital;
  final String hosimage;
  final String doctype;
  final String israted;

  Consult(this.id, this.docid, this.date, this.hospital, this.hosimage,this.doctype,this.israted);
}

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  CalendarController _calendarController = CalendarController();
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

    showProgressDialog(context);

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/patients/"+ AppVar.patient_id + "/encounters/";
    Map<String, String> body = {
      "clinic_id": _mySelection,
      "date": date,
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
    String url = "https://qoremed.qoreit.com/api/clinics/";
    final response = await http.get(url, headers: headers);

    var jsondata = jsonDecode(response.body)['data'];
    print(jsondata.toString());

    var tagObjsJson = jsonDecode(response.body)['data'] as List;
    setState(() {
      mylist = tagObjsJson;
    });


    for (var u in jsondata) {
      setState(() {
        _currencies.add(u['name']);
      });
    }

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
              Text("Select Clinic and Date"),
             /* TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: ''),
              ),*/
              Container(

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
                    onDaySelected: (date, events,_) {
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