import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/routes/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../components/custom_circular_indicator.dart';
import '../../components/round_icon_button.dart';
import '../../myvars.dart';
import '../../utils/constants.dart';

class DoctorProfilePage extends StatefulWidget {
  String did;
  DoctorProfilePage(this.did);
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState(this.did);
}

class _PatientDetailsPageState extends State<DoctorProfilePage> {
  String did;
  _PatientDetailsPageState(this.did);

  String dooname,docspe,docnumber,docimg,charge;
  String tr1,tr2,tr3;
  String bloc1,bloc2,bloc3,bint1,bint2,bint3;
  String aff1,aff2,aff4;
  double average_rating,perc;


  @override
  void initState() {
    super.initState();
    getdoc();
    average_rating = 0;
    perc = 0;
    dooname = "";
    docspe = "";
    docnumber = "";
    docimg = "";
    charge = "";
    tr1 = "";
    tr2 = "";
    tr3 = "";
    bloc1 = "";
    bloc2 = "";
    bloc3 = "";
    bint1 = "";
    bint2 = "";
    bint3 = "";
    aff1 = "";
    aff2 = "";
    aff4 = "";
  }

  getdoc()async{
    List mylist =  [];
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors/" + did;
    final response = await http.get(url,headers: headers);
    print(response.body.toString());

    setState(() {
      if(jsonDecode(response.body)['profile']['full_name']!=null) {
        dooname = jsonDecode(response.body)['profile']['full_name'];
      }
      if(jsonDecode(response.body)['doctor_type']['name']!=null) {
        docspe = jsonDecode(response.body)['doctor_type']['name'];
      }
      if(jsonDecode(response.body)['contact']['phone_number'] != null){
        docnumber = jsonDecode(response.body)['contact']['phone_number'];
      }
      if(jsonDecode(response.body)['photo_url'] != null){
        docimg = jsonDecode(response.body)['photo_url'];
      }
      if(jsonDecode(response.body)['consultation_fee']!=null) {
        charge = jsonDecode(response.body)['consultation_fee'];
      }
      if(jsonDecode(response.body)['training_one'] != null){
      tr1 = jsonDecode(response.body)['training_one'];}
      if(jsonDecode(response.body)['training_two']!=null){
      tr2 = jsonDecode(response.body)['training_two'];}
      if(jsonDecode(response.body)['training_three']!=null){
      tr3 = jsonDecode(response.body)['training_three'];}
      if(jsonDecode(response.body)['board_one_local']!=null){
      bloc1 = jsonDecode(response.body)['board_one_local'];}
      if(jsonDecode(response.body)['board_two_local']!=null){
      bloc2 = jsonDecode(response.body)['board_two_local'];}
      if(jsonDecode(response.body)['board_three_local']!=null){
      bloc3 = jsonDecode(response.body)['board_three_local'];}
      if(jsonDecode(response.body)['board_one_international']!=null){
      bint1 = jsonDecode(response.body)['board_one_international'];}
      if(jsonDecode(response.body)['board_two_international']!=null){
      bint2 = jsonDecode(response.body)['board_two_international'];}
      if( jsonDecode(response.body)['board_three_international']!=null){
      bint3 = jsonDecode(response.body)['board_three_international'];}
      if(jsonDecode(response.body)['affiliation_one']!=null){
      aff1 = jsonDecode(response.body)['affiliation_one'];}
      if(jsonDecode(response.body)['affiliation_two']!=null){
      aff2 = jsonDecode(response.body)['affiliation_two'];}
      if(jsonDecode(response.body)['affiliation_three']!=null){
      aff4 = jsonDecode(response.body)['affiliation_three'];}

      if(jsonDecode(response.body)['average_rating'] != null){
        average_rating = double.parse(jsonDecode(response.body)['average_rating']);
        perc = average_rating/5;
      }
    });

  }
  myback(){
    if(docimg == ""){
      return Container(
        child: Image.asset(
          'assets/images/doctor_profile.jpg',
          fit: BoxFit.cover,
        ),
      );
    }else{
      return Container(
        child: Image.network(docimg),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              //backgroundColor: Colors.white,
              elevation: 1,
              flexibleSpace: FlexibleSpaceBar(
                background: myback(),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'available_now'.tr().toUpperCase(),
                            style: TextStyle(
                              color: Color(0xff40E58C),
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            dooname,
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          Text(
                            docspe,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[350],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: [

                        RatingBar(
                          itemSize: 40,
                          initialRating: average_rating,
                          allowHalfRating: true,
                          itemCount: 5,
                          ignoreGestures: true,

                         /* Builder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),*/
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                        Text("Ratings Star"),
                      ],
                    ),
                    CustomCircularIndicator(
                      radius: 80,
                      percent: perc,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: 'Good Reviews',
                    ),
                    SizedBox(
                      width: 10,
                    ),
                   /* CustomCircularIndicator(
                      radius: 80,
                      percent: 0.95,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: 'total_score'.tr(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomCircularIndicator(
                      radius: 80,
                      percent: 0.9,
                      lineWidth: 5,
                      line1Width: 2,
                      footer: 'satisfaction'.tr(),
                    ),*/

                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 1,
                  color: Colors.grey[350],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'about'.tr(),
                  style: Theme.of(context).textTheme.headline6.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Consultation Fee \nPhp " + charge,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Doctor ' + dooname + " was trained in  \n" + tr1 + "\n" + tr2 + "\n" + tr3
                  + "\n\n" + "Board on\n" + bloc1 + "\n" + bloc2 + "\n" + bloc3 + "\n\nBoard International \n" +
                  bint1 + "\n" + bint2 + "\n" + bint3 + "\n\nAffilation\n" + aff1 + "\n" + aff2 + "\n" + aff4
                  ,
                   style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    RoundIconButton(
                      onPressed: () {
                        if(docnumber != ""){
                          textme();
                        }

                      },
                      icon: Icons.message,
                      elevation: 1,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    RoundIconButton(
                      onPressed: () {
                        if(docnumber != "") {
                          callme();
                        }
                      },
                      icon: Icons.phone,
                      elevation: 1,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: RawMaterialButton(
                        onPressed: () {
                          if(charge != "") {
                            AppVar.docid = did;
                            AppVar.docname = dooname;
                            AppVar.docimg = docimg;
                            AppVar.doctype = docspe;
                            AppVar.doccharge = charge;

                            Navigator.of(context).pushNamed(
                                Routes.bookingStep3);
                          }

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: Container(
                          height: 48,
                          child: Center(
                            child: Text(
                              'book_an_appointment'.tr().toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  textme()async{
    String uri = 'sms:' + docnumber + '?body=Good day doc,';
    if (await canLaunch(uri)) {
    await launch(uri);
    } else {
    // iOS
    const uri = 'sms:';
    if (await canLaunch(uri)) {
    await launch(uri);
    } else {
    throw 'Could not launch $uri';
    }
    }
  }
  callme()async{
    String uri = 'tel:' + docnumber;
    if (await canLaunch(uri)) {
    await launch(uri);
    } else {
    // iOS
    const uri = 'sms:';
    if (await canLaunch(uri)) {
    await launch(uri);
    } else {
    throw 'Could not launch $uri';
    }
    }
  }
}
