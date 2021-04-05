import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  PageController _pageController;
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.3,
    );
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat();
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
    )..addListener(() {
        setState(() {});
      });
  }

  Widget pageViewWidget(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        var value = 1.0;
        if (_pageController.position.hasContentDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            width: Curves.easeInOut.transform(value) * 100.0,
            height: Curves.easeInOut.transform(value) * 100.0,
            child: child,
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                color: Colors.blue,
                height: 20.0,
                width: 100.0,
                child: CustomPaint(
                  painter: IndicatorPaint(
                    pageCount: 3,
                    indicatorColor: Colors.red,
                    backIndicatorColor: Colors.grey,
                    page: _pageController.hasClients &&
                            _pageController.page != null
                        ? _pageController.page
                        : 0.0,
                  ),
                ),
              ),
            ),
            Container(
              height: 200.0,
              color: Colors.red,
              child: PageView.builder(
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) => pageViewWidget(index),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class IndicatorPaint extends CustomPainter {
  final Paint indicatorPaint;
  final Paint backIndicatorPaint;
  final Color indicatorColor;
  final Color backIndicatorColor;
  final int pageCount;
  final double page;
  double thickness;
  double radius;
  double space;
  IndicatorPaint({
    double thickness,
    double radius,
    double space,
    @required this.page,
    @required this.pageCount,
    @required this.indicatorColor,
    @required this.backIndicatorColor,
  })  : indicatorPaint = Paint()..color = indicatorColor,
        backIndicatorPaint = Paint()..color = backIndicatorColor,
        radius = radius ?? 10.0,
        space = space ?? 15.0,
        thickness = thickness ?? 3.0,
        super();
  @override
  void paint(Canvas canvas, Size size) {
    final Offset offset = Offset(radius, size.height / 2);
    final double totalWidth =
        (pageCount * 2 * radius) - (pageCount - 1) * space;
    _drawBackIndicator(canvas, offset, totalWidth);
    _drawIndicator(canvas, offset, totalWidth);
  }

  void _drawBackIndicator(Canvas canvas, Offset offset, double totalWidth) {
    for (var i = 0; i < pageCount; i++) {
      canvas.drawCircle(offset, radius - thickness, backIndicatorPaint);
      offset = offset.translate((2 * radius) + space, 0);
    }
  }

  void _drawIndicator(Canvas canvas, Offset offset, double totalWidth) {
    final int pageIndexToLeft = page.round();
    final double leftDotX = (offset.dx - (totalWidth / 2)) +
        (pageIndexToLeft * ((2 * radius) + space));
    final double transitionPercent = page - pageIndexToLeft;
    final double indicatorLeftX =
        leftDotX + (transitionPercent * ((2 * radius) + space));
    final double indicatorRightX = indicatorLeftX + (2 * radius);

    canvas.drawRRect(
      RRect.fromLTRBR(
        indicatorLeftX + thickness,
        0,
        indicatorRightX + thickness,
        2 * radius,
        Radius.circular(radius),
      ),
      indicatorPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
