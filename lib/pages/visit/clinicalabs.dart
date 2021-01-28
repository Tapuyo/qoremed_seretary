import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/utils/constants.dart';


class ClinicAbs extends StatefulWidget {
  String emu,enc;

  ClinicAbs(this.emu,this.enc);
  @override
  _WebCert createState() => _WebCert(this.emu,this.enc);
}

class _WebCert extends State<ClinicAbs> {
  String emu,enc;
  _WebCert(this.emu,this.enc);

  String dt,diagnosis,chief_complaint,admitting_diagnosis,final_diagnosis,brief_history,lab_results,management,procedure,disposition;

  @override
  void initState() {
    super.initState();
    chief_complaint = "";
    admitting_diagnosis = "";
    final_diagnosis = "";
    brief_history = "";
    lab_results = "";
    management = "";
    procedure = "";
    disposition = "";
    getConsult();
  }

  getConsult() async{
    print("Fetching Consultation");

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/encounters/" + enc + "/clinical-abstracts/" + emu;
    final response = await http.get(url,headers: headers);



    print(json.decode(response.body).toString());

    if(response.statusCode == 200){
      setState(() {
        dt = json.decode(response.body)['encounter_id'].toString();
        DateTime st =  DateFormat("yyyy-MM-dd").parse(json.decode(response.body)['date'].toString());
        String mo;
        if(st.month == 1){
          mo = "January";
        }
        if(st.month == 2){
          mo = "February";
        }
        if(st.month == 3){
          mo = "March";
        }
        if(st.month == 4){
          mo = "April";
        }
        if(st.month == 5){
          mo = "May";
        }
        if(st.month == 6){
          mo = "June";
        }
        if(st.month == 7){
          mo = "July";
        }
        if(st.month == 8){
          mo = "August";
        }
        if(st.month == 9){
          mo = "September";
        }
        if(st.month == 10){
          mo = "October";
        }
        if(st.month == 11){
          mo = "November";
        }
        if(st.month == 12){
          mo = "December";
        }

        diagnosis = mo + " " + st.day.toString() + ", " + st.year.toString();
        chief_complaint = json.decode(response.body)['chief_complaint'].toString();
        admitting_diagnosis = json.decode(response.body)['admitting_diagnosis'].toString();
        final_diagnosis = json.decode(response.body)['final_diagnosis'].toString();
        brief_history = json.decode(response.body)['brief_history'].toString();
        lab_results = json.decode(response.body)['lab_results'].toString();
        management = json.decode(response.body)['management'].toString();
        procedure = json.decode(response.body)['procedure'].toString();
        disposition = json.decode(response.body)['disposition'].toString();
      });
    }else{

    }

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            'Clinical Abstract'
        ),
        centerTitle: true,
      ),
      body: mybody(),
    );
  }

  mybody(){
    if(diagnosis != null){

      DateTime st =  DateFormat("yyyy-MM-dd").parse(AppVar.ubdate);
      final birthday = DateTime(st.year, st.month, st.day);
      final date2 = DateTime.now();
      final difference = date2.difference(birthday).inDays;
      String differenceInYears = (difference/365).floor().toString();

      String mes = AppVar.userfullname.toString();
      return PdfPreview(
        build: (format) => _generatePdf(format,mes),
      );
    }else{
      return Container(
        child: Center(
          child: Visibility(
            visible: true,
            child: Container(
              width: 150,
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: kColorBlue,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }
  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();
    PdfImage image = await pdfImageFromImageProvider(
      pdf: pdf.document,
      image: AssetImage('assets/images/waze.png'),
    );

    pdf.addPage(

      pw.Page(
        pageFormat: format,

        build: (context) {

          return pw.Container(
            padding: pw.EdgeInsets.fromLTRB(30, 40, 30, 0),
            child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children:[
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Image(image),

                      //pw.Text("QOREMED", style: pw.TextStyle(fontSize: 34, color: PdfColors.red900)),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [

                      pw.Text("Quezon City, Tel No:(04) 0926454524, Email : Qoremed@gmail.com.ph"),
                    ],
                  ),
                  pw.Divider(),


                  pw.SizedBox(height: 60),
                  pw.Text("Patient\'s Name"),
                  pw.Text("     "+ title),
                  pw.Text("Address"),
                  pw.Text("     "+AppVar.uaddress),
                  pw.Text("Date"),
                  pw.Text("     "+diagnosis),
                  pw.Text("Chief Complaint"),
                  pw.Text("     "+chief_complaint),
                  pw.Text("Admitting Diagnosis"),
                  pw.Text("     "+admitting_diagnosis),
                  pw.Text("Final Diagnosis"),
                  pw.Text("     "+final_diagnosis),
                  pw.Text("Brief History and Physical Examination"),
                  pw.Text("     "+brief_history),
                  pw.Text("Laboratory Results"),
                  pw.Text("     "+lab_results),
                  pw.Text("Course in the ward / Management"),
                  pw.Text("     "+management),
                  pw.Text("Operative Procedure"),
                  pw.Text("     "+procedure),
                  pw.Text("Disposition"),
                  pw.Text("     "+disposition),
                  pw.SizedBox(height: 100),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [

                      pw.Text("blk 13 lot 28 diamond village contact us 0928323282"),
                    ],
                  ),
                ]
            ),
          );
        },
      ),
    );

    return pdf.save();
  }
}
class Test{
  final String name;

  Test(this.name);
}