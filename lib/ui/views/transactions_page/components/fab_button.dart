import 'package:al_ameen_employer_app/ui/views/add_details_page/add_details_page.dart';
import 'package:al_ameen_employer_app/utils/shared_preference.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FabWidget extends StatelessWidget {
  const FabWidget(this.sharedPref, {super.key});
  final SharedPreferencesServices sharedPref;

  @override
  Widget build(BuildContext context) {
    final isTablet = SizerUtil.deviceType == DeviceType.tablet;

    return OpenContainer(
      key: const Key('open_add_details_page'),
      transitionDuration: const Duration(seconds: 1),
      closedShape: const CircleBorder(),
      closedColor: Theme.of(context).primaryColor,
      openColor: Theme.of(context).primaryColor,
      openBuilder: (context, action) =>
          AddDetailsPage(sharedPref.checkLoginStatus()),
      closedBuilder: (context, action) =>
          //const SizedBox(),
          Container(
        height: 6.h,
        width: 6.h,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).primaryColor),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: isTablet ? 12.sp : 15.sp,
        ),
      ),
    );
  }
}
