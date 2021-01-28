import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qoremed_app/components/custom_button.dart';
import 'package:qoremed_app/components/my_doctor_list_item.dart';
import 'package:qoremed_app/model/doctor.dart';
import 'package:qoremed_app/pages/doctor/doctor_profile_page.dart';
import 'package:qoremed_app/pages/patient/patientprofile.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';

class MyDoctorListPage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyDoctorListPage>{
  Future<List<Patient>> getpatients() async{
    List<Patient> doctor = [];
    String sample = AppVar.did;
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];



    print(jsondata.toString());

    //if(response.statusCode == 200){
    for (var u in jsondata){
      String id,name,email,image;

      if(u['id'] == null){
        id = "none";
      }else{
        id = u['id'];
      }
      if(u['profile']['first_name'] == null){
        name = "none";
      }else{
        String lname = u['profile']['first_name'];
        name = u['profile']['first_name'] + " " +  lname[0];
      }
      if(u['contact']['email'] == null){
        email = "none";
      }else{
        email = u['contact']['email'];
      }
      if(u['photo_url']== null){
        image = "none";
      }else{
        image = u['photo_url'];
      }

      Patient doctors = Patient(id,name,email,image);

      doctor.add(doctors);
    }
    //}

    //print(doctor.length.toString());
    return doctor;
  }

  docavatar(String netimage){
    if(netimage == "none"){
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/person.png'),
      );
    }else
    {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        //backgroundImage: AssetImage('assets/images/person.png'),
        child:  ClipRRect(
          borderRadius: BorderRadius.circular(25.0),
          child: Image.network(
            netimage,
            height: 56.0,
            width: 56.0,
          ),
        ),
      );
    }

//return Image.network(netimage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Doctors'.tr(),
        ),
      /*  actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.library_add_check,
              //color: Colors.white,
            ),
            onPressed: () {

            },
          )
        ],*/
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20.0),
              child: FutureBuilder(
                  future: getpatients(),
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
                            return Card(
                              //padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Container(

                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    //color: Colors.white,
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
                                  child: GestureDetector(
                                    onTap: (){

                                    },
                                    child: Row(
                                      children: <Widget>[
                                        docavatar(snapshot.data[index].image),
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
                                                  snapshot.data[index].email,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
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
                                            /*  AppVar.patient_id = snapshot.data[index].id;
                                              AppVar.patient_name = snapshot.data[index].name;
                                              AppVar.patient_img = snapshot.data[index].image;
                                              AppVar.patient_email = snapshot.data[index].email;
                                              //PatientProfile
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => PatientProfile(snapshot.data[index].id),
                                                ),
                                              );*/
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

class Patient{
  final String id;
  final String name;
  final String email;
  final String image;

  Patient(this.id, this.name, this.email, this.image);
}