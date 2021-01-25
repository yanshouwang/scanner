import 'dart:async';
import 'dart:typed_data';

import 'package:camerax/camerax.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huawei_scan/HmsScanLibrary.dart';
import 'package:scanner/main.dart';

class CameraView extends StatefulWidget {
  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  CameraController cameraController;
  StreamSubscription<CameraImage> subscription;
  AnimationController animationConrtroller;
  Animation<double> offsetAnimation;
  Animation<double> opacityAnimation;
  bool detecting = false;

  @override
  void initState() {
    super.initState();
    cameraController = CameraController(CameraFacing.back);
    subscription = cameraController.stream.listen(detect);
    animationConrtroller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    offsetAnimation = Tween(begin: 0.2, end: 0.8).animate(animationConrtroller);
    opacityAnimation =
        CurvedAnimation(parent: animationConrtroller, curve: OpacityCurve());
    animationConrtroller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: cameraController.initAsync(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraWidget(cameraController),
                AnimatedLine(
                  offsetAnimation: offsetAnimation,
                  opacityAnimation: opacityAnimation,
                ),
                Positioned(
                  left: 24.0,
                  top: 32.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            );
          } else {
            return Container(color: Colors.black);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    cameraController.dispose();
    animationConrtroller.dispose();
    super.dispose();
  }

  void detect(CameraImage image) async {
    if (detecting) {
      return;
    }
    detecting = true;
    try {
      final request =
          DecodeRequest(data: image.data, scanType: HmsScanTypes.AllScanType);
      final response = await HmsScanUtils.decodeWithBitmap(request);
      Navigator.of(navigatorKey.currentContext)
          .popAndPushNamed('show', arguments: response.showResult);
    } catch (e) {
      print(e);
    } finally {
      detecting = false;
    }
  }
}

class OpacityCurve extends Curve {
  @override
  double transform(double t) {
    if (t < 0.1) {
      return t * 10;
    } else if (t <= 0.9) {
      return 1.0;
    } else {
      return (1.0 - t) * 10;
    }
  }
}

class AnimatedLine extends AnimatedWidget {
  final Animation offsetAnimation;
  final Animation opacityAnimation;

  AnimatedLine(
      {Key key,
      @required this.offsetAnimation,
      @required this.opacityAnimation})
      : super(key: key, listenable: offsetAnimation);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacityAnimation.value,
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: LinePainter(offsetAnimation.value),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final double offset;

  LinePainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final radius = size.width * 0.45;
    final dx = size.width / 2.0;
    final center = Offset(dx, radius);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..isAntiAlias = true
      ..shader = RadialGradient(
        colors: [Colors.green, Colors.green.withOpacity(0.0)],
        radius: 0.5,
      ).createShader(rect);
    canvas.translate(0.0, size.height * offset);
    canvas.scale(1.0, 0.1);
    final top = Rect.fromLTRB(0, 0, size.width, radius);
    canvas.clipRect(top);
    canvas.drawCircle(center, radius, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension on CameraImage {
  Uint8List get data {
    final writer = WriteBuffer();
    for (var plain in planes) {
      writer.putUint8List(plain.bytes);
    }
    return writer.done().buffer.asUint8List();
  }
}
