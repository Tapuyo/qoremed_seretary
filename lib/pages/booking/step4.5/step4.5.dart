import 'package:qoremed_app/data/pref_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../../../components/day_slot_item.dart';
import '../../../components/doctor_item1.dart';
import 'package:qoremed_app/pages/booking/step4.5/payments/gcashpayment.dart';
import '../../../model/doctor.dart';
import '../../../routes/routes.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:device_apps/device_apps.dart';
import 'package:qoremed_app/pages/booking/step4.5/payments/dragonpay.dart';
import 'package:qoremed_app/pages/booking/step4.5/payments/bankdeposit.dart';
import 'package:qoremed_app/pages/booking/step4.5/payments/paymayapayment.dart';
import 'package:qoremed_app/pages/booking/step4.5/payments/webviewpayment.dart';

class Paym extends StatefulWidget {
  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<Paym> {
  String _radioValue;
  String _choice;
  bool hmov = false;
  bool bankv = false;


  bookbank()async{
    print(AppVar.docid);
    print(AppVar.userid);
    print(AppVar.sclinic);
    print(AppVar.periodid);
    print(AppVar.consreason);
    hmov = false;
    bankv = false;
    if(_choice != "none"){
      showProgressDialog(context);

      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer ' + AppVar.token
      };
      String url = "https://qoremed.qoreit.com/api/appointments/";
      Map<String, String> body = {
        "appointable_id": AppVar.sclinic,
        "client_id": AppVar.userid,
        'period_id': AppVar.periodid,
        'consultation_reason_id': AppVar.consreason,
        'payment_option': _choice,
      }; //
      final response = await http.post(url, headers: headers, body: body);

      var jsondata = json.decode(response.body);
      //print(jsondata.toString());

      if(response.statusCode == 200){
//      AppVar.nxtdt = json.decode(response.body)['access_token'].toString();
//      AppVar.nxtdocsp = nxtdocsp;
//      AppVar.nxthospital = nxthospital;
        AppVar.invoice = json.decode(response.body)['reference_no'].toString();
        print(AppVar.invoice);
        AppVar.nxtname = AppVar.userfullname;
        AppVar.nxtstatus = 'pending';
        AppVar.nxtid =  json.decode(response.body)['id'].toString();
        AppVar.nxtdt = json.decode(response.body)['date'].toString();
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BankDeposit(),
          ),
        );
      }else{
        Navigator.pop(context);
        shownosig(context, json.decode(response.body)['message'].toString() + ", " + json.decode(response.body)['errors']['appointable_id'].toString());
      }
    }

  }
  booknow()async{
    print(AppVar.docid);
    print(AppVar.userid);
    print(AppVar.sclinic);
    print(AppVar.periodid);
    print(AppVar.consreason);
    hmov = false;
    bankv = false;
    if(_choice != "none"){
      showProgressDialog(context);

      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer ' + AppVar.token
      };
      String url = "https://qoremed.qoreit.com/api/appointments/";
      Map<String, String> body = {
        "appointable_id": AppVar.sclinic,
        "client_id": AppVar.userid,
        'period_id': AppVar.periodid,
        'consultation_reason_id': AppVar.consreason,
        'payment_option': _choice,
      }; //
      final response = await http.post(url, headers: headers, body: body);

      var jsondata = json.decode(response.body);
      //print(jsondata.toString());

      if(response.statusCode == 200){
//      AppVar.nxtdt = json.decode(response.body)['access_token'].toString();
//      AppVar.nxtdocsp = nxtdocsp;
//      AppVar.nxthospital = nxthospital;
        AppVar.invoice = json.decode(response.body)['reference_no'].toString();
        print(AppVar.invoice);
        AppVar.nxtname = AppVar.userfullname;
        AppVar.nxtstatus = 'pending';
        AppVar.nxtid =  json.decode(response.body)['id'].toString();
        AppVar.nxtdt = json.decode(response.body)['date'].toString();
        Navigator.pop(context);
        Navigator.of(context).pushNamed(Routes.bookingStep5);
      }else{
        Navigator.pop(context);
        shownosig(context, json.decode(response.body)['message'].toString() + ", " + json.decode(response.body)['errors']['appointable_id'].toString());
      }
    }

  }

  dragonbook()async{
    print(AppVar.docid);
    print(AppVar.userid);
    print(AppVar.sclinic);
    print(AppVar.periodid);
    print(AppVar.consreason);
    hmov = false;
    bankv = false;
    if(_choice != "none"){
      showProgressDialog(context);

      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Bearer ' + AppVar.token
      };
      String url = "https://qoremed.qoreit.com/api/appointments/";
      Map<String, String> body = {
        "appointable_id": AppVar.sclinic,
        "client_id": AppVar.userid,
        'period_id': AppVar.periodid,
        'consultation_reason_id': AppVar.consreason,
        'payment_option': _choice,
      }; //
      final response = await http.post(url, headers: headers, body: body);

      var jsondata = json.decode(response.body);
      //print(jsondata.toString());

      if(response.statusCode == 200){
//      AppVar.nxtdt = json.decode(response.body)['access_token'].toString();
//      AppVar.nxtdocsp = nxtdocsp;
//      AppVar.nxthospital = nxthospital;
        AppVar.invoice = json.decode(response.body)['reference_no'].toString();
        print(AppVar.invoice);
        AppVar.nxtname = AppVar.userfullname;
        AppVar.nxtstatus = 'pending';
        AppVar.nxtid =  json.decode(response.body)['id'].toString();
        AppVar.nxtdt = json.decode(response.body)['date'].toString();
        Navigator.pop(context);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DragonPayment(),
          ),
        );


      }else{

        shownosig(context, json.decode(response.body)['message'].toString() + ", " + json.decode(response.body)['errors']['appointable_id'].toString());
      }
    }

  }

  paymentoption(){
    if(_choice == "online_payment"){
      dragonbook();
     /* Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DragonPayment(),
        ),
      );*/

    }
    if(_choice == "Gcash"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GcashPayment(),
        ),
      );
      _Gcash();
    }
    if(_choice == "Paymaya"){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PaymayaPayment(),
        ),
      );
      _Paymaya();
    }
    if(_choice == "cash"){
      booknow();
    }
    if(_choice == "bank_deposit"){
      bookbank();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BankDeposit(),
        ),
      );
    }
    if(_choice == "hmo_provider"){
      booknow();
    }


  }

  _Paymaya() async {

    String url = "https://payout.paymaya.com/";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebPayment('Paymaya Payment',url),
      ),
    );
 /*
      if (await canLaunch(url)) {
        await launch(url, forceWebView: true);
      }*/
  }
  _Gcash() async {
    String url = "https://www.gcash.com/";
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebPayment('Gcash Payment',url),
      ),
    );
    // //DeviceApps.openApp(url);
    // if (await canLaunch(url)) {
    //   await launch(url);
    // }
  }

  shownosig(BuildContext context, String mes) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Ok"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Booking"),
      content: Text(mes),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  static showProgressDialog(BuildContext context) {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              content: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  CircularProgressIndicator(),
                  Padding(padding: EdgeInsets.only(left: 15),),
                  Flexible(
                      flex: 8,
                      child: Text(
                        "Loading",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          });
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    _choice = "none";
    _radioValue = "one";

    checkhmo();
    checkbank();
  }

  checkbank() async {
    print(AppVar.docid);
    setState(() {
      bankv = false;
    });
    List mylist = [];
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/doctors/" + AppVar.docid +
        "/bank-accounts/";
    final response = await http.get(url, headers: headers);

    var jsondata = json.decode(response.body);
    print(jsondata.toString());

    var tagObjsJson = jsonDecode(response.body) as List;
    setState(() {
      mylist = tagObjsJson;
    });

    if(mylist.length > 0){
      setState(() {
        bankv = true;
      });
    }else{
      setState(() {
        bankv = false;
      });
    }

  }

  checkhmo()async{
    setState(() {
      hmov = false;
    });
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/hmos/";
    final response = await http.get(url, headers: headers);

    var jsondata = json.decode(response.body);

    for (var u in jsondata){
      checkdochmo(u['hmo_provider_id'].toString());
    }

  }
  checkdochmo(String hid)async{
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/doctors/" + AppVar.docid + "/hmos/";
    final response = await http.get(url, headers: headers);

    var jsondata = json.decode(response.body);

    for (var u in jsondata){
      print(u['id'].toString() + " vs " + hid.toString());
      if(hid.toString() == u['id'].toString()){
        setState(() {
          hmov = true;
        });
      }
    }

  }


  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'one':
          setState(() {
            _choice = "online_payment";
          });
          break;
        case 'two':
          setState(() {
            _choice = "Gcash";
          });
          break;
        case 'six':
          setState(() {
            _choice = "Paymaya";
          });
          break;
        case 'three':
          setState(() {
            _choice = "cash";
          });
          break;
        case 'four':
          setState(() {
            _choice = "bank_deposit";
          });
          break;
        case 'five':
          setState(() {
            _choice = "hmo_provider";
          });
          break;
        default:
          _choice = "none";
      }
      debugPrint(_choice); //Debug the choice in console
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Payment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Column(
                       children: [
                         Row(
                           children: [
                             Text("Consultation Fee:")
                           ],
                         ),
                         Row(
                           children: [
                             Text("PHP " + AppVar.doccharge, style: TextStyle(fontSize: 30),)
                           ],
                         ),
                       ],
                      ),
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 'one',
                              groupValue: _radioValue,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Online Payment",style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                          child: Text(
                            "Payment should be done within 1 hr upon booking.",style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        ),
                        Divider(),

                        Visibility(
                          visible: false,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'two',
                                    groupValue: _radioValue,
                                    onChanged: radioButtonChanges,
                                  ),
                                  Text(
                                    "Gcash",style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                                child: Text(
                                  "Payment should be done within 1 hr upon booking.",style: TextStyle(fontSize: 12, color: Colors.black45),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'six',
                                    groupValue: _radioValue,
                                    onChanged: radioButtonChanges,
                                  ),
                                  Text(
                                    "Debit/Credit Card",style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                                child: Text(
                                  "Payment should be done within 1 hr upon booking.",style: TextStyle(fontSize: 12, color: Colors.black45),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),

                        Row(
                          children: [
                            Radio(
                              value: 'three',
                              groupValue: _radioValue,
                              onChanged: radioButtonChanges,
                            ),
                            Text(
                              "Cash",style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                          child: Text(
                            "Appointment subject for doctor's approval.",style: TextStyle(fontSize: 12, color: Colors.black45),
                          ),
                        ),
                        Divider(),

                        Visibility(
                          visible: bankv,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'four',
                                    groupValue: _radioValue,
                                    onChanged: radioButtonChanges,
                                  ),
                                  Text(
                                    "Bank Deposit",style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                                child: Text(
                                  "Payment should be done within 24 hrs upon booking. Available Banks: Banco de Oro",style: TextStyle(fontSize: 12, color: Colors.black45),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        ),

                        Visibility(
                          visible: hmov,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 'five',
                                    groupValue: _radioValue,
                                    onChanged: radioButtonChanges,
                                  ),
                                  Text(
                                    "HMO",style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(40, 0, 20, 0),
                                child: Text(
                                  "Appointment subject for doctor's approval.",style: TextStyle(fontSize: 12, color: Colors.black45),
                                ),
                              ),
                              Divider(),
                            ],
                          ),
                        )
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ),
          mybutton(),
        ],
      )
    );
  }

  mybutton(){
    return Container(
      child: Column(
        children: [
          Container(

            height: 70,
            child: Card
              (
                color: kColorBlue,
                child: GestureDetector(
                  onTap: (){
                    paymentoption();
                  },
                  child: Center(
                      child: Text("Pay Now", style: TextStyle(color: Colors.white, fontSize: 18),)
                  ),
                )
            ),
          ),
        ],
      )
    );
  }
}
