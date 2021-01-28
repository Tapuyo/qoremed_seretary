import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/components/custom_button.dart';
import 'package:qoremed_app/components/custom_outline_button.dart';
import 'package:qoremed_app/pages/clinics/clinicdetails.dart';
import 'package:qoremed_app/utils/constants.dart';
import '../../components/upcoming_appointment_list_item.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/pages/appointment/getque.dart';
import 'package:qoremed_app/pages/appointment/appointment_detail_page.dart';
import 'dart:convert';

class ClinicList extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ClinicList>{

  bool visible1 = true;

  void initState() {
    super.initState();

  }

  Future<List<Doctor>> getclinics() async{
    List<Doctor> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/clinics/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];



    print(jsondata.toString());

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String names,desc,clinicid,clinicimg;

      if(u['photo_url'] == null){
        clinicimg = "none";
      }else{
        clinicimg = u['photo_url'];
      }
      if(u['name'] == null){
        names = "none";
      }else{
        names = u['name'];
      }
      if(u['address']['full_address'] == null){
        desc = "none";
      }else{
        desc = u['address']['full_address'];
      }
      if(u['id']== null){
        clinicid = "none";
      }else{
        clinicid = u['id'];
      }

      Doctor doctors = Doctor(names,desc,clinicid,clinicimg);

      doctor.add(doctors);
    }
    //}

    print(doctor.length.toString());
    return doctor;
  }

  docavatar(String netimage){
    if(netimage == "none"){
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/clinic.png'),
      );
    }else
    {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/clinic.png'),
        child: Image.network(netimage),
      );
    }

//return Image.network(netimage);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My Clinics"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.library_add_check,
              //color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
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
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
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

                                  ],
                                  child: GestureDetector(
                                    onTap: (){

                                    },
                                    child: Row(
                                      children: <Widget>[
                                        docavatar(snapshot.data[index].clinicimg),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          child: Container(

                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  snapshot.data[index].name,
                                                  style: TextStyle(
                                                    color: kColorPrimaryDark,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data[index].desc,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FlatButton(
                                          color: kColorBlue,
                                          shape: RoundedRectangleBorder(

                                              borderRadius: BorderRadius.circular(18.0),
                                              side: BorderSide(color: Colors.white)
                                          ),
                                          onPressed: () {

                                              Navigator.push(context,MaterialPageRoute(builder: (context) => ClinicDetails(snapshot.data[index].clinicid,snapshot.data[index].name,snapshot.data[index].desc,snapshot.data[index].clinicimg),),);
                                          },
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 5,
                                          ),
                                          child: Text("Details",style: TextStyle(fontSize: 12,color: Colors.white),),
                                        )
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


}

class Doctor{
  final String name;
  final String desc;
  final String clinicid;
  final String clinicimg;

  Doctor(this.name, this.desc, this.clinicid, this.clinicimg);
}