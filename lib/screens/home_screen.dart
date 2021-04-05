import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/widget/widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PageView and Indicator..',
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            IndicatorPageView(
              indicatorBackColor: Colors.green,
              indicatorColor: Colors.blue,
              itemCount: 3,
              builder: (index) {
                return Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      '${index + 1} Page',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
