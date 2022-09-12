

import 'package:flutter/cupertino.dart';

import '../canvas.dart';
import '../class/drawing.dart';
import 'option_model.dart';




class pointsModel extends ChangeNotifier {

 late List<Drawing> _center= [];

  pointsModel(this._center);

  List<Drawing> get center => _center;

  set center(List<Drawing> value) {
    _center = value;

    notifyListeners();
  }

}
