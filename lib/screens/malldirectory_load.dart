import 'package:flutter/material.dart';
import 'package:mowl_proj/services/featureget.dart';
import 'malldirpage.dart';

class MallDirectoryLoad extends StatefulWidget {
  MallDirectoryLoad(this.mallName, this.mallCode);
  final String mallName;
  final String mallCode;

  @override
  _MallDirectoryLoadState createState() => _MallDirectoryLoadState();
}

//Main use of this page is the same as the loading_screen.dart, to load mall directory

class _MallDirectoryLoadState extends State<MallDirectoryLoad> {
  @override
  void initState() {
    super.initState();
    getMallDirectory();
  }

  void getMallDirectory() async {
    var mallDir = await MowlFeatureGet().getMallsDir(widget.mallCode);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MallDirPage(
          mallName: widget.mallName,
          mallsDir: mallDir,
        ),
      ),
    );
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
