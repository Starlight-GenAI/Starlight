import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../core/constants/constants.dart';

class NavigationController extends GetxController {
  RxString uid = ''.obs;
  RxString name = ''.obs;
  RxString profile = ''.obs;
  RxBool isScroll = false.obs;
}