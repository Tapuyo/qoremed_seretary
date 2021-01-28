import 'package:flutter/services.dart';
import 'package:qoremed_app/components/custom_button.dart';
import 'package:qoremed_app/components/my_doctor_list_item.dart';
import 'package:qoremed_app/model/doctor.dart';
import 'package:qoremed_app/pages/notifications/notdetails.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotifPage extends StatefulWidget {

  @override
  _notifPage createState() => _notifPage();
}

class _notifPage extends State<NotifPage> {

  Future getn;


  @override
  void initState() {
    super.initState();
    getn = getNotif();
  }

  booknow(String notid)async{

    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/notifications/" + notid + "/";
    final response = await http.delete(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    if(response.statusCode == 200){
      setState(() async{
        getn;
        AppVar.notifnum = AppVar.notifnum - 1;
      });
    }else{

    }
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

  Future<List<Doctor>> getNotif() async{
    List<Doctor> doctor = [];
    print("Fetching Doctors");
    print(AppVar.token);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/notifications/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];


    print(jsondata.toString());

    for (var u in jsondata){
      String appid,apptype,names,gender,netimage;

      if(u['data']['appointment_id'] == null){
        appid = "none";
      }else{
        appid = u['data']['appointment_id'];
      }
      if(u['type'] == null){
        apptype = "none";
      }else{
        apptype = u['type'];
      }

      if(u['data']['title'] == null){
        names = "none";
      }else{
        names = u['data']['title'];
      }
      if(u['data']['message']== null){
        gender = "none";
      }else{
        gender = u['data']['message'];
      }
      if(u['id']== null){
        netimage = 'none';
      }else{
        netimage = u['id'];
      }

      if(u['read_at']== null){
        Doctor doctors = Doctor(appid,apptype,names,gender,netimage);

        doctor.add(doctors);
      }





    }

    print(doctor.length.toString());
    return doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications List',
        ),
      ),
      body:  Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        child: FutureBuilder(
            future: getn,
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
                    itemCount: snapshot.data.length,
                    //scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Container(
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,

                            secondaryActions: <Widget>[

                              IconSlideAction(
                                  caption: 'Delete',
                                  color: kColorBlue,
                                  icon: Icons.restore_from_trash,
                                  onTap: (){

                                    setState(() {
                                      booknow(snapshot.data[index].netimg);
                                    });

                                  }
                              ),
                            ],

                            child: GestureDetector(
                              onTap: (){
                                //if(snapshot.data[index].name == "App\\Notifications\\Doctor\\NewAppointment"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => NotDetails(snapshot.data[index].appid),
                                    ),
                                  );
                                //}
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 15, 0, 15),
                                color: Color(0xffEBF2F5),
                                child: Row(
                                  children: <Widget>[

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].name,
                                            style: TextStyle(
                                              color: kColorPrimaryDark,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            snapshot.data[index].gender,
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

                                  ],
                                ),
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
    );
  }
}
class Doctor{
  final String appid;
  final String apptype;
  final String name;
  final String gender;
  final String netimg;

  Doctor(this.appid,this.apptype,this.name, this.gender, this.netimg);
}