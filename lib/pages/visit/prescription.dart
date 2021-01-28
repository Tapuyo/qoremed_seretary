import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:convert';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/utils/constants.dart';


class PresCrep extends StatefulWidget {
  String emu,enc;

  PresCrep(this.emu,this.enc);
  @override
  _WebCert createState() => _WebCert(this.emu,this.enc);
}

class _WebCert extends State<PresCrep> {
  String emu,enc;
  _WebCert(this.emu,this.enc);

  String dt,diagnosis;

  @override
  void initState() {
    super.initState();
    getConsult();
  }

  getConsult() async{
    print("Fetching Consultation");

    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/encounters/" + enc + "/prescriptions/" + emu;
    final response = await http.get(url,headers: headers);



    print(json.decode(response.body)['created_by'].toString());

    if(response.statusCode == 200){
      setState(() {
        //dt = json.decode(response.body)['created_by'].toString();
        diagnosis = json.decode(response.body)['remarks'].toString();
        //daysattention = json.decode(response.body)['days_attention'].toString();
        //recommendations = json.decode(response.body)['recommendations'];
      });
    }else{

    }

  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            'Prescription'
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


      String mes = "Name:" + AppVar.userfullname +
          "\n\n\nRemarks:\n" + diagnosis.toString() + "\n\n";
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
                      pw.Text("Prescription", style: pw.TextStyle(fontSize: 30, color: PdfColors.black)),
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
