
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';

import '../../myvars.dart';




class RouteMap extends StatefulWidget {
  String hosadd;

  RouteMap(this.hosadd);
  @override
  _myRoute createState() => _myRoute(this.hosadd);
}

class _myRoute extends State<RouteMap> {
  String hosadd;
  _myRoute(this.hosadd);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _key = GlobalKey<GoogleMapStateBase>();

  String _mapStyle;
  static  LatLng _lastMapPosition;
  MapType spm;



  @override
  void initState() {

    super.initState();
    spm = MapType.roadmap;
    GoogleMap.init(AppVar.googlemapid);
    _lastMapPosition = new LatLng(12.8797, 121.7740);

    Timer(Duration(seconds: 5), () => {loadmap()});
  }

  loadmap(){
    GoogleMap.of(_key).clearDirections();
    GoogleMap.of(_key).addDirection(AppVar.uaddress, "BGC, Taguig");

  }




  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text('Google Map'),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            print(spm.toString());
            if(spm == MapType.roadmap){
              setState(() {
                spm = MapType.satellite;
              });
            }else{
              setState(() {
                spm = MapType.roadmap;
              });
            }

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

            initialZoom: 16,
            initialPosition: GeoCoord(_lastMapPosition.latitude,_lastMapPosition.longitude),
            mapType: spm,
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


      ],
    ),
  );


}
