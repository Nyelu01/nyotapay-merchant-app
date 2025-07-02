import 'package:get/get.dart';
import 'package:nyotapay/controller/navbar/dashboard_controller.dart';
import 'package:nyotapay/controller/navbar/navbar_controller.dart';

import '../views/set_up_pin/controller/set_up_pin_controller.dart';

class NavBarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashBoardController());
    Get.put(SetUpPinController());
    Get.put(NavbarController());
  }
}
