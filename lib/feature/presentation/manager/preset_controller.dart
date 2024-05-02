
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PresetController extends GetxController {
  RxInt day = 0.obs;
  RxString comingWith = ''.obs;
  RxString activities = ''.obs;
  RxString location = ''.obs;

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}