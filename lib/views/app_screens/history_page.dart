import 'package:flutter/material.dart';

import '../../res/app_colors.dart';
import 'history_page_widgets/appBar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0,right: 20,top: 10),
          child: const Column(
            children: [HistoryAppBar(name: 'History', image: '')],
          ),
        ),
      ),
    );
  }
}
