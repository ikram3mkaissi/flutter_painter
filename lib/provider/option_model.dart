import '../constants.dart';

import 'package:flutter/cupertino.dart';

class optionModel extends ChangeNotifier
{

  late option_type _optionType;
  late Color _color ;
  late Size _size;


  optionModel(this._optionType, this._color, this._size);

  option_type get optionType => _optionType;

  set optionType(option_type value) {

    _optionType = value;
    notifyListeners();
  }

  Size get size => _size;

  set size(Size value) {
    _size = value;
    notifyListeners();
  }

  Color get color => _color;

  set color(Color value) {
    _color = value;
    notifyListeners();
  }

}