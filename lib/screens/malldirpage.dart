import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'dart:math';

class MallDirPage extends StatefulWidget {
  MallDirPage({this.mallName, this.mallsDir});
  final mallName;

  final mallsDir;

  @override
  _MallDirPageState createState() => _MallDirPageState();
}

class _MallDirPageState extends State<MallDirPage> {
  List<Polygon> mallDirPolys = [];
  List<double> mallLat = [];
  List<double> mallLong = [];
  List<TenantWidget> mallTenants = [];
  List<Widget> floorList = [];
  int selectedTenant = 0;
  int floorAmount = 1;
  int floorSelected = 1;
  MapController mapController = MapController();

  //Build all the polygons from mall directory GeoJSON
  void createPolys(var mallDirs) {
    int tenantNum = mallDirs['totalFeatures'];
    for (int i = 0; i < tenantNum; i++) {
      var feature = mallDirs['features'][i];
      List<LatLng> polyCoords = [];

      if (feature['properties']['floorno'] != floorAmount) {
        floorAmount++;
      }

      for (var coords in feature['geometry']['coordinates'][0][0]) {
        polyCoords.add(LatLng(coords[1], coords[0]));
        mallLat.add(coords[1]);
        mallLong.add(coords[0]);
      }
      var newPoly = Polygon(
          points: polyCoords,
          color: Colors.amber,
          borderColor: Colors.black,
          borderStrokeWidth: 2.0);
      var newTenant = TenantWidget(
        tenantName: feature['properties']['tenantname'],
        floorNo: feature['properties']['floorno'],
        listcode: i,
        onPress: () {
          setState(() {
            int previousSelected = selectedTenant;
            selectedTenant = i;
            updatePoly(previousSelected);
            mallTenants[selectedTenant].updateSelectedTenant(selectedTenant);
            mallTenants[previousSelected].updateSelectedTenant(selectedTenant);
          });
        },
      );
      if (feature['properties']['floorno'] == 1) {
        mallTenants.add(newTenant);
        mallDirPolys.add(newPoly);
      }
    }
    createFloorContainer();
  }

  void createFloorContainer() {
    for (int i = 0; i < floorAmount; i++) {
      var newfloorCont = Expanded(
        child: Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                changeFloor(widget.mallsDir, i + 1);
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 30.0,
              child: Text('Floor ${i + 1}'),
              color: floorSelected == i + 1 ? Colors.teal : Colors.white,
            ),
          ),
        ),
      );
      floorList.add(newfloorCont);
    }
  }

  void changeFloor(var mallDirs, int floorNo) {
    setState(() {
      floorSelected = floorNo;
    });

    mallDirPolys.clear();
    mallTenants.clear();

    int tenantNum = mallDirs['totalFeatures'];
    for (int i = 0; i < tenantNum; i++) {
      var feature = mallDirs['features'][i];
      List<LatLng> polyCoords = [];

      if (feature['properties']['floorno'] == floorSelected) {
        for (var coords in feature['geometry']['coordinates'][0][0]) {
          polyCoords.add(LatLng(coords[1], coords[0]));
          mallLat.add(coords[1]);
          mallLong.add(coords[0]);
        }
      }
      var newPoly = Polygon(
          points: polyCoords,
          color: Colors.amber,
          borderColor: Colors.black,
          borderStrokeWidth: 2.0);
      var newTenant = TenantWidget(
        tenantName: feature['properties']['tenantname'],
        floorNo: feature['properties']['floorno'],
        listcode: i,
        onPress: () {
          setState(() {
            int previousSelected = selectedTenant;
            selectedTenant = i;
            updatePoly(previousSelected);
          });
        },
      );
      setState(() {
        mallTenants.add(newTenant);
        mallDirPolys.add(newPoly);
      });
    }
  }

  void updatePoly(int previousSelected) {
    //Change Polygon
    mallDirPolys[previousSelected] = Polygon(
        points: mallDirPolys[previousSelected].points,
        color: Colors.amber,
        borderColor: Colors.black,
        borderStrokeWidth: 2.0);

    mallDirPolys[selectedTenant] = Polygon(
        points: mallDirPolys[selectedTenant].points,
        color: Colors.green,
        borderColor: Colors.black,
        borderStrokeWidth: 2.0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createPolys(widget.mallsDir);
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
        body: Column(
          children: [
            Row(
              children: floorList,
            ),
            Expanded(
              child: FlutterMap(
                options: MapOptions(
                  bounds: LatLngBounds(
                    LatLng(mallLat.reduce(min), mallLong.reduce(min)),
                    LatLng(mallLat.reduce(max), mallLong.reduce(max)),
                  ),
                  zoom: 12.0,
                  minZoom: 12.0,
                ),
                children: <Widget>[
                  TileLayerWidget(
                    options: TileLayerOptions(
                      // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      // subdomains: ['a', 'b', 'c']
                      wmsOptions: WMSTileLayerOptions(
                          baseUrl:
                              'http://13.212.171.234:8080/geoserver/lokasimaps/wms?',
                          layers: ['lokasimaps']),
                      tileProvider: const CachedTileProvider(),
                    ),
                  ),
                  PolygonLayerWidget(
                    options: PolygonLayerOptions(polygons: mallDirPolys),
                  )
                ],
              ),
            ),
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(widget.mallName),
                  backgroundColor: Colors.teal,
                ),
                body: Container(
                  child: ListView(
                    children: mallTenants,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return NetworkImage(getTileUrl(coords, options));
  }
}

class TenantWidget extends StatefulWidget {
  TenantWidget({
    @required this.tenantName,
    this.tenantCode,
    this.floorNo,
    this.listcode,
    this.onPress,
  });
  final tenantName;
  final tenantCode;
  final floorNo;
  final listcode;
  final onPress;
  var tenantSelected;

  void updateSelectedTenant(int tenantNum) {
    tenantSelected = tenantNum;
  }

  @override
  _TenantWidgetState createState() => _TenantWidgetState();
}

class _TenantWidgetState extends State<TenantWidget> {
  void checkSelected() {
    if (widget.listcode == widget.tenantSelected) {
      color = Colors.blue;
    } else {
      color = Colors.white;
    }
  }

  var color = Colors.white;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPress();
        setState(() {
          checkSelected();
        });
      },
      child: Padding(
        child: Material(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: color),
            height: 50.0,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text(
                      widget.tenantName,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 8.0),
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Floor ${widget.floorNo}',
                      style: TextStyle(
                          fontSize: 14.0, color: Colors.grey.shade500),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
      ),
    );
  }
}
