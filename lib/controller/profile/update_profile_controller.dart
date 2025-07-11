import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../backend/model/common/common_success_model.dart';
import '../../backend/model/profile/profile_model.dart';
import '../../backend/services/api_services.dart';
import '../others/image_picker_controller.dart';

class UpdateProfileController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final businessNameController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final zipCodeController = TextEditingController();
  final imageController = Get.put(ProfileImagePicker());

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    businessNameController.dispose();
    countryController.dispose();
    phoneController.dispose();
    cityController.dispose();
    zipCodeController.dispose();
    imageController.dispose();
    super.dispose();
  }
             
  final RxString countryName = "US".obs;
  final RxString phoneCode = "".obs;
  
  File? image;
  RxBool haveImage = false.obs; 
  final picker = ImagePicker();

  Future chooseFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      haveImage.value = true;
    } else {}
    update();
  }

  Future chooseFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      haveImage.value = true;
    } else {}
    update();
  }
 
  
   
    
     
      
       
       
//!profile view
  RxBool myWallet = false.obs;
  RxBool buyGiftCard = false.obs;
  RxBool myGiftCard = false.obs;
  RxBool updateProfile = false.obs;
  RxBool updateKYCFrom = false.obs;
  RxBool fASecurity = false.obs;

  @override
  void onInit() {
    getProfileData();
    super.onInit();
  }

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late ProfileModel _profileModel;

  ProfileModel get profileModel => _profileModel;

  Future<ProfileModel> getProfileData() async {
    _isLoading.value = true;
    update();

    await ApiServices.profileAPi().then((value) {
      _profileModel = value!;

      var data = profileModel.data.user;
      firstNameController.text = data.firstname;
      lastNameController.text = data.lastname;
      businessNameController.text = data.businessName;
      emailController.text = data.email;
      phoneCode.value = data.mobileCode.toString();
      countryController.text = data.address.country;
      phoneController.text = data.mobile;
      cityController.text = data.address.city;
      zipCodeController.text = data.address.zip;
      countryName.value = data.address.country;
      phoneCode.value = data.mobileCode;
      //end of get data and start navigation
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _profileModel;
  }

  // api loading process indicator variable

  final _isUpdateLoading = false.obs;

  bool get isUpdateLoading => _isUpdateLoading.value;

  // --------------------------- Api function ----------------------------------
  // Profile update process without image
  Future<CommonSuccessModel> profileUpdateWithOutImageProcess() async {
    _isUpdateLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'business_name': businessNameController.text,
      'country': countryName.value.toString(),
      'phone_code': phoneCode.value.toString(),
      'phone': phoneController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
    };

    await ApiServices.updateProfileWithoutImageApi(body: inputBody)
        .then((value) {
      _profileUpdateModel = value!;
      // getProfileData();
      // Get.offAllNamed(Routes.bottomNavBarScreen);
      _isUpdateLoading.value = false;
      update();
      update();
    }).catchError((onError) {
      log.e(onError);
      _isUpdateLoading.value = false;
      update();
    });

    return _profileUpdateModel;
  }

  late CommonSuccessModel _profileUpdateModel;

  CommonSuccessModel get profileUpdateModel => _profileUpdateModel;

  // Profile update process with image
  Future<CommonSuccessModel> profileUpdateWithImageProcess() async {
    _isUpdateLoading.value = true;
    update();

    Map<String, String> inputBody = {
      'firstname': firstNameController.text,
      'lastname': lastNameController.text,
      'business_name': businessNameController.text,
      'country': countryName.value.toString(),
      'phone_code': phoneCode.value.toString(),
      'phone': phoneController.text,
      'city': cityController.text,
      'zip_code': zipCodeController.text,
    };

    await ApiServices.updateProfileWithImageApi(
      body: inputBody,
      filepath: imageController.imagePath.value,
    ).then((value) {
      _profileUpdateModel = value!;
      // getProfileData();
      // Get.offAllNamed(Routes.bottomNavBarScreen);
      _isUpdateLoading.value = false;
      update();
      update();
    }).catchError((onError) {
      log.e(onError);
      _isUpdateLoading.value = false;
      update();
    });

    return _profileUpdateModel;
  }

//
}
