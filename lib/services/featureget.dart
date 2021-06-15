import 'package:mowl_proj/services/networking.dart';

class MowlFeatureGet {
  //Getting mall points
  Future<dynamic> getMallsData() async {
    NetworkHelper networkHelper = NetworkHelper(
        'http://192.168.56.1:8080/geoserver/mowl_proj/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=mowl_proj%3Amalls&maxFeatures=120&outputFormat=application%2Fjson');

    var mallsData = await networkHelper.getData();
    return mallsData;
  }

  //Getting mall Directories
  Future<dynamic> getMallsDir(String mallCode) async {
    String lowMallCode = mallCode.toLowerCase();
    NetworkHelper networkHelper = NetworkHelper(
        'http://192.168.56.1:8080/geoserver/mowl_proj/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=mowl_proj%3A$lowMallCode&maxFeatures=200&outputFormat=application%2Fjson');

    var mallsDir = await networkHelper.getData();
    return mallsDir;
  }
}
