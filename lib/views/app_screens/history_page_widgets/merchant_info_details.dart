import 'package:flutter/material.dart';
import 'package:kobi_test_2/model/merchant_model.dart';

import '../../widgets/app_custom_text.dart';

class MerchantInfoWidget extends StatelessWidget {
  final Merchant merchant;

  const MerchantInfoWidget({super.key, required this.merchant});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(merchant.merchantImage),
          radius: 35,
        ),
        SizedBox(height: 10),
        TextStyles.textHeadings(textValue: merchant.merchantName, textSize: 25),
        CustomText(
          text: merchant.merchantDescription,
          size: 18,
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}
