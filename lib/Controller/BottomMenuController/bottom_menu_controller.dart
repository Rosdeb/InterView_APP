import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../Utils/App_navigation/app_navigation.dart';

class BottomMenuControllers extends GetxController{

  var selectedIndex = 0.obs;

  void selectTab(int index) {
    final nestedState = Get.nestedKey(kMainContentNavigatorId)?.currentState;
    if (nestedState != null && nestedState.canPop()) {
      nestedState.popUntil((route) => route.isFirst);
    }
    selectedIndex.value = index;
  }

}