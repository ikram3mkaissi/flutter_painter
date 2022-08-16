import 'package:fireworks/constants.dart';
import 'package:fireworks/provider/option_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:perfect_freehand/perfect_freehand.dart';




class Drawing {


  late  List<Point> points;

  late  optionModel option;

  Drawing({required this.option, required this.points});



}

class Canvas extends StatefulWidget {
  const Canvas({Key? key,required this.option}) : super(key: key);

  final optionModel option;

  @override
  State<Canvas> createState() => _CanvasState();
}

class _CanvasState extends State<Canvas> {

  final ValueNotifier<bool> _touched = ValueNotifier<bool>(false);

      List<Drawing> _center= [];



  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;
    return SizedBox(
        height: height,
        width: width,
        child: Stack(

          children: [


           _center != null? CustomPaint(

              painter :_customPainter(points:_center)
            ):SizedBox(),

            ValueListenableBuilder<bool>(
                valueListenable: _touched,
                builder: (BuildContext context, bool value, Widget? child) {
                  return
                    value?
                    Positioned.fromRect(rect: Rect.fromCenter(center: Offset(_center.last.points.last.x,_center.last.points.last.y), width: widget.option.size.width, height: widget.option.size.height),
                        child: Container(decoration: BoxDecoration(shape: BoxShape.circle,color: widget.option.color), ))

                        :SizedBox();
                }),

            GestureDetector(


             /*   onTapDown: (details)
                {
                  print('tapDown');
                  if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.last) {
                  setState(() {
                    _touched.value=true;
                    _center.add([Point(details.localPosition.dx,details.localPosition.dy)]) ;
                  });
}

                },*/
             /*   onTapUp: (details)
                {
                  print('tapUp');
                  setState(() {
                    _touched.value=false;

                  });


                },*/
               /* onLongPressDown:  (details)
                {
                  print('onLongPressDown');
                  if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.last) {
                  setState(() {
                    _touched.value=true;
                    _center.add([Point(details.localPosition.dx,details.localPosition.dy)]) ;
                  });
                }
                },*/
              /*  onLongPressUp: ()
                {
                  print('onLongPressUp');
                  setState(() {
                    _touched.value=false;

                  });


                },*/
                onLongPressMoveUpdate: (details)
                {
                 // print('onLongPressMoveUpdate');
                  if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.points) {
                    setState(() {
                      _center.last.points.add(Point(
                          details.localPosition.dx, details.localPosition.dy));
                    });
                  }

                },
                /*
                onPanStart: (details){
                  print('onPanStart');
                  if( _center.isEmpty    ) {
                    setState(() {
                      _center.add([
                        Point(
                            details.localPosition.dx, details.localPosition.dy)
                      ]);
                    });
                  }
                  else if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.last) {
                    setState(() {
                      _center.add([
                        Point(
                            details.localPosition.dx, details.localPosition.dy)
                      ]);
                    });
                  }

                },*/
                onPanDown:  (details)
                {

              //    print('onPanDown');
                if( _center.isEmpty   ) {

                  setState(() {
                    _center.add(new Drawing( points: [
                      Point(
                          details.localPosition.dx, details.localPosition.dy)
                    ], option:new optionModel(widget.option.optionType, widget.option.color, widget.option.size) ));
                  });
                }
                else if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.points.last) {
                  setState(() {
                    _center.add(new Drawing( points: [
                      Point(
                          details.localPosition.dx, details.localPosition.dy)
                    ], option:new optionModel(widget.option.optionType, widget.option.color, widget.option.size) ));
                  });
                }
            },
                onPanUpdate:(details)
                {  // print('onPanUpdate');
                if(Point(details.localPosition.dx,details.localPosition.dy) != _center.last.points.last) {
                  setState(() {
                    _center.last.points.add(Point(
                        details.localPosition.dx, details.localPosition.dy));
                  });
                }

                },
          /*      onPanEnd: (details)
                {
                  print('onPanEnd');
                  setState(() {
                    _touched.value=false;

                  });
                }*/



            ),
          ],
        )
    );
  }
}

class _customPainter extends CustomPainter {
  final List<Drawing> points;
  final recorder = new ui.PictureRecorder();

  @override
  void paint(ui.Canvas canvas, Size size) {
    // TODO: implement paint

    for(var _points in points)
      {


        final outlinePoints = getStroke(_points.points, simulatePressure: false,size:_points.option.size.width,thinning: 0,smoothing: 0);

        var paint = Paint()
          ..color =_points.option.optionType == option_type.eraser?Colors.white: _points.option.color
          ..strokeCap = StrokeCap.round
     //     ..blendMode = _points.option.optionType == option_type.eraser? BlendMode.clear : BlendMode.darken
          ..strokeWidth = _points.option.size.width;

        //canvas.drawPoints(ui.PointMode.points, offsets, paint);

        final path = Path();
        if (outlinePoints.isEmpty) {

          // If the list is empty, don't do anything.
          return;
        } else if (outlinePoints.length < 2) {

          // If the list only has one point, draw a dot.
          path.addOval(Rect.fromCircle(
              center: Offset(outlinePoints[0].x, outlinePoints[0].y), radius: 0.5));
        } else {

          // Otherwise, draw a line that connects each point with a bezier curve segment.
          path.moveTo(outlinePoints[0].x, outlinePoints[0].y);

          for (int i = 1; i < outlinePoints.length - 1; ++i) {

            final p0 = outlinePoints[i];
            final p1 = outlinePoints[i + 1];
            path.quadraticBezierTo(

                p0.x, p0.y, (p0.x + p1.x) / 2, (p0.y + p1.y) / 2
            );

          }

          // 3. Draw the path to the canvas

        }

        canvas.drawPath(path, paint);

      }


  }




  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.



  @override
  bool shouldRepaint(_customPainter oldDelegate) => true;
  @override
  bool shouldRebuildSemantics(_customPainter oldDelegate) => false;

  _customPainter({required this.points});

}
