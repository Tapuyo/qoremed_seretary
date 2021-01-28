import 'package:flutter/material.dart';

import 'package:qoremed_app/components/custom_button.dart';
import 'package:qoremed_app/components/custom_outline_button.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/pages/appointment/appointment_detail_page.dart';
import 'dart:convert';


class HistoryAppointmentsPage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HistoryAppointmentsPage>{

  bool visible1 = true;

  void initState() {
    super.initState();

  }


  Future<List<Appoint>> getSched() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<Appoint> appoint = [];

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,docname,appdate,docimg,special,hostpital,name,status,consult,ref;


      if(u['id'].toString() == null){
        appid = "none";
      }else{
        appid = u['id'].toString();
      }
      if(u['reference_no'].toString() == null){
        ref = "none";
      }else{
        ref = u['reference_no'].toString();
      }
      if(u['appointable']['doctor']['profile']['full_name'] == null){
        docname = "none";
      }else{
        docname = u['appointable']['doctor']['profile']['full_name'] ;
      }
      if(u['date'] == null){
        appdate = "none";
      }else{
        appdate = u['date'];
      }
      if(u['appointable']['doctor']['photo_url'] == null){
        docimg = "none";
      }else{
        docimg = u['appointable']['doctor']['photo_url'];
      }
      if(u['appointable']['doctor']['doctor_type']['name'] == null){
        special = "none";
      }else{
        special = u['appointable']['doctor']['doctor_type']['name'];
      }

      if(u['appointable']['name'] == null){
        hostpital = "none";
      }else{
        hostpital = u['appointable']['name'];
      }
      if(u['client']['profile']['full_name'] == null){
        name = "none";
      }else{
        name = u['client']['profile']['full_name'];
      }

      if(u['status'] == null){
        status = "none";
      }else{
        status = u['status'];
      }

      if(u['period']['consultation_type']['name'] == null){
        consult = "none";
      }else{
        consult = u['period']['consultation_type']['name'];
      }

