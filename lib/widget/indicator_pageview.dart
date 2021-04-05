import 'package:flutter/material.dart';

class IndicatorPageView extends StatefulWidget {
  final Widget Function(int index) builder;
  final int itemCount;
  final Color indicatorColor;
  final Color indicatorBackColor;
  final Color pageViewColor;

  const IndicatorPageView({
    Key key,
    @required this.builder,
    @required this.itemCount,
    this.indicatorColor,
    this.indicatorBackColor,
    this.pageViewColor,
  }) : super(key: key);

  @override
  _IndicatorPageViewState createState() => _IndicatorPageViewState();
}

class _IndicatorPageViewState extends State<IndicatorPageView>
    with TickerProviderStateMixin {
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
            width: Curves.easeInOut.transform(value) * 200.0,
            height: Curves.easeInOut.transform(value) * 100.0,
            child: child,
          ),
        );
      },
      child: widget.builder(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 20.0,
              width: 100.0,
              child: CustomPaint(
                painter: IndicatorPaint(
                  pageCount: widget.itemCount,
                  indicatorColor: widget.indicatorColor,
                  backIndicatorColor: widget.indicatorBackColor,
                  page:
                      _pageController.hasClients && _pageController.page != null
                          ? _pageController.page
                          : 0.0,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 200.0,
            color: widget.pageViewColor ?? null,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.itemCount,
              itemBuilder: (context, index) => pageViewWidget(index),
            ),
          ),
          SizedBox(height: 20.0),
        ],
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
