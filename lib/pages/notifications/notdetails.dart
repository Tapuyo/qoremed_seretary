import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/components/round_icon_button.dart';
import 'package:qoremed_app/routes/routes.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../../myvars.dart';

class NotDetails extends StatefulWidget {
  String did;
  NotDetails(this.did);
  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState(this.did);
}

class _PatientDetailsPageState extends State<NotDetails> {
  String did;
  _PatientDetailsPageState(this.did);
  final oCcy = new NumberFormat("#,##0.00", "en_US");

  String fname,mname,lname,clinic,clides,consult,reason,price,status,pnumber,email,add,payment;



  @override
  void initState() {
    super.initState();
    fname = "";
    mname = "";
    lname = "";
    clinic = "";
    clides = "";
    consult = "";
    reason = "";
    price = "";
    status = "";
    pnumber = "";
    email = "";
    add = "";
    payment = "";
    getpat();
  }
  getpat()async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/appointments/" + did + "/";
    final response = await http.get(url,headers: headers);
    print(response.body.toString());
    String pid;

    setState(() {
      if(jsonDecode(response.body)['payment_option'] !=null) {
        payment = jsonDecode(response.body)['payment_option'];
      }
      if(jsonDecode(response.body)['payment_status'] !=null) {
        pnumber = jsonDecode(response.body)['payment_status'];
      }
      if(jsonDecode(response.body)['appointable']['fee'] !=null) {
        double pr = double.parse(jsonDecode(response.body)['appointable']['fee']);
        price = oCcy.format(pr) ;
      }
      if(jsonDecode(response.body)['payment_status'] !=null) {
        status = jsonDecode(response.body)['payment_status'];
      }
      if(jsonDecode(response.body)['period']['consultation_type']['name']!=null) {
        consult = jsonDecode(response.body)['period']['consultation_type']['name'];
      }
      if(jsonDecode(response.body)['consultation_reason']['name'] !=null) {
        reason = jsonDecode(response.body)['consultation_reason']['name'];
      }
      if(jsonDecode(response.body)['client']['profile']['first_name']!=null) {
        fname = jsonDecode(response.body)['client']['profile']['first_name'];
      }
      if(jsonDecode(response.body)['client']['profile']['middle_name']!=null) {
        mname = jsonDecode(response.body)['client']['profile']['middle_name'];
      }
      if(jsonDecode(response.body)['client']['profile']['last_name'] != null){
        lname = jsonDecode(response.body)['client']['profile']['last_name'];
      }
      if(jsonDecode(response.body)['appointable']['name']!=null) {
        clinic = jsonDecode(response.body)['appointable']['name'];
      }
      if(jsonDecode(response.body)['appointable']['description'] != null){
        clides = jsonDecode(response.body)['appointable']['description'];
      }
      if(jsonDecode(response.body)['client']['id'] != null){

        pid = jsonDecode(response.body)['client']['id'];
      }

    });
    print("Your id" + pid);
    getpatdet(pid);

  }

  getpatdet(String pid)async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/patients/" + pid + "/";
    final response = await http.get(url,headers: headers);
    print(response.body.toString());

    setState(() {
      if(jsonDecode(response.body)['contact']['phone_number'] !=null) {
        pnumber = jsonDecode(response.body)['contact']['phone_number'];
      }
      if(jsonDecode(response.body)['contact']['email'] !=null) {
        email = jsonDecode(response.body)['contact']['email'];
      }
      if(jsonDecode(response.body)['address']['full_address'] !=null) {
        add = jsonDecode(response.body)['address']['full_address'];
      }

    });

  }

  paidornot(){
    if(status == "pending"){
      return GestureDetector(
        onTap: (){

        },
        child: Center(
          child: Text(
            "Pending",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    if(status == "Unpaid"){
      return GestureDetector(
        onTap: (){

        },
        child: Center(
          child: Text(
            "Pay",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      );
    }
    if(status == "Paid"){
      return GestureDetector(
        onTap: (){

        },
        child: Center(
          child: Text(
            "Paid",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
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
              title: Text("Appointment"),
              expandedHeight: 280,
              floating: false,
              pinned: true,
              //backgroundColor: Colors.white,
              elevation: 1,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background:  Container(
                      child: Image.asset(
                        'assets/images/icon_man.png',
                        fit: BoxFit.cover,
                      ),
                    ),


                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                      child: Container(
                        width: 100,
                        height: 40,
                        child: RawMaterialButton(
                          onPressed: () {


                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          fillColor: kColorBlue,
                          child: Container(
                            height: 48,
                            child: paidornot()
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )


            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Patient Details",style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w300,
                ),),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Text(
                            fname + " " + mname + ". " + lname,
                            style:
                            Theme.of(context).textTheme.subtitle1.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            pnumber,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            add,
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
                  width: 10,
                ),
                Divider(),
                Text("Appointment Details",style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w300,
                ),),
                SizedBox(
                  height: 10,
                ),
                Text(clinic,style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
                ), ),
                Text(clides,style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w400,
                ), ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text("Consultation Details",style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w300,
                ),),
                SizedBox(
                  height: 10,
                ),
                Text(consult,style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w700,
                ), ),

                Text(reason,style:
                Theme.of(context).textTheme.subtitle1.copyWith(
                  fontWeight: FontWeight.w400,
                ), ),

                SizedBox(
                  height: 10,
                ),
                statpaid(),

                Row(
                  children: [
                    Text("₱ ", style: TextStyle(fontSize: 50),),
                    Text(price, style: TextStyle(fontSize: 50),)
                  ],
                ),

                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    RoundIconButton(
                      onPressed: () {
                        if(pnumber != ""){
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
                        if(pnumber != "") {
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


                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: kColorBlue,
                        child: Container(
                          height: 48,
                          child: Center(
                            child: Text(
                              payment.tr().toUpperCase(),
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
    String uri = 'sms:' + pnumber + '?body=Good day doc,';
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
    String uri = 'tel:' + pnumber;
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
  statpaid(){
    if(status == "Paid"){
      return   Text("Payment Status: " + status,style:
      Theme.of(context).textTheme.subtitle1.copyWith(
          fontWeight: FontWeight.w400,color: Colors.green
      ), );
    }
    if(status == "Unpaid"){
      return   Text("Payment Status: " + status,style:
      Theme.of(context).textTheme.subtitle1.copyWith(
        fontWeight: FontWeight.w400,
      ), );
    }
    else{
      return   Text("Payment Status: " + status,style:
      Theme.of(context).textTheme.subtitle1.copyWith(
        fontWeight: FontWeight.w400,
      ), );
    }
  }
}
