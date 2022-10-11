

import 'package:flutter/cupertino.dart';

import '../canvas.dart';
import '../class/drawing.dart';
import 'option_model.dart';




class pointsModel extends ChangeNotifier {

  late int last = 0 ;

 late List<Drawing> _center= [];
 late List<Drawing> _backup= [];

  pointsModel(this._center,this._backup);

  List<Drawing> get center => _center;
  List<Drawing> get backup => _backup;

  set center(List<Drawing> value) {
    _center = value;
    notifyListeners();


  }

  set backup(List<Drawing> value) {
    _backup = value;
    notifyListeners();
  }
}
