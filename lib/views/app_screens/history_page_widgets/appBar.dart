import 'package:flutter/material.dart';
import 'package:kobi_test_2/res/app_colors.dart';
import 'package:kobi_test_2/views/widgets/app_custom_text.dart';

class HistoryAppBar extends StatelessWidget {
  final String name;
  final String image;

  const HistoryAppBar({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 40,
            width: 30,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          TextStyles.textHeadings(textValue: name,textSize: 18),
          Icon(Icons.more_vert)
        ],
      ),
    );
  }
}
