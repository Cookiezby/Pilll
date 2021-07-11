import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PremiumIntroductionHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 111,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Center(child: SvgPicture.asset("images/pillll_premium_logo.svg")),
        ],
      ),
    );
  }
}
