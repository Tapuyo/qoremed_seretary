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


class EmuCert extends StatefulWidget {
  String emu,enc;

  EmuCert(this.emu,this.enc);
  @override
  _WebCert createState() => _WebCert(this.emu,this.enc);
}

class _WebCert extends State<EmuCert> {
  String emu,enc;
  _WebCert(this.emu,this.enc);

  String dt,diagnosis,daysattention,recommendations;

  @override
  void initState() {
    super.initState();
    getConsult();
  }

  getConsult() async{
    print("https://qoremed.qoreit.com/api/patients/" + AppVar.patient_id + "/encounters/" + enc + "/medical-certificates/" + emu);

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/encounters/" + enc + "/medical-certificates/" + emu;
    final response = await http.get(url,headers: headers);



    print(json.decode(response.body)['date'].toString());

    if(response.statusCode == 200){
      setState(() {
        dt = json.decode(response.body)['date'].toString();
        diagnosis = json.decode(response.body)['diagnosis'].toString();
        daysattention = json.decode(response.body)['days_attention'].toString();
        recommendations = json.decode(response.body)['recommendations'];
      });
    }else{

    }

  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            'Medical Certificate'
        ),
        centerTitle: true,
      ),
      body: mybody(),
    );
  }

  mybody(){
    if(diagnosis != null){
      DateTime ststart =  DateFormat("yyyy-MM-dd").parse(dt);
      int dtmo = ststart.month;
      String bd;
      String mo = "";
      if(dtmo == 1){
        mo = "January";
      }
      if(dtmo == 2){
        mo = "February";
      }
      if(dtmo == 3){
        mo = "March";
      }
      if(dtmo == 4){
        mo = "April";
      }
      if(dtmo == 5){
        mo = "May";
      }
      if(dtmo == 6){
        mo = "June";
      }
      if(dtmo == 7){
        mo = "July";
      }
      if(dtmo == 8){
        mo = "August";
      }
      if(dtmo == 9){
        mo = "September";
      }
      if(dtmo == 10){
        mo = "October";
      }
      if(dtmo == 11){
        mo = "November";
      }
      if(dtmo == 12){
        mo = "December";
      }
      DateTime st =  DateFormat("yyyy-MM-dd").parse(AppVar.ubdate);
      final birthday = DateTime(st.year, st.month, st.day);
      final date2 = DateTime.now();
      final difference = date2.difference(birthday).inDays;
      String differenceInYears = (difference/365).floor().toString();
      bd = mo.toString() + " " + ststart.day.toString() + " " + ststart.year.toString();

      String mes = "This is to certify that " + AppVar.userfullname + ", "+ differenceInYears + "  years of age" + ", was examined and treated on " + bd.toString() + " with the following\n\n findings/diagnosis:\n"
          " " + diagnosis.toString() + "\n\n" + "And would need medical attention for " + daysattention.toString() + " days barring complications. " + "\n Further Recommendations: \n" + recommendations.toString();
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
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      //pw.Image(image),
                      pw.Text("Medical Certificate", style: pw.TextStyle(fontSize: 30, color: PdfColors.black)),
                    ],
                  ),
                  pw.SizedBox(height: 60),
                  pw.Text(title),
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
