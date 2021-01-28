import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qoremed_app/pages/examination/vital_details.dart';
import 'package:qoremed_app/utils/constants.dart';
import '../../components/custom_profile_item.dart';
import 'package:qoremed_app/pages/examination/newvital.dart';

class ExaminationPage extends StatefulWidget {
  @override
  _ExaminationPageState createState() => _ExaminationPageState();
}

class _ExaminationPageState extends State<ExaminationPage>
    with AutomaticKeepAliveClientMixin<ExaminationPage> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<List<Vitals>> getVitals() async{
    List<Vitals> doctor = [];

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/" + AppVar.patient_id + "/vitals/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];

    print(response.body.toString());
    for (var u in jsondata){

      String vdate;
      if(u['date'] == null){
        vdate = "none";
      }else{
        vdate = u['date'];
      }

      Vitals doctors = Vitals(vdate);
      doctor.add(doctors);
    }

    print(doctor.length.toString());
    return doctor;
  }

  @override

  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
            future: getVitals(),
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
                                  radius: 20,
                                  child: Image.asset(
                                    'assets/images/icon_examination.png',
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
                                        snapshot.data[index].vdate,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        'Vitals Report',
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
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => VitalDetails(snapshot.data[index].vdate),
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
          // Respond to button press
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewVital(),
            ),
          );
        },
        label: Text('New Vital', style: TextStyle(fontSize: 12),),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;


}

class Vitals{
  final String vdate;


  Vitals(this.vdate);
}