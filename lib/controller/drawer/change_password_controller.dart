import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyotapay/routes/routes.dart';

import '../../backend/model/common/common_success_model.dart';
import '../../backend/services/api_services.dart';


class PasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void gotoNavigation() {
    Get.toNamed(Routes.bottomNavBarScreen);
  }

  //!loading api
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late CommonSuccessModel _commonSuccessModel;

  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;

  // Login process function
  Future<CommonSuccessModel> updatePasswordProcess() async {
    _isLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'current_password': oldPasswordController.text,
      'password': newPasswordController.text,
      'password_confirmation': confirmPasswordController.text,
    };

    await ApiServices.passwordUpdateApi(body: inputBody).then((value) {
      _commonSuccessModel = value!;
      Get.offAllNamed(Routes.bottomNavBarScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _commonSuccessModel;
  }

}
