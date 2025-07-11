import 'package:flutter/material.dart';
import 'package:nyotapay/utils/custom_color.dart';
import 'package:nyotapay/utils/dimensions.dart';
import 'package:nyotapay/widgets/text_labels/title_heading4_widget.dart';

import 'back_button.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback? onTapLeading;
  final VoidCallback? onTapAction;
  final bool homeButtonShow;
  final IconData? actionIcon;
  final PreferredSizeWidget? bottomBar;

  const AppBarWidget(
      {required this.text,
      this.onTapLeading,
      this.onTapAction,
      this.homeButtonShow = false,
      this.actionIcon,
      super.key,
      this.bottomBar});

  @override
  Widget build(BuildContext context) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return AppBar(
      title: TitleHeading4Widget(
        text: text,
        fontSize: isTablet()
            ? Dimensions.headingTextSize3
            : Dimensions.headingTextSize1,
        fontWeight: FontWeight.w500,
        color: CustomColor.primaryLightColor,
      ),
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: [
        Visibility(
          visible: homeButtonShow,
          child: IconButton(
            onPressed: onTapAction,
            icon: Icon(
              actionIcon ?? Icons.home,
              color: CustomColor.primaryLightColor,
              size: Dimensions.iconSizeDefault,
            ),
          ),
        )
      ],
      bottom: bottomBar,
      leading: BackButtonWidget(
        onTap: onTapLeading ??
            () {
              Navigator.pop(context);
            },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Dimensions.appBarHeight * 0.7);
}
