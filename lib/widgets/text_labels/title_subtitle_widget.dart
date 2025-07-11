import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nyotapay/utils/custom_style.dart';
import 'package:nyotapay/widgets/text_labels/custom_title_heading_widget.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import 'title_heading1_widget.dart';

class TitleSubTitleWidget extends StatelessWidget {
  const TitleSubTitleWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.crossAxisAlignment = CrossAxisAlignment.start})
      : super(key: key);
  final String title, subtitle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        TitleHeading1Widget(
          text: title,
          padding: EdgeInsets.only(bottom: Dimensions.paddingSize * 0.3),
          color: Get.isDarkMode
              ? CustomColor.primaryDarkTextColor
              : CustomColor.primaryLightTextColor,
        ),
        CustomTitleHeadingWidget(
          text: subtitle,
          textAlign: TextAlign.center,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontSize: Dimensions.headingTextSize4,
            fontWeight: FontWeight.w500,
            color: CustomColor.primaryLightTextColor.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
