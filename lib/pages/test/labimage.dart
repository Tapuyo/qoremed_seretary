

import 'package:flutter/material.dart';

class LabImage extends StatefulWidget {
  String ur;
  LabImage(this.ur);
  @override
  _LabImageState createState() => _LabImageState(this.ur);
}

class _LabImageState extends State<LabImage> {
  String ur;
  _LabImageState(this.ur);


  @override
  void initState() {
    super.initState();
    print(ur);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lab Result"),
        ),
        body: Container(
          child: Center(child: Image.network(ur)),
        ),
      ),

    );
  }
}
