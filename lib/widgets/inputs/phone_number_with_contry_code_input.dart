import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nyotapay/utils/size.dart';

import '../../language/language_controller.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../text_labels/title_heading3_widget.dart';
import '../text_labels/title_heading4_widget.dart';

class PhoneNumberInputWidget extends StatefulWidget {
  final String hint, label;
  final RxString countryCode;
  final int maxLines;
  final bool isValidator;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final TextInputAction? textInputAction;

  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;

  const PhoneNumberInputWidget({
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
  State<PhoneNumberInputWidget> createState() => _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<PhoneNumberInputWidget> {
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

  final languageController = Get.put(LanguageController());

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
                    return Strings.pleaseFillOutTheField;
                  } else {
                    return null;
                  }
                },
          controller: widget.controller,
          onTap: () {
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
            hintText: languageController.getTranslation(widget.hint),
            hintStyle: GoogleFonts.inter(
              fontSize: Dimensions.headingTextSize3,
              fontWeight: FontWeight.w500,
              color: CustomColor.primaryTextColor.withOpacity(0.2),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              borderSide: const BorderSide(
                  width: 2, color: CustomColor.primaryTextColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.7),
              borderSide:
                  const BorderSide(width: 2, color: CustomColor.whiteColor),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.widthSize * 1.7,
              vertical: Dimensions.heightSize,
            ),
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.marginSizeHorizontal * 0.5),
                  child: Obx(
                    () => TitleHeading3Widget(
                      text: widget.countryCode.value,
                      color: Get.isDarkMode
                          ? CustomColor.primaryDarkTextColor
                          : CustomColor.primaryTextColor,
                    ),
                  ),
                ),
                Container(
                    width: 1.6,
                    height: Dimensions.heightSize * 2,
                    color: CustomColor.primaryTextColor),
                horizontalSpace(Dimensions.widthSize)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
