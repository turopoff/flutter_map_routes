import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class ShowOnMapWidget extends StatefulWidget {
  ShowOnMapWidget({Key key}) : super(key: key);

  @override
  _ShowOnMapWidgetState createState() => _ShowOnMapWidgetState();
}

class _ShowOnMapWidgetState extends State<ShowOnMapWidget> {
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  Position _position;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    requestPermission(status: "init");
  }

  Future<void> requestPermission({String status = "load"}) async {
    if (_permissionStatus.isGranted) {
      if (status == "init") await _getLocation();
      return;
    }

    final _status = await Permission.locationAlways.request();
    setState(() {
      _permissionStatus = _status;
    });

    if (_status.isGranted && status == "init") await _getLocation();
  }

  void _openOnMap() async {
    await _getLocation();

    String saddr = "";

    if (_position != null) {
      double lat = _position.latitude;
      double lng = _position.longitude;

      saddr = "saddr=$lat,$lng&";
    }

    double toLat = 41.3178972;
    double toLng = 69.2566615;

    var mapUrl = "http://maps.google.com/maps?${saddr}daddr=$toLat,$toLng";

    _launchInWebView(mapUrl);
  }

  Future<void> _launchInWebView(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        // forceSafariVC: true,
        // forceWebView: true,
        // headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    }
  }

  Future<void> _getLocation() async {
    try {
      Position _position = await Geolocator.getLastKnownPosition();
      setState(() {
        this._position = _position;
      });
    } catch (e) {
      //
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Your location:"),
        Text(_position != null
            ? "${_position.latitude},${_position.longitude}"
            : "Not allowed!"),
        RaisedButton.icon(
          color: Colors.blue,
          colorBrightness: Brightness.dark,
          onPressed: () => _openOnMap(),
          icon: Transform.rotate(
            angle: -19.7,
            child: Icon(Icons.send),
          ),
          label: Text("Show on the map"),
        ),
      ],
    );
  }
}
