import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../../../components/doctor_item.dart';
import '../../../components/round_icon_button.dart';

import '../../../model/doctor.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';


class ChooseDoctorPage extends StatefulWidget {
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<ChooseDoctorPage> {
  Future<List> _getdata;

  void initState() {
    super.initState();
    _getdata = getDoctor();
  }

  Future<List<Doctor>> getDoctor() async{
    print("Fetching Doctors");
    print(AppVar.token);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url;
    if(AppVar.doctypecho == ""){
     url = "https://qoremed.qoreit.com/api/doctors/";
    }else{
      url = "https://qoremed.qoreit.com/api/doctors?search=" + AppVar.doctypecho;
    }

    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<Doctor> doctor = [];

    //if(response.statusCode == 200){
      print(jsondata.toString());

      for (var u in jsondata){
        String docid,names,gender,netimage,docspe,charge,average_rating;

        if(u['average_rating']== null){
          average_rating = "0";
        }else{
          average_rating = u['average_rating'];
        }
        if(u['id']== null){
          docid = "none";
        }else{
          docid = u['id'];
        }
        if(u['consultation_fee']== null){
          charge = "none";
        }else{
          charge = u['consultation_fee'];
        }

        if(u['profile']['full_name']== null){
          names = "none";
        }else{
          names = u['profile']['full_name'];
        }
        if(u['profile']['gender']== null){
          gender = "male";
        }else{
          gender = u['profile']['gender'];
        }
        if(u['photo_url']== null){
          netimage = "none";
        }else{
          netimage = u['photo_url'];
        }

        if(u['doctor_type']['name']== null){
          docspe = "none";
        }else{
          docspe = u['doctor_type']['name'];
        }

        Doctor doctors = Doctor(docid,names,gender,netimage,docspe,charge,average_rating);

        doctor.add(doctors);


      }
    //}



    print(doctor.length.toString());
    return doctor;
  }

  docavatar(String image, netimage){
    if(netimage == "none"){
      if(image == "female"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_2.png'),
        );
      }if(image == "male"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
        );
      }
    }else
    {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
        child: Image.network(netimage),
      );
    }

//return Image.network(netimage);
  }
  iconfav(String val){
    var one = int.parse(val);
    if(one > 0) {
      return Icon(
        Icons.star,
        color: Colors.amber,
        size: 18,
      );
    }else{
      return Icon(
        Icons.star_border,
        color: Colors.amber,
        size: 18,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'doctor'.tr(),
        ),

      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //scrollDirection: Axis.vertical,
        child: Container(
          child: FutureBuilder(
              future: _getdata,
              builder: (BuildContext context, AsyncSnapshot snapshot){
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
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.symmetric(horizontal: 20),

                      itemBuilder: (context, index){
                        return Card(
                          child: GestureDetector(
                            onTap: (){
                              print(snapshot.data[index].docid);
                                AppVar.docid = snapshot.data[index].docid;
                                AppVar.docname = snapshot.data[index].name;
                                AppVar.docimg =  snapshot.data[index].netimg;
                                AppVar.doctype = snapshot.data[index].docspe;
                                AppVar.doccharge = snapshot.data[index].charge;

                                Navigator.of(context).pushNamed(Routes.bookingStep3);

                            },
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  children: <Widget>[
                                    docavatar(snapshot.data[index].gender, snapshot.data[index].netimg),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  snapshot.data[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle2
                                                      .copyWith(fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                              iconfav(snapshot.data[index].average_rating),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data[index].average_rating,
                                                style: Theme.of(context).textTheme.bodyText2.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            'Specialist',
                                            style: TextStyle(
                                              color: Colors.grey[350],
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.data[index].docspe,
                                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
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
    );
  }
}
class Doctor{
  final String docid;
  final String name;
  final String gender;
  final String netimg;
  final String docspe;
  final String charge;
  final String average_rating;

  Doctor(this.docid,this.name, this.gender, this.netimg,this.docspe,this.charge,this.average_rating);
}

//Navigator.of(context).pushNamed(Routes.bookingStep3);