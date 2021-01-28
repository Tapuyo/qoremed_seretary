import 'dart:async';
import 'dart:convert';
import 'package:qoremed_app/myvars.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';
import 'package:qoremed_app/pages/booking/step3.5/step3.5.dart';
import 'package:qoremed_app/utils/constants.dart';
import 'package:search_map_place/search_map_place.dart';
import '../../../routes/routes.dart';


class MyGoogleMap extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyGoogleMap> {
  //Completer<GoogleMapController> _mapcontroller = Completer();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();
  bool _polygonAdded = false;
  String _mapStyle;

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
  static  LatLng _lastMapPosition;



  @override
  void initState() {

     hosimage = "";
     hosname = "";
     hosid = "";
     hosadd = "";
     showrtadd = "";
    getallmarkers();
    super.initState();
    GoogleMap.init(AppVar.googlemapid);
    _lastMapPosition = new LatLng(12.8797, 121.7740);

  }
  getallmarkers() async{
    String setxt = _controller.text;

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

    for (var u in jsondata) {
      if (u['address']['full_address'] != null) {
        String add = u['address']['full_address'];
        final query = add + ", Philippines";
        var addresses = await Geocoder.local.findAddressesFromQuery(query);
        var first = addresses.first;
        //print("${first.featureName} : ${first.coordinates}");
        print(first.coordinates.latitude.toString() + "," +
            first.coordinates.longitude.toString());

        LatLng point = LatLng(
            first.coordinates.latitude, first.coordinates.longitude);

        setState(() {
          GoogleMap.of(_key).addMarker(Marker(
              GeoCoord(first.coordinates.latitude, first.coordinates.longitude),
              label: "zxc",

              onTap: (value) {
                setState(() {
                  hosid = u['id'].toString();
                  hoslat = point.latitude;
                  hoslong = point.longitude;
                  hosadd = u['address']['full_address'];
                  hosimage = u['photo_url'];
                  showrtadd = u['address']['city'].toString();
                  hosname = u['name'].toString();
                  GoogleMap.of(_key).clearDirections();
                  GoogleMap.of(_key).addDirection(AppVar.uaddress, hosadd);
                  AppVar.sclinic = hosid;
                  AppVar.sclinicname = hosname;
                  print(hosname.toString());
                });
              }
          )
          );
        });
      }
    }

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
      String docid,names,gender,netimage,docspe,charge;

      if(u['id']== null){
        docid = "none";
      }else{
        docid = u['id'];
      }
      if(u['consultation_fee']== null){
        charge = "none";
      }else{
        charge = u['consultation_fee'];
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

      Doctor doctors = Doctor(docid,names,gender,netimage,docspe,charge);

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
                          AppVar.doccharge = snapshot.data[index].charge;
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

  getlocationcoo(String place)async{
    final query = place.toString();
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text('Google Map'),
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
      children: <Widget>[
        Positioned.fill(
          child: GoogleMap(
            key: _key,



            initialZoom: 6,
            initialPosition:GeoCoord(_lastMapPosition.latitude,_lastMapPosition.longitude),
            mapType: MapType.roadmap,
            mapStyle: _mapStyle,

            interactive: true,
            onTap: (coord) =>
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text(coord?.toString()),
                  duration: const Duration(seconds: 2),
                )),
            mobilePreferences: const MobileMapPreferences(
              trafficEnabled: true,
              zoomControlsEnabled: false,
            ),
            webPreferences: WebMapPreferences(
              fullscreenControl: true,
              zoomControl: true,
            ),


          ),
        ),



        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 10),
            child: SearchMapPlaceWidget(
              iconColor: kColorBlue,
              onSelected: (Place place)async{
                try{
                  final geolocation = await place.geolocation;
                  print(geolocation);
                  GoogleMap.of(_key).moveCamera(geolocation.coordinates);
                  
                }catch(e){
                  print(e);
                }

              },
              apiKey: AppVar.googlemapid,
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 80),
            child: GestureDetector(
              onTap: (){
                GoogleMap.of(_key).clearDirections();
                GoogleMap.of(_key).clearCircles();
                GoogleMap.of(_key).clearMarkers();
                GoogleMap.of(_key).clearPolygons();
                GoogleMap.of(_key).zoomCamera(6);
                getallmarkers();
                //getallmarkers();
              },
              child: Container(
                // width: 100,
                // height: 100,
                  child: Icon(Icons.replay, color: Colors.grey,size: 30,)
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: mybook(),
          ),
        ),
      ],
    ),

  );

  mybook(){
    if(hosid != ""){
      return Container(
        height: 50,
        child: Card
          (
            color: kColorBlue,
            child: GestureDetector(
              onTap: (){
                showqr(context, hosname, hoslat,hoslong, hosadd, hosimage);
              },
              child: Center(
                  child: Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );
    }else{
      return Container(
        height: 50,
        child: Card
          (
            color: Colors.grey,
            child: GestureDetector(
              onTap: (){

              },
              child: Center(
                  child: Text("Book Now", style: TextStyle(color: Colors.white, fontSize: 20),)
              ),
            )
        ),
      );
    }

  }
}

class Doctor{
  final String docid;
  final String name;
  final String gender;
  final String netimg;
  final String docspe;
  final String charge;

  Doctor(this.docid,this.name, this.gender, this.netimg,this.docspe,this.charge);
}