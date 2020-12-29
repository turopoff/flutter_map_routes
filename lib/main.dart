import 'package:flutter/material.dart';
import 'package:flutter_map_routes/data/dummy_image.dart' show rawImageData;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:yandex_mapkit/yandex_mapkit.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map Routes Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Map Routes Demo Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
      if (status != "load") await _getLocation();
      return;
    }

    try {
      final _status = await Permission.location.request();
      setState(() {
        _permissionStatus = _status;
      });

      if (_status.isGranted && status != "load") await _getLocation();
    } catch (e) {}
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          _position != null
              ? _getMap()
              : Container(
                  padding: EdgeInsets.all(10),
                  child: Text("Your location: Not allowed!"),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openOnMap(),
        child: Transform.rotate(
          angle: -19.7,
          child: Icon(Icons.send),
        ),
      ),
    );
  }

  Widget _getMap() {
    return Expanded(
      child: YandexMap(
        onMapCreated: (YandexMapController controller) async {
          await controller.addPlacemark(
            Placemark(
              point: Point(
                latitude: _position.latitude,
                longitude: _position.longitude,
              ),
              opacity: 0.95,
              rawImageData: rawImageData,
            ),
          );
        },
      ),
    );
  }
}
