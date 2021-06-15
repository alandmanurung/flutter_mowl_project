import 'package:flutter/material.dart';
import 'package:mowl_proj/services/featureget.dart';
import 'package:mowl_proj/screens/map_page.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getMallsData();
  }

  //get Malls Location using get http
  void getMallsData() async {
    var mallsData = await MowlFeatureGet().getMallsData();

    //Navigate to map_page and passing mallsData to the page
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MapPage(
        mallsLoc: mallsData,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Please Wait'),
      ),
    );
  }
}
