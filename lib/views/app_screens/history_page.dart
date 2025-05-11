import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test_2/bloc/merchants/merchant_bloc.dart';
import 'package:kobi_test_2/model/merchant_model.dart';

import '../../res/app_colors.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/app_loading_widget.dart';
import 'history_page_widgets/merchant_info_details.dart';
import 'history_page_widgets/transaction_history_page.dart';

class HistoryPage extends StatefulWidget {
  final Merchant merchant;

  const HistoryPage({super.key, required this.merchant});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          widget.merchant.merchantName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              children: [

                const SizedBox(height: 20),
                MerchantInfoWidget(merchant: widget.merchant),
                TransactionHistoryPage(
                  merchantId: widget.merchant.merchantId,
                  merchantName: widget.merchant.merchantName,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}