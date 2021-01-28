import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/pages/appointment/getque.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/pages/visit/clinicalabs.dart';
import 'package:qoremed_app/pages/visit/emucert.dart';
import 'package:qoremed_app/pages/visit/medicalclearance.dart';
import 'package:qoremed_app/pages/visit/prescription.dart';
import 'package:qoremed_app/pages/visit/testrequest.dart';

class ConsultView extends StatefulWidget {
  String id,docid,date,hospital,hosimage,doctype;

  ConsultView(this.id,this.docid,this.date,this.hospital,this.hosimage,this.doctype);

  @override
  State<StatefulWidget> createState() {
    return _VisitDetailPageState(this.id,this.docid,this.date,this.hospital,this.hosimage,this.doctype);
  }
}

class _VisitDetailPageState extends State<ConsultView> {

  String id,docid,date,hospital,hosimage,doctype;

  _VisitDetailPageState(this.id,this.docid,this.date,this.hospital,this.hosimage,this.doctype);


  @override
  void initState() {
    super.initState();
    getConsult();
  }
  Future<List<Consult>> getConsult() async{
    print("Fetching Consultation");
    List<Consult> cons = [];
    print("https://qoremed.qoreit.com/api/patient/"+ AppVar.patient_id + "/encounters/" + id);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/"+ AppVar.patient_id + "/encounters/" + id;
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['emrables'];


    print(jsondata.toString());

    for (var u in jsondata){
      String encounter_id,emrable_type,emrable_id;


      if(u['encounter_id'] == null){
        encounter_id = "none";
      }else{
        encounter_id = u['encounter_id'];
      }

      if(u['emrable_type'] == null){
        emrable_type = "none";
      }else{
        emrable_type = u['emrable_type'];
      }

      if(u['emrable_id'] == null){
        emrable_id = "none";
      }else{
        emrable_id = u['emrable_id'];
      }


      Consult consult = Consult(encounter_id,emrable_type,emrable_id);

      cons.add(consult);


    }

    print(cons.length.toString());
    return cons;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'visit_detail'.tr(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                // padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(4),
                //   border: Border.all(width: 1, color: Colors.grey[200]),
                // ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 25,
                            backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
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
                                  docid,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  doctype,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'NunitoSans',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(
                        height: 1,
                        color: Colors.grey[200],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.calendar_today,
                              color: Colors.grey[300],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Text(
                                date,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.grey[300],
                            ),
                            SizedBox(
                              width: 25,
                            ),
                            Expanded(
                              child: Text(
                                hospital,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              mywidget(),
            ],
          ),
        ),
      ),
    );
  }

  mywidget(){
    return Container(
      child: Container(
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

                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data[index].emrable_type,
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
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: (){
                                    if(snapshot.data[index].emrable_type == "App\\MedicalCertificate"){
                                      print("App\\MedicalCertificate");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EmuCert(snapshot.data[index].emrable_id,snapshot.data[index].encounter_id),
                                        ),
                                      );
                                    }
                                    if(snapshot.data[index].emrable_type == "App\\MedicalClearance"){
                                      print("App\\MedicalClearance");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MedClearance(snapshot.data[index].emrable_id,snapshot.data[index].encounter_id),
                                        ),
                                      );
                                    }
                                    if(snapshot.data[index].emrable_type == "App\\ClinicalAbstract"){
                                      print("App\\ClinicalAbstract");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ClinicAbs(snapshot.data[index].emrable_id,snapshot.data[index].encounter_id),
                                        ),
                                      );
                                    }
                                    if(snapshot.data[index].emrable_type == "App\\Prescription"){
                                      print("App\\Prescription");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PresCrep(snapshot.data[index].emrable_id,snapshot.data[index].encounter_id),
                                        ),
                                      );
                                    }
                                    if(snapshot.data[index].emrable_type == "App\\TestRequest"){
                                      print("App\\TestRequest");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TestReq(snapshot.data[index].emrable_id,snapshot.data[index].encounter_id),
                                        ),
                                      );
                                    }

                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[

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
    );
  }
}
class Consult{
  final String encounter_id;
  final String emrable_type;
  final String emrable_id;


  Consult(this.encounter_id, this.emrable_type, this.emrable_id);
}