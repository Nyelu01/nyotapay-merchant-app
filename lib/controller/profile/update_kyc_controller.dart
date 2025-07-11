import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyotapay/routes/routes.dart';

import '../../backend/model/common/common_success_model.dart';
import '../../backend/model/update_kyc/update_kyc_model.dart';
import '../../backend/services/api_services.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/inputs/primary_input_filed.dart';
import '../../widgets/others/update_kyc_widget/update_kyc_image_widget.dart';
import '../../widgets/text_labels/title_heading4_widget.dart';

class UpdateKycController extends GetxController {
  List<TextEditingController> inputFieldControllers = [];
  List<String> listImagePath = [];
  List<String> listFieldName = [];
  String translatedFieldName = '';

  RxList inputFields = [].obs;
  RxList inputFileFields = [].obs;
  RxBool hasFile = false.obs;

  @override
  void onInit() {
    getBasicData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late UpdateKycModel _kycModelData;

  UpdateKycModel get kycModelData => _kycModelData;

  Future<UpdateKycModel> getBasicData() async {
    inputFields.clear();
    inputFieldControllers.clear();
    _isLoading.value = true;
    update();

    // calling  from api service
    await ApiServices.getUserKYCInfo().then((value) {
      _kycModelData = value!;

      final data = _kycModelData.data.userKyc;

      for (int item = 0; item < data.length; item++) {
        // make the dynamic controller
        var textEditingController = TextEditingController();
        inputFieldControllers.add(textEditingController);

        // make dynamic input widget
        if (data[item].type.contains('file')) {
          hasFile.value = true;
          inputFileFields.add(
            Column(
              crossAxisAlignment: crossStart,
              children: [
                TitleHeading4Widget(
                  text: data[item].label,
                  textAlign: TextAlign.left,
                  color: CustomColor.primaryLightTextColor,
                  fontSize: Dimensions.headingTextSize3,
                  fontWeight: FontWeight.w600,
                ),
                verticalSpace(Dimensions.heightSize),
                UpdateKycImageWidget(
                  labelName: data[item].label,
                  fieldName: data[item].name,
                ),
              ],
            ),
          );
        } else if (data[item].type.contains('text') ||
            data[item].type.contains('textarea')) {
          inputFields.add(
            Column(
              children: [
                verticalSpace(Dimensions.heightSize),
                PrimaryInputWidget(
                  paddings: EdgeInsets.only(
                    left: Dimensions.widthSize,
                    right: Dimensions.widthSize,
                    // top: Dimensions.heightSize,
                    bottom: Dimensions.heightSize,
                  ),
                  controller: inputFieldControllers[item],
                  hint: data[item].label,
                  isValidator: data[item].required,
                  label: data[item].label,
                ),
              ],
            ),
          );
        }
      }

      _isLoading.value = false;
      update();
    }).catchError(
      (onError) {
        log.e(onError);
      },
    );
    update();
    return _kycModelData;
  }

  final _isUpdateLoading = false.obs;

  bool get isUpdateLoading => _isUpdateLoading.value;

  late CommonSuccessModel _kycUpdateModel;

  CommonSuccessModel get kycUpdateModel => _kycUpdateModel;

  // Profile update process with image
  Future<CommonSuccessModel> kycSubmitProcess() async {
    _isUpdateLoading.value = true;
    update();

    Map<String, String> inputBody = {};
    final data = kycModelData.data.userKyc;

    for (int i = 0; i < data.length; i += 1) {
      if (data[i].type != 'file') {
        inputBody[data[i].name] = inputFieldControllers[i].text;
      }
    }

    await ApiServices.updateKYCApi(
            body: inputBody, fieldList: listFieldName, pathList: listImagePath)
        .then((value) {
      _kycUpdateModel = value!;
      Get.offAllNamed(Routes.bottomNavBarScreen);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isUpdateLoading.value = false;
    update();
    return _kycUpdateModel;
  }

  void gotoNavigation(BuildContext context) {
    Get.offAllNamed(Routes.bottomNavBarScreen);
  }

  updateImageData(String fieldName, String imagePath) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      listImagePath[itemIndex] = imagePath;
    } else {
      listFieldName.add(fieldName);
      listImagePath.add(imagePath);
    }
    update();
  }

  String? getImagePath(String fieldName) {
    if (listFieldName.contains(fieldName)) {
      int itemIndex = listFieldName.indexOf(fieldName);
      return listImagePath[itemIndex];
    }
    return null;
  }
}