      if(status == "cancelled") {
        Appoint apps = Appoint(
            appid,
            docname,
            appdate,
            docimg,
            special,
            hostpital,
            name,
            status,
            consult,
             ref
        );

        appoint.add(apps);
      }
      if(status == "completed") {
        Appoint apps = Appoint(
            appid,
            docname,
            appdate,
            docimg,
            special,
            hostpital,
            name,
            status,
            consult,
            ref
        );

        appoint.add(apps);
      }



    }
    if(appoint.length > 0){
      setState(() {
        visible1 = true;
      });
    }
    else
    {
      setState(() {
        visible1 = false;
      });
    }
    print(appoint.length.toString());
    return appoint;
  }




  @override
  Widget build(BuildContext context) {
    /* return Container(
     padding: EdgeInsets.all(20.0),
     child: Column(
       children: <Widget>[

         Card(
           child: Row(
             children: <Widget>[
               Expanded(
                 flex: 2,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     SizedBox(
                       height: 20,
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 15),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(
                                     "title",
                                     style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14,
                                       fontWeight: FontWeight.w400,
                                     ),
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   Text(
                                     "subtitle",
                                     style: Theme.of(context)
                                         .textTheme
                                         .subtitle1
                                         .copyWith(fontWeight: FontWeight.w500),
                                   ),
                                 ],
                               )
                           ),
                           SizedBox(
                             width: 10,
                           ),
                           Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(
                                     "title",
                                     style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14,
                                       fontWeight: FontWeight.w400,
                                     ),
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   Text(
                                     "subtitle",
                                     style: Theme.of(context)
                                         .textTheme
                                         .subtitle1
                                         .copyWith(fontWeight: FontWeight.w500),
                                   ),
                                 ],
                               )
                           ),
                         ],
                       ),
                     ),
                     SizedBox(
                       height: 15,
                     ),
                     Divider(
                       height: 1,
                       thickness: 1,
                       indent: 10,
                       endIndent: 10,
                     ),

                   ],
                 ),
               ),
               SizedBox(
                 width: 10,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(right: 15),
                   child: Column(
                     children: <Widget>[
                       Container(
                         width: double.infinity,
                         child: CustomButton(
                           text: 'Edit',
                           textSize: 14,
                           onPressed: () {},
                           padding: EdgeInsets.symmetric(
                             vertical: 10,
                           ),
                         ),
                       ),
                       SizedBox(
                         height: 25,
                       ),
                       Container(
                         width: double.infinity,
                         child: CustomOutlineButton(
                           text: 'Cancel',
                           textSize: 14,
                           onPressed: () {},
                           padding: EdgeInsets.symmetric(
                             vertical: 10,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               )
             ],
           ),
         ),
         Card(
           child: Row(
             children: <Widget>[
               Expanded(
                 flex: 2,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: <Widget>[
                     SizedBox(
                       height: 20,
                     ),
                     Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 15),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: <Widget>[
                           Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(
                                     "title",
                                     style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14,
                                       fontWeight: FontWeight.w400,
                                     ),
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   Text(
                                     "subtitle",
                                     style: Theme.of(context)
                                         .textTheme
                                         .subtitle1
                                         .copyWith(fontWeight: FontWeight.w500),
                                   ),
                                 ],
                               )
                           ),
                           SizedBox(
                             width: 10,
                           ),
                           Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: <Widget>[
                                   Text(
                                     "title",
                                     style: TextStyle(
                                       color: Colors.grey,
                                       fontSize: 14,
                                       fontWeight: FontWeight.w400,
                                     ),
                                     maxLines: 1,
                                     overflow: TextOverflow.ellipsis,
                                   ),
                                   Text(
                                     "subtitle",
                                     style: Theme.of(context)
                                         .textTheme
                                         .subtitle1
                                         .copyWith(fontWeight: FontWeight.w500),
                                   ),
                                 ],
                               )
                           ),
                         ],
                       ),
                     ),
                     SizedBox(
                       height: 15,
                     ),
                     Divider(
                       height: 1,
                       thickness: 1,
                       indent: 10,
                       endIndent: 10,
                     ),

                   ],
                 ),
               ),
               SizedBox(
                 width: 10,
               ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(right: 15),
                   child: Column(
                     children: <Widget>[
                       Container(
                         width: double.infinity,
                         child: CustomButton(
                           text: 'Edit',
                           textSize: 14,
                           onPressed: () {},
                           padding: EdgeInsets.symmetric(
                             vertical: 10,
                           ),
                         ),
                       ),
                       SizedBox(
                         height: 25,
                       ),
                       Container(
                         width: double.infinity,
                         child: CustomOutlineButton(
                           text: 'Cancel',
                           textSize: 14,
                           onPressed: () {},
                           padding: EdgeInsets.symmetric(
                             vertical: 10,
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
               )
             ],
           ),
         ),
       ],
     )
   );*/
    return Container(
      child: Visibility(
        visible: visible1,
        child: Container(
          padding: EdgeInsets.all(20.0),
          height: 160,
          child: FutureBuilder(
              future: getSched(),
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

                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Doctor",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  snapshot.data[index].docname,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            )
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Patient",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  snapshot.data[index].name,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Consulation",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  snapshot.data[index].consult,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            )
                                        ),
                                        Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Clinic",
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "Malolos Clinic",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1
                                                      .copyWith(fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      child: CustomButton(
                                        text: 'View',
                                        textSize: 14,
                                        onPressed: () {
                                          /*Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => Getque(snapshot.data[index].appid),
                                          ),
                                        );*/


                                          AppVar.docname = snapshot.data[index].docname;
                                          AppVar.nxtdt = snapshot.data[index].appdate;
                                          AppVar.nxtdocsp = snapshot.data[index].special;
                                          AppVar.nxtid = snapshot.data[index].appid;
                                          AppVar.nxthospital = snapshot.data[index].hospital;
                                          AppVar.nxtname = snapshot.data[index].name;
                                          AppVar.nxtstatus = snapshot.data[index].status;
                                          AppVar.nxtconsult = snapshot.data[index].consult;
                                          AppVar.nxtref = snapshot.data[index].ref;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AppointmentDetailPage(snapshot.data[index].appid),
                                            ),
                                          );
                                        },
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                   /* Container(
                                      width: double.infinity,
                                      child: CustomOutlineButton(
                                        text: 'Cancel',
                                        textSize: 14,
                                        onPressed: () {},
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10,
                                        ),
                                      ),
                                    ),*/
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }


              }
          ),
        ),
      ),
    );
  }


}

class Appoint{
  final String appid;
  final String docname;
  final String appdate;
  final String docimg;
  final String special;
  final String hospital;
  final String name;
  final String status;
  final String consult;
  final String ref;

  Appoint(this.appid, this.docname, this.appdate,this.docimg,this.special,this.hospital,this.name,this.status,this.consult,this.ref);
}
