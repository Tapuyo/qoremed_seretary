import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPayment extends StatefulWidget {
  String title,url;
  WebPayment(this.title,this.url);
  @override
  _WebPaymentState createState() => _WebPaymentState(this.title,this.url);
}

class _WebPaymentState extends State<WebPayment> {
  String title,url;
  _WebPaymentState(this.title,this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ), 
      body: WebView(
        initialUrl: url,
      ),
    );
  }
}
