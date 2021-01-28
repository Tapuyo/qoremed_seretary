import 'package:flutter/cupertino.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'dart:convert';
import 'dart:io';
import '../../../../routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qoremed_app/myvars.dart';
import 'package:image_picker/image_picker.dart';

class GcashPayment extends StatefulWidget {
  @override
  _GcashPaymentState createState() => _GcashPaymentState();
}

class _GcashPaymentState extends State<GcashPayment> {
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  startUpload() {
    if (null == tmpFile) {
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    uploadprrof(fileName);
  }



  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  uploadprrof(String fileimage)async{
    print(base64Image.toString());
    Map<String, String> headers = {
      "Accept": "application/json",
      'Authorization': 'Bearer ' + AppVar.token
    };
    String url = "https://qoremed.qoreit.com/api/appointments/" + AppVar.nxtid + "/payment/bank-deposit";
    Map<String, String> body = {
      "photo_file": file.toString(),
    }; //
    final response = await http.post(url, headers: headers, body: body);
    print(response.body.toString());
    var jsondata = json.decode(response.body);

    if(response.statusCode == 200){
      print(jsondata.toString());
      Navigator.of(context).pushNamed(Routes.bookingStep5);
    }else{
      print(jsondata.toString());
      //Navigator.of(context).pushNamed(Routes.bookingStep5);
    }
  }

  Future<List<Bank>> getSched() async{
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors/" + AppVar.docid + "/bank-accounts/";
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body);
    List<Bank> appoint = [];

    print(jsondata.toString());

    for (var u in jsondata){

      String appid,accno,bank,desc;


      if(u['account_name'].toString() == null){
        appid = "none";
      }else{
        appid = u['account_name'].toString();
      }
      if(u['account_number'].toString() == null){
        accno = "none";
      }else{
        accno = u['account_number'].toString();
      }
      if(u['bank']['name'].toString() == null){
        bank = "none";
      }else{
        bank = u['bank']['name'].toString();
      }
      if(u['bank']['description'].toString() == null){
        desc = "none";
      }else{
        desc = u['bank']['description'].toString();
      }

      Bank apps = Bank(appid,accno,bank,desc);

      appoint.add(apps);

    }

    print(appoint.length.toString());
    return appoint;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Gcash Payment',
        ),

      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            width: 100,
            height: 100,
            child: Image.asset('assets/images/gcash.png'),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Instruction: ", style:  TextStyle(color: Colors.black54),),
                Text("1st - Please pay your fee (Php " + AppVar.doccharge + ") at Gcash account listed below."),
                Text("2nd - Upload your proof of payment slip or screenshot."),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Card(
              child: GestureDetector(
                onTap: (){

                },
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: <Widget>[

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                AppVar.docname,
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),

                              Text(
                                'Account Name.',
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                AppVar.docname,
                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Account Number.',
                                style: TextStyle(
                                  color: Colors.grey[350],
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '09123456789',
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
            )
          ),
          Divider(),
          showImage(),
          Container(
            height: 70,
            child: Card
              (
                color: kColorBlue,
                child: GestureDetector(
                  onTap: (){
                    chooseImage();
                    //uploadprrof();
                  },
                  child: Center(
                      child: Text("Choose Image", style: TextStyle(color: Colors.white, fontSize: 20),)
                  ),
                )
            ),
          ),
          uploadbtn(),
        ],
      ),
    );
  }
  uploadbtn(){
    if(file == null){
      return Container(
        height: 70,
        child: Card
          (
            color: Colors.grey,
            child: GestureDetector(
              onTap: (){

              },
              child: Center(
                  child: Text("Upload Slip", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );
    }else{
      return Container(
        height: 70,
        child: Card
          (
            color: kColorBlue,
            child: GestureDetector(
              onTap: (){
                //chooseImage();
                startUpload();
              },
              child: Center(
                  child: Text("Upload Slip", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );
    }
  }
  banklist(){
    return Container(
      child:  FutureBuilder(
          future: getSched(),
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
              return SizedBox(
                height: 200.0,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    itemBuilder: (context, index){
                      return Card(
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: <Widget>[

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data[index].bank,
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),

                                        Text(
                                          'Account Name.',
                                          style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].docid,
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Account Number.',
                                          style: TextStyle(
                                            color: Colors.grey[350],
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].accno,
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data[index].desc,
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

                ),
              );
            }
          }
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }
}
class Bank{
  final String docid;
  final String accno;
  final String bank;
  final String desc;


  Bank(this.docid,this.accno,this.bank,this.desc);
}
