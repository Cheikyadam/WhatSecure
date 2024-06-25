import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const my = Color(0xFF4E057E);

class SettingsController extends GetxController {
  RxMap<String, dynamic> settings = <String, dynamic>{}.obs;
  RxBool faveVerif = false.obs;
  RxList<Color> colors = <Color>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  void _loadSettings() {
    settings.value = GetStorage().read('settings');
    faveVerif.value = settings['faceVerif'];
    Color mycolor = settings['darkTheme'] ? Colors.black : Colors.white;
    colors.value = [mycolor, const Color(0xFF4E057E)];
  }

  void changeColor() {
    colors.value = [Colors.red, Colors.red];
  }

  void reinitColor() {
    Color mycolor = settings['darkTheme'] ? Colors.black : Colors.white;
    colors.value = [mycolor, const Color(0xFF4E057E)];
  }

  void setThemeToDark() {
    if (settings['darkTheme'] != true) {
      settings['darkTheme'] = true;
      GetStorage().write('settings', settings);
      reinitColor();
    }
  }

  void setThemeToLight() {
    if (settings['darkTheme'] != false) {
      settings['darkTheme'] = false;
      GetStorage().write('settings', settings);
      reinitColor();
    }
  }

  void changeBlocked() {
    settings['contacts'] = true;
    GetStorage().write('settings', settings);
  }

  void changeFaceVerifTemp() {
    reinitColor();
    if (faveVerif.isTrue) {
      faveVerif.value = false;
    } else {
      faveVerif.value = true;
    }
  }

  void changeFaceVerif(bool value) {
    reinitColor();
    settings['faceVerif'] = value;
    GetStorage().write('settings', settings);
    faveVerif.value = value;
  }
}
