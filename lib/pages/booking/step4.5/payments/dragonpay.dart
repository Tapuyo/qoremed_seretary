import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:qoremed_app/utils/constants.dart';
import '../../../../routes/routes.dart';

class DragonPayment extends StatefulWidget {
  @override
  _drg createState() => _drg();
}

class _drg extends State<DragonPayment> {



  @override
  Widget build(BuildContext context) {
    return  WebviewScaffold(
      //url: "https://test.dragonpay.ph/Pay.aspx?merchantid=QOREITINC&txnid=QME926F362&amount=600.00&ccy=PHP&description=Consultation+Fee&email=schmitt.kayleigh%40ledner.com&digest=76f411785f19e0caa3f9c567a53e14923fbcfbdc",
      url: "https://gw.dragonpay.ph/GenPay.aspx?merchantid=DPLITE&invoiceno=" + AppVar.invoice +
          "&name="+ AppVar.userfullname + "&amount=" + AppVar.doccharge + "&remarks=Consultation+fee&email=" + AppVar.useremail,
      appBar: new AppBar(
        title: const Text('Online Payment'),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      initialChild: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        color: Colors.white,
        child:  Container(
          height: 70,
          child: Card
            (
              color: kColorBlue,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(Routes.bookingStep5);
                },
                child: Center(
                    child: Text("Next", style: TextStyle(color: Colors.white, fontSize: 20),)
                ),
              )
          ),
        ),
      ),
    );

  }

  @override
  void dispose() {

  }
}