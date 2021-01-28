import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class VitalDetails extends StatefulWidget {
  String dt;

  VitalDetails(this.dt);
  @override
  _VitalsReport createState() => _VitalsReport(this.dt);
}

class _VitalsReport extends State<VitalDetails>
    with AutomaticKeepAliveClientMixin<VitalDetails> {
  String dt;

  _VitalsReport(this.dt);

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


    for (var u in jsondata){

      if(u['date'] == dt){
        String vdate,vvalue;

/*        if(u['date'] == null){
          vdate = "none";
        }else{
          vdate = u['date'];
        }*/



        print("Your vital at 2020-09-19" + u['items'].toString());

        var njs = u['items'];
        for (var x in njs){
          print(x['vital_type']['name'].toString() + " " + x['vital'].toString());
          vdate = x['vital_type']['name'].toString();
          vvalue = x['vital'].toString();
          Vitals doctors = Vitals(vdate,vvalue);
          doctor.add(doctors);
        }



      }




    }

    print(doctor.length.toString());
    return doctor;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Vital Details',
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(dt, style: TextStyle(color: Colors.black45, fontSize: 15),)),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
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
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              snapshot.data[index].vdate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            /* Text(
                                              snapshot.data[index].vvalue,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontWeight: FontWeight.w700),
                                            ),*/
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 10,
                                            ),
                                            /* Text(
                                              snapshot.data[index].vdate,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontWeight: FontWeight.w700),
                                            ),*/
                                            Text(
                                              snapshot.data[index].vvalue,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            SizedBox(
                                              height: 20,
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
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;


}

class Vitals{
  final String vdate;
  final String vvalue;


  Vitals(this.vdate,this.vvalue);
}