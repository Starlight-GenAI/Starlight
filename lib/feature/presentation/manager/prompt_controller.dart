
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PromptController extends GetxController {
  RxInt indexPage = 0.obs;
  PageController? pageController;
  RxBool isSelectYoutube = false.obs;


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print('oncloseeeee');
  }
}