import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kobi_test_2/utills/app_utils.dart';
import 'package:kobi_test_2/res/app_colors.dart';

import 'package:kobi_test_2/model/transaction_model.dart';
import 'package:kobi_test_2/views/widgets/app_custom_text.dart';
import 'package:kobi_test_2/views/widgets/form_button.dart';

class TransactionDetailPage extends StatefulWidget {
  final TransactionModel transaction;
  final String merchantName;

  const TransactionDetailPage({
    Key? key,
    required this.transaction,
    required this.merchantName,
  }) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

bool isAmountRefunded = false;

class _TransactionDetailPageState extends State<TransactionDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    isAmountRefunded = false;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          'Transaction Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTransactionSummaryCard(context),

              const SizedBox(height: 16),

              _buildDetailsSection(context),

              const SizedBox(height: 16),
              if (!isAmountRefunded)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormButton(
                    onPressed: () {
                      setState(() {
                        isAmountRefunded = !isAmountRefunded;
                      });
                    },
                    text: "Request Refund",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionSummaryCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.black,
            radius: 24,
            child: ClipOval(
              child: Image.network(
                widget.transaction.merchantImage,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.business, color: Colors.white);
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: '\$${widget.transaction.amountPaid.toStringAsFixed(2)}',
                  size: 36,
                  weight: FontWeight.bold,
                  color: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!isAmountRefunded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    text: 'Completed',
                      color: Colors.green.shade700,
                      weight: FontWeight.w600,
                      size: 14,
                  ),
                ],
              ),
            ),
          if (isAmountRefunded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    text: 'Refunded',

                      color: Colors.orange.shade700,
                      weight: FontWeight.w600,
                      size: 14,

                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          CustomText(
            text: DateFormat(
              'MMMM dd, yyyy • hh:mm a',
            ).format(widget.transaction.dateOfTransaction),
            size: 16, color: Colors.grey[600]),

        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomText(
            text: 'Transaction Details',
            size: 18,
            weight: FontWeight.bold,
            color: Colors.black87,
          ),
          const SizedBox(height: 20),

          _buildDetailRow(
            context,
            title: 'Merchant',
            value: widget.merchantName,
            iconData: Icons.storefront_outlined,
          ),

          const Divider(height: 24),

          _buildDetailRow(
            context,
            title: 'Category',
            value: widget.transaction.merchantSubCategory,
            iconData: Icons.category_outlined,
          ),

          const Divider(height: 24),

          _buildDetailRow(
            context,
            title: 'Transaction ID',
            value: _formatTransactionId(widget.transaction.transactionId),
            iconData: Icons.receipt_long_outlined,
            valueStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontFamily: 'Monospace',
              letterSpacing: -0.5,
            ),
          ),

          const Divider(height: 24),

          _buildDetailRow(
            context,
            title: 'Reference Number',
            value:
                'REF-${widget.transaction.transactionId.substring(0, 8).toUpperCase()}',
            iconData: Icons.numbers_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String title,
    required String value,
    required IconData iconData,
    TextStyle? valueStyle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(iconData, color: Colors.green[700], size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: title),
              SizedBox(height: 4),
              Text(
                value,
                style:
                    valueStyle ??
                    const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTransactionId(String id) {
    if (id.length > 8) {
      return '${id.substring(0, 8)}...${id.substring(id.length - 4)}';
    }
    return id;
  }
}
