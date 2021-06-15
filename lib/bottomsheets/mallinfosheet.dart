import 'package:flutter/material.dart';
import 'package:mowl_proj/screens/malldirectory_load.dart';

class MallInfo extends StatefulWidget {
  MallInfo({this.mallName, this.mallCity, this.mallCode});

  final mallName;
  final mallCity;
  final mallCode;

  @override
  _MallInfoState createState() => _MallInfoState();
}

class _MallInfoState extends State<MallInfo> {
  TextStyle kMallSheetStyle = TextStyle(fontSize: 24.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.mallName,
            style: kMallSheetStyle.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            widget.mallCity,
            style: kMallSheetStyle.copyWith(color: Colors.grey),
          ),
          Text(widget.mallCode),
          SizedBox(
            height: 70,
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.all(20.0),
              alignment: Alignment.center,
              height: 50.0,
              color: Colors.teal,
              child: Text(
                'Go to Mall Directory',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MallDirectoryLoad(widget.mallName, widget.mallCode);
              }));
            },
          )
        ],
      ),
    );
  }
}
