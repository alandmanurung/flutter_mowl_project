// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:mowl_proj/bottomsheets/qrcodescan.dart';
import 'package:mowl_proj/bottomsheets/mallinfosheet.dart';

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return NetworkImage(getTileUrl(coords, options));
  }
}

class MapPage extends StatefulWidget {
  MapPage({this.mallsLoc});

  final mallsLoc;

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapCtrl = MapController();
  List<Marker> mallMarkers = [];

  //Create Mall Markers on Initial State
  void createMarkers(Map<String, dynamic> mallsList) {
    int mallsNum = mallsList['totalFeatures'];

    for (int i = 0; i < mallsNum; i++) {
      var feature = mallsList['features'][i];
      var newMarker = Marker(
          width: 25.0,
          height: 25.0,
          point: LatLng(feature['geometry']['coordinates'][1],
              feature['geometry']['coordinates'][0]),
          builder: (ctx) {
            String featureMall = feature['properties']['malls'];
            String featureCity = feature['properties']['city'];
            String featureCode = feature['properties']['fullcode'];

            return MarkerButton(
              featMall: featureMall,
              featCity: featureCity,
              featCode: featureCode,
            );
          });
      mallMarkers.add(newMarker);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createMarkers(widget.mallsLoc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade50,
          title: Container(
              alignment: Alignment.center,
              child: Image.asset('images/logo/mowlLogo.png', scale: 4)),
        ),
        body: Stack(
          children: [
            FlutterMap(
              mapController: mapCtrl,
              options: MapOptions(
                bounds: LatLngBounds(
                    LatLng(-6.341368569784364, 106.62753297365273),
                    LatLng(-6.068319625717022, 107.0395202783402)),
                center: LatLng(-6.22458785, 106.8297643),
                zoom: 11.0,
                minZoom: 11.0,
              ),
              layers: [
                TileLayerOptions(
                  // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  // subdomains: ['a', 'b', 'c']
                  wmsOptions: WMSTileLayerOptions(
                      baseUrl:
                          'http://13.212.171.234:8080/geoserver/lokasimaps/wms?',
                      layers: ['lokasimaps']),
                  tileProvider: const CachedTileProvider(),
                ),
                MarkerLayerOptions(markers: mallMarkers)
              ],
            ),
            Align(
              child: BottomButton(),
              alignment: Alignment.bottomCenter,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      color: Colors.white,
                      width: 30.0,
                      height: 30.0,
                      child: Icon(
                        Icons.zoom_in,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () {
                      mapCtrl.move(mapCtrl.center, mapCtrl.zoom + 1);
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  GestureDetector(
                    child: Container(
                      color: Colors.white,
                      width: 30.0,
                      height: 30.0,
                      child: Icon(
                        Icons.zoom_out,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      mapCtrl.move(mapCtrl.center, mapCtrl.zoom - 1);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Each of map's marker are able to retrieve mall informations
class MarkerButton extends StatelessWidget {
  MarkerButton({this.featMall, this.featCity, this.featCode});
  final String featMall;
  final String featCity;
  final String featCode;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.location_on,
        size: 25.0,
      ),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => MallInfo(
                  mallName: featMall,
                  mallCity: featCity,
                  mallCode: featCode,
                ));
      },
    );
  }
}

//Used to show bottomwidget
class BottomButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        Icons.arrow_drop_up,
        color: Colors.white,
        size: 30.0,
      ),
      onPressed: () {
        showModalBottomSheet(
            context: context, builder: (context) => QrScreen());
      },
      fillColor: Colors.teal,
    );
  }
}
