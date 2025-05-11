import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kobi_test_2/utills/app_navigator.dart';
import 'package:kobi_test_2/utills/app_utils.dart';
import 'package:kobi_test_2/views/app_screens/history_page_widgets/transaction_detail.dart';
import 'package:kobi_test_2/views/widgets/app_loading_widget.dart';
import 'package:kobi_test_2/views/widgets/dialog_box.dart';

import '../../../bloc/transactions/transaction_bloc.dart';
import '../../widgets/app_custom_text.dart';

class TransactionHistoryPage extends StatefulWidget {
  final String merchantId;
  final String merchantName;

  const TransactionHistoryPage({
    Key? key,
    required this.merchantId,
    required this.merchantName,
  }) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TransactionBloc transactionBloc;
  String selectedMonth = 'May';
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    transactionBloc = TransactionBloc();
    transactionBloc.add(GetTransactionsEvent(merchantId: widget.merchantId));
  }

  @override
  void dispose() {
    _animationController.dispose();
    transactionBloc.close();
    super.dispose();
  }

  String getTransactionTimeText(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today ${DateFormat('hh:mm a').format(date)}';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Yesterday ${DateFormat('hh:mm a').format(date)}';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow ${DateFormat('hh:mm a').format(date)}';
    } else {
      return DateFormat('MMM d, yyyy hh:mm a').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: BlocConsumer<TransactionBloc, TransactionState>(
        bloc: transactionBloc,
        listener: (context, state) {
          if (state is TransactionError) {
            MSG.warningSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is TransactionLoading) {
            return Container(
              height: 300,
              alignment: Alignment.center,
              child: const AppLoadingPage(("Fetching transactions...")),
            );
          } else if (state is TransactionSuccess) {
            return _buildTransactionUI(state, screenHeight, screenWidth);
          } else {
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: const CustomText(text: 'No transactions available'),
            );
          }
        },
      ),
    );
  }

  Widget _buildTransactionUI(
    TransactionSuccess state,
    double screenHeight,
    double screenWidth,
  ) {
    final listItemHeight = 85.0;
    final headerHeight = 400.0;

    final maxListItems = 50;
    final numItems = math.min(state.transactions.length, maxListItems);
    final listHeight = numItems * listItemHeight;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _buildTotalPaymentSection(state),
          ),

          const SizedBox(height: 24),

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1900),
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _buildDonutChart(state),
          ),

          const SizedBox(height: 24),

          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2100),
            curve: Curves.easeOutQuad,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(
                  text: 'Transaction',

                  size: 20,
                  weight: FontWeight.bold,
                  color: Colors.black87,
                ),
                if (state.transactions.length > maxListItems)
                  TextButton(
                    onPressed: () {
                      MSG.warningSnackBar(context, "No Action Registered");
                    },
                    child: const CustomText(
                      text: 'View all',

                      color: Colors.blue,
                      weight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildLimitedTransactionList(state, maxListItems),
        ],
      ),
    );
  }

  Widget _buildLimitedTransactionList(TransactionSuccess state, int maxItems) {
    final displayedTransactions = state.transactions.take(maxItems).toList();

    return Column(
      children: List.generate(displayedTransactions.length, (index) {
        final transaction = displayedTransactions[index];

        return AnimatedOpacity(
          opacity: 1.0,
          duration: Duration(milliseconds: 1500),
          curve: Curves.easeIn,
          // Each item gets a longer delay based on its position
          // to create a sequential fade-in effect
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 500),
            // Stagger the animations by delaying each item
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                AppNavigator.pushAndStackPage(
                  context,
                  page: TransactionDetailPage(
                    transaction: transaction,
                    merchantName: widget.merchantName,
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
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
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 24,
                    child: ClipOval(
                      child: Image.network(
                        transaction.merchantImage,
                        width: 28,
                        height: 28,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.business, color: Colors.white);
                        },
                      ),
                    ),
                  ),
                  title: CustomText(
                    text:
                    '${widget.merchantName} ${transaction.merchantSubCategory}',
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                  subtitle: CustomText(
                    text: getTransactionTimeText(transaction.dateOfTransaction),
                    color: Colors.grey[600],
                    size: 13,
                  ),
                  trailing: CustomText(
                    text: '-\$${transaction.amountPaid.toStringAsFixed(2)}',
                    color: Colors.redAccent,
                    weight: FontWeight.w600,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  Widget _buildTotalPaymentSection(TransactionSuccess state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(
              text: 'Total payment',
              size: 16,
              color: Colors.black87,
              weight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                TextStyles.textHeadings(
                  textValue: '${state.totalAmount.toStringAsFixed(2)}',
                  textSize: 32,
                ),
                TextStyles.textHeadings(
                  textValue: ' \$',

                  textSize: 32,
                  textColor: Colors.red,
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButton<String>(
            value: selectedMonth,
            icon: const Icon(Icons.keyboard_arrow_down),
            underline: const SizedBox(),
            onChanged: (String? newValue) {
              setState(() {
                selectedMonth = newValue!;
              });
            },
            items:
                months.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: CustomText(text: value),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDonutChart(TransactionSuccess state) {
    return SizedBox(
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              centerSpaceRadius: 70,
              sectionsSpace: 2,
              startDegreeOffset: -90,
              sections: _generatePieChartSections(state),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: '${state.totalAmount.toStringAsFixed(2)}',

                    size: 28,
                    weight: FontWeight.bold,
                  ),
                  const CustomText(
                    text: ' \$',

                    size: 28,
                    weight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ],
              ),
              CustomText(
                text: '${widget.merchantName} Expenses',

                size: 14,
                color: Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _generatePieChartSections(
    TransactionSuccess state,
  ) {
    final List<double> fixedValues = [40, 20, 10, 5, 15, 5];

    final List<Color> colors = [
      Colors.purple.shade400,
      Colors.green.shade400,
      Colors.blue.shade300,
      Colors.teal.shade300,
      Colors.pink.shade200,
      Colors.amber.shade300,
    ];

    List<PieChartSectionData> sections = [];

    for (int i = 0; i < 6; i++) {
      sections.add(
        PieChartSectionData(
          color: colors[i],
          value: fixedValues[i],
          title: '',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return sections;
  }
}
