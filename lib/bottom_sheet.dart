import 'dart:async';


import 'package:fireworks/constants.dart';
import 'package:fireworks/provider/option_model.dart';
import 'package:fireworks/provider/points.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomSheet extends StatefulWidget {


 final Function capture;

  const BottomSheet({Key? key ,required this.capture,}) : super(key: key);

  @override
  State<BottomSheet> createState() => _BottomSheetState();


}

class _BottomSheetState extends State<BottomSheet> {
 final List<Color> _colors = [
    Colors.red,Colors.blue,Colors.green,Colors.yellow ,Colors.black ,Colors.white ];
  final ValueNotifier<double> _size = ValueNotifier<double>(1);
  final ValueNotifier<bool> _showSlider = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _showColor = ValueNotifier<bool>(false);
  int _colorPressed = 0;
  int _sliderPressed = 0;




  void callColors()
  {


    final int press = _colorPressed;







      setState(
              ( ) {

                _showColor.value = true;

          }
      );
      Timer(Duration(seconds: 5), () {
        if(press==_colorPressed)
        setState(
              ( ) {

                _showColor.value = false;

          }
      );}

      );




  }




  void callSlider()
  {

    final int press = _sliderPressed;




        print('showSlider');

        setState(
                ( ) {

                  _showSlider.value = true;

                     }
        );
     Timer(Duration(seconds: 5), () {
       if(press==_sliderPressed)
       setState(
             ( ) {

           _showSlider.value = false;

         }
     );}

     );



  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width ;
    double height = MediaQuery. of(context). size. height;
    return



Stack(
  children: [
    ValueListenableBuilder<bool>(
        valueListenable: _showColor,
        builder: (BuildContext context, bool showColor, Widget? child) {

          return
            showColor? Positioned( right : 0 ,child: Container(height: height-100,width: 100,

              child: Column(
                children: [
                  for(var color in _colors)
                    Expanded(
                        flex:1,
                        child:  GestureDetector (
                            onTap: (){  callSlider() ; Provider.of<optionModel> (context,listen: false).color = color;   },
                            child:Container(


                              margin: EdgeInsetsDirectional.all(10),
                              padding: EdgeInsetsDirectional.all(20),

                              decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.black)
                              ),

                            )) ),



                ],
              ),
            )): Positioned( right : 0 ,child:SizedBox(height: height-100,));}),

    Positioned( bottom: 0 ,child:
    Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        ValueListenableBuilder<bool>(
        valueListenable: _showSlider,
        builder: (BuildContext context, bool showSlider, Widget? child) {

      return
        showSlider?   ValueListenableBuilder<double>(

          valueListenable: _size,
      builder: (BuildContext context, double size, Widget? child) {

       return Slider(
          min: 1,
          max: 100,
          onChanged: (double value) { callSlider(); Provider.of<optionModel>(context,listen: false).size = Size(value,value) ; _size.value= value;  },
          value: size,
          thumbColor: Colors.black,
          activeColor: Colors.black,
          inactiveColor: Colors.grey,)
        ;
      }):SizedBox();}),

      Container(
        width : width,
        height: 100,

    decoration: BoxDecoration(
color: Colors.white,
      border: BorderDirectional(top:BorderSide(color:Colors.black))
    ),

    child: Row(
        children: [

               Expanded(
                   flex:1,
                   child:  GestureDetector (
                       onTap: (){ _sliderPressed++; _colorPressed++;  callSlider();  callColors();  Provider.of<optionModel> (context,listen: false).optionType = option_type.pen; },
                       child:Container(


                 margin: EdgeInsetsDirectional.all(10),
                 padding: EdgeInsetsDirectional.all(20),

                 decoration: BoxDecoration(
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.black)
                 ),
                         child: Icon(Icons.edit),
                   )) ),
          Expanded(
              flex:1,
              child:  GestureDetector (
                  onTap: (){   Provider.of<optionModel> (context,listen: false).optionType = option_type.eraser;Provider.of<pointsModel> (context,listen: false).center=[]; },
                  child:Container(


                    margin: EdgeInsetsDirectional.all(10),
                    padding: EdgeInsetsDirectional.all(20),

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)
                    ),
                    child: Icon(Icons.delete),
                  )) ),

          Expanded(
              flex:1,
              child:  GestureDetector (
                  onTap: (){  Provider.of<optionModel> (context,listen: false).optionType = option_type.text; },
                  child:Container(


                    margin: EdgeInsetsDirectional.all(10),
                    padding: EdgeInsetsDirectional.all(20),

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)
                    ),
                    child: Icon(Icons.text_fields_rounded),
                  )) ),
          Expanded(
              flex:1,
              child:  GestureDetector (
                  onTap: (){ widget.capture(); Provider.of<optionModel> (context,listen: false).optionType = option_type.save; },
                  child:Container(


                    margin: EdgeInsetsDirectional.all(10),
                    padding: EdgeInsetsDirectional.all(20),

                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black)
                    ),
                    child: Icon(Icons.save),
                  )) ),
      ],
    ),

    ) ],
      ) )

  ]);

  }
}
