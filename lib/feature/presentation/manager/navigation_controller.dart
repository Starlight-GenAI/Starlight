import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/constants.dart';

class NavigationController extends GetxController {
  RxString uid = ''.obs;
  RxString name = ''.obs;
  RxString profile = ''.obs;
  RxBool isScroll = false.obs;
  var allMarkers = <Marker>[].obs;
  var statePage = 0.obs;

  PageController? thisControl;

  startControl(PageController controller){
    thisControl = controller;
    statePage.value = 0;
  }

  changePage(int page){
    statePage.value = page;
    thisControl?.jumpToPage(page,);
  }

  logout(){
    uid.value = "";
    name.value = "";
    profile.value = "";
    statePage.value = 0;
  }
}