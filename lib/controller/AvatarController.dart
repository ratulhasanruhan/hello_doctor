import 'package:flutter/foundation.dart';

class AvatarController extends ChangeNotifier {
  var imageLink;
  var imageName;
  double progress = 0.0;

  setImageLink(String link) {
    imageLink = link;
    notifyListeners();
  }
  setImageName(String name) {
    imageName = name;
    notifyListeners();
  }

  setProgress(double value) {
    progress = value;
    notifyListeners();
  }



}