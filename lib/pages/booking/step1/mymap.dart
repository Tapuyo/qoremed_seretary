import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qoremed_app/utils/constants.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:geocoder/geocoder.dart';
import 'package:qoremed_app/pages/booking/step3.5/step3.5.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../routes/routes.dart';

class MyMap extends StatefulWidget {

  @override
  _Map createState() => _Map();
}

class _Map extends State<MyMap> {

  TextEditingController _controller = new TextEditingController();
  bool typeme = false;

  List<Marker> _markers = [];

  bool loadmap = true;
  String hosimage = "";
  String hosname = "";
  String hosid = "";
  String hosadd = "";
  double hoslat,hoslong;
  String showrtadd = "";

  bool showinf = false;



  final passwordController = TextEditingController();
  MapController mapController;
  StatefulMapController statefulMapController;
  StreamSubscription<StatefulMapControllerStateChange> sub;

  //marker
  var infoWindowVisible = false;
  GlobalKey<State> key = new GlobalKey();

  @override
  void initState() {
    showinf = false;
    loadmap = true;
    hosname = "none";
    mapController = MapController();
    statefulMapController = StatefulMapController(mapController: mapController);

    statefulMapController.onReady.then((_) => print("The map controller is ready"));

    sub = statefulMapController.changeFeed.listen((change) => setState(() {}));
    super.initState();

    print("nothing");
    //setMarkers();
    getallmarkers();
  }

  Future<List<Doctor>> getDoctor() async{
    print("Hospital Name:"+hosname);
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url = "https://qoremed.qoreit.com/api/doctors?search=" + hosname;

    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    List<Doctor> doctor = [];

    //if(response.statusCode == 200){
    print(jsondata.toString());

    for (var u in jsondata){
      String docid,names,gender,netimage,docspe;

      if(u['id']== null){
        docid = "none";
      }else{
        docid = u['id'];
      }

      if(u['profile']['full_name']== null){
        names = "none";
      }else{
        names = u['profile']['full_name'];
      }
      if(u['profile']['gender']== null){
        gender = "male";
      }else{
        gender = u['profile']['gender'];
      }
      if(u['photo_url']== null){
        netimage = "none";
      }else{
        netimage = u['photo_url'];
      }

      if(u['doctor_type']['name']== null){
        docspe = "none";
      }else{
        docspe = u['doctor_type']['name'];
      }

      Doctor doctors = Doctor(docid,names,gender,netimage,docspe);

      doctor.add(doctors);


    }
    //}



    print(doctor.length.toString());
    return doctor;
  }

  docavatar(String image, netimage){
    if(netimage == "none"){
      if(image == "female"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_2.png'),
        );
      }if(image == "male"){
        return CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage('assets/images/icon_doctor_1.png'),
        );
      }
    }else
    {
      return CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        backgroundImage: AssetImage('assets/images/icon_doctor_3.png'),
        child: Image.network(netimage),
      );
    }

//return Image.network(netimage);
  }

  getallmarkers() async{
    String setxt = _controller.text;
    setState(() {
      loadmap = true;
      _markers.clear();
    });
    Map<String, String> headers = {"Content-type": "application/json", "Accept": "application/json", 'Authorization': 'Bearer ' + AppVar.token};
    String url;
    if(setxt == "" || setxt == null) {
      url = "https://qoremed.qoreit.com/api/clinics/";
    }else{
      url = "https://qoremed.qoreit.com/api/clinics?search=" + setxt;
    }
    final response = await http.get(url,headers: headers);

    var jsondata = json.decode(response.body)['data'];
    print(jsondata.toString());

    List<Marker> markers = [];

    for (var u in jsondata){
      final query = u['address']['full_address'] + ", Philippines";
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      //print("${first.featureName} : ${first.coordinates}");
      print(first.coordinates.latitude.toString() + "," + first.coordinates.longitude.toString());

      LatLng point = LatLng(first.coordinates.latitude,first.coordinates.longitude);
      var marks = [
        Marker(
          width: 80.0,
          height: 80.0,
          point: point,

          builder: (ctx) => Container(
            child: GestureDetector(
              onDoubleTap: (){
                setState(() {
                  hosid = u['id'].toString();
                  hoslat = point.latitude;
                  hoslong = point.longitude;
                  hosadd = u['address']['full_address'];
                  hosimage = u['photo_url'];
                  showrtadd = u['address']['city'].toString();
                  hosname = u['name'].toString();
                  AppVar.sclinic =  hosid;
                  AppVar.sclinicname = hosname;
                  print(hosname.toString());
                  showqr(context, hosname, hoslat,hoslong, hosadd, hosimage);
                });
              },
              onTap: (){
                setState(() {
                  hosimage = u['photo_url'];
                  hoslat = point.latitude;
                  hoslong = point.longitude;
                  hosadd = u['address']['full_address'];
                  hosid = u['id'].toString();
                  showrtadd = u['address']['city'].toString();
                  hosname = u['name'].toString();
                  showinf = true;
                });
              },
              child:   Container(
                child: Icon(
                  Icons.location_on,
                  color: Colors.redAccent[700],
                  size: 30,
                ),
              ),
            ),
          ),
        ),
      ];

      markers.add(marks[0]);
    }
    setState(() {
      loadmap = false;
      _markers = markers;
    });

  }

  showqr(BuildContext context, String mess, double lati,double longi, String address, String hosimages) {

    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red,
                backgroundImage: AssetImage('assets/images/hospital.png'),
                child: Image.network(hosimages),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(child: Text(mess)),
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: Colors.black45,),
              SizedBox(
                width: 5,
              ),
              Expanded(child: Text(address, style: TextStyle(fontSize: 12),)),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Text('Latitude:' + lati.toString() + ", Longitude" + longi.toString(), style: TextStyle(fontSize: 10, color: Colors.grey),),
          Divider(),
          Text('Doctor\'s List'),
          Divider(),
        ],
      ),
      content: mydocslist(),
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

  mydocslist(){
    return Container(
      child: FutureBuilder(
          future: getDoctor(),
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
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  //padding: EdgeInsets.symmetric(horizontal: 20),

                  itemBuilder: (context, index){
                    return Card(
                      child: GestureDetector(
                        onTap: (){
                          print(snapshot.data[index].docid);
                          AppVar.docid = snapshot.data[index].docid;
                          AppVar.docname = snapshot.data[index].name;
                          AppVar.docimg =  snapshot.data[index].netimg;
                          AppVar.doctype = snapshot.data[index].docspe;
                          //Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SchClin(),
                            ),
                          );


                        },
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children: <Widget>[
                                //docavatar(snapshot.data[index].gender, snapshot.data[index].netimg),
                               /* SizedBox(
                                  width: 20,
                                ),*/
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              snapshot.data[index].name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2
                                                  .copyWith(fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                            size: 18,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '0',
                                            style: Theme.of(context).textTheme.bodyText2.copyWith(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        'Specialist',
                                        style: TextStyle(
                                          color: Colors.grey[350],
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        snapshot.data[index].docspe,
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

              );
            }
          }
      ),
    );
  }


  onch(String se){
    if(se != "" || se != null){
      setState(() {
        //setMarkers();
        typeme = true;
      });
    }else
      {
       setState(() {
         typeme = false;
       });
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),

        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.filter);
            },
            icon: Icon(
              Icons.filter_list,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: maymap(),
          ),
          Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 10),
                child: TextField(
                  controller: _controller,
                  onChanged: (text){
                    onch(text);
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: kColorBlue, width: 0.5),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.black, width: 0.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 20,
                    ),
                    hintText: 'search hospital or clinics',
                    hintStyle: TextStyle(
                      color: Colors.black,
                    ),

                    suffixIcon: Container(
                      width: 20,
                      child: FlatButton(
                        onPressed: (){
                         getallmarkers();
                        },
                        child: new Icon(Icons.arrow_forward,  color: Colors.blueAccent, size: 20,),),
                    ),


                  ),

                  cursorWidth: 1,
                  maxLines: 1,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 80),
                child: GestureDetector(
                  onTap: (){
                    _google();
                  },
                  child: Container(
                      // width: 100,
                      // height: 100,
                      child: Icon(Icons.my_location, color: Colors.black45,size: 50,)
                  ),
                ),
              ),
            ),
          /*Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 135),
              child: GestureDetector(
                onTap: (){
                  _waze();
                },
                child: Container(
                    width: 50,
                    height: 50,
                    child: Image.asset('assets/images/waze.png')),
              ),
            ),
          ),*/

          Align(
            alignment: Alignment.center,
            child: Visibility(
                visible: loadmap,
                child: Container(

                child: Center(
                  child: CircularProgressIndicator(),
                )

              )
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: showinf,
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showinf = false;
                    });
                  },
                  child: Center(
                    child: Column(
                      children: [
                        Text(hosname,style: TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
                        Text(hosadd,style: TextStyle(fontSize: 12, color: Colors.black45, ),textAlign: TextAlign.justify,),
                      ],
                    )
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Visibility(
              visible: showinf,
              child: Container(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 45),
                child: GestureDetector(
                  onTap: (){
                    _waze();
                  },
                  child: Container(
                      width: 70,
                      height: 60,
                      child: Image.asset('assets/images/hospital1.png', fit: BoxFit.fill,)),
                ),
              ),
            ),
          ),


        ]
      ),
    );
  }

  maymap(){

      return FlutterMap(

      mapController: mapController,
      options: new MapOptions(
        center: new LatLng(12.8797, 121.7740),
        //center: new LatLng(double.parse(mlat),double.parse(mlong)),
        zoom: 6.0,

      ),


      layers: [


        new TileLayerOptions(
          urlTemplate: "https://atlas.microsoft.com/map/tile/png?api-version=1&layer=basic&style=main&tileSize=256&view=Auto&zoom={z}&x={x}&y={y}&subscription-key={subscriptionKey}",

          additionalOptions: {
            'subscriptionKey': 'W_xYK4mUSBN7rJK9S5eeWqWaEvNMt3SvUDnoZAlkEqc'
          },
        ),





        new MarkerLayerOptions(markers: _markers),



      ],

    );


  }

  _google() async {
    String url = "https://www.google.com/maps/search/?api=1&query=" +  hoslat.toString() + "," + hoslong.toString();
    //String url = "https://www.google.com/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _waze() async {
    String url = "https://waze.com/ul?ll=" + hoslat.toString() +  "," + hoslong.toString() + "&z=10";
    //String url = "https://www.google.com/";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
class Doctor{
  final String docid;
  final String name;
  final String gender;
  final String netimg;
  final String docspe;

  Doctor(this.docid,this.name, this.gender, this.netimg,this.docspe);
}