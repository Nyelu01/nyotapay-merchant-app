import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyotapay/utils/size.dart';

import '../../controller/auth/registration/kyc_form_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../text_labels/title_heading3_widget.dart';
import '../text_labels/title_heading4_widget.dart';

final basicController = Get.put(BasicDataController(), permanent: true);

class CountryInputWidget extends StatefulWidget {
  final String hint, label;
  final RxString countryCode;
  final int maxLines;
  final bool isValidator;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;

  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;

  const CountryInputWidget({
    Key? key,
    required this.controller,
    required this.hint,
    this.isValidator = true,
    this.maxLines = 1,
    this.paddings,
    required this.label,
    this.readOnly = false,
    required this.countryCode,
    this.keyBoardType,
    this.textInputAction,
  }) : super(key: key);

  @override
  State<CountryInputWidget> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<CountryInputWidget> {
  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeading4Widget(
          text: widget.label,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode
              ? CustomColor.primaryDarkTextColor
              : CustomColor.primaryTextColor,
        ),
        verticalSpace(7),
        TextFormField(
          keyboardType: widget.keyBoardType,
          textInputAction: widget.textInputAction,
          validator: widget.isValidator == false
              ? null
              : (String? value) {
                  if (value!.isEmpty) {
                    return Strings.pleaseFillOutTheField.tr;
                  } else {
                    return null;
                  }
                },
          controller: widget.controller,
          onTap: () {
            _openDialogue(context);
            setState(
              () {
                focusNode!.requestFocus();
              },
            );
          },
          onFieldSubmitted: (value) {
            setState(() {
              focusNode!.unfocus();
            });
          },
          focusNode: focusNode,
          textAlign: TextAlign.left,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryTextColor,
            fontWeight: FontWeight.w600,
            fontSize: Dimensions.headingTextSize3,
          ),
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize3,
              fontWeight: FontWeight.w500,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor.withOpacity(0.5)
                  : CustomColor.primaryTextColor.withOpacity(0.2),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(
                  color: CustomColor.transparent,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide:
                    BorderSide(width: 2, color: Theme.of(context).primaryColor),
              ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.heightSize * 1.7,
              vertical: Dimensions.widthSize,
            ),
          ),
        ),
      ],
    );
  }

  _openDialogue(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: Dimensions.paddingSize * 0.7,
                top: Dimensions.paddingSize,
                bottom: Dimensions.paddingSize * 0.5,
                right: Dimensions.paddingSize * 0.3,
              ),
              decoration: BoxDecoration(
                  color: CustomColor.blackColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius)),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.bottomCenter,
              child: ListView.builder(
                  itemCount:
                      basicController.basicDataModel.data.countries.length,
                  itemBuilder: (BuildContext context, int index) {
                    var data = basicController.basicDataModel.data.countries;
                    var code = basicController
                        .basicDataModel.data.countries[index].mobileCode;
                    var country = basicController
                        .basicDataModel.data.countries[index].name;
                    return InkWell(
                      highlightColor: Colors.yellow.withOpacity(0.9),
                      splashColor: Colors.red.withOpacity(0.8),
                      focusColor: Colors.green.withOpacity(0.0),
                      hoverColor: Colors.blue.withOpacity(0.8),
                      onTap: () {
                        basicController.countryCode.value = code;
                        widget.countryCode.value = code;
                        widget.controller.text = country;

                        // LocalStorage.saveCountryCode(countryCodeValue: code);
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSize * 0.5),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TitleHeading3Widget(
                                text: data[index].mobileCode,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: TitleHeading3Widget(
                                text: data[index].name,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Positioned(
              right: 15,
              top: 15,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.close,
                  size: Dimensions.heightSize * 2.4,
                  color: CustomColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
