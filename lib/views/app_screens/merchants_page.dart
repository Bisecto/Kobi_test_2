import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test_2/bloc/merchants/merchant_bloc.dart';
import 'package:kobi_test_2/utills/app_navigator.dart';

import '../../res/app_colors.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/app_loading_widget.dart';
import 'history_page.dart';
import 'history_page_widgets/appBar.dart';
import 'history_page_widgets/merchant_info_details.dart';

class MerchantPage extends StatefulWidget {
  const MerchantPage({super.key});

  @override
  State<MerchantPage> createState() => _MerchantPageState();
}

class _MerchantPageState extends State<MerchantPage> {
  MerchantBloc merchantBloc = MerchantBloc();

  @override
  void initState() {
    // TODO: implement initState
    merchantBloc.add(GetMerchantInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
          child: Column(
            children: [
              TextStyles.textHeadings(textValue: "Merchants", textSize: 20),

              SizedBox(height: 20),
              BlocConsumer<MerchantBloc, MerchantState>(
                bloc: merchantBloc,
                listenWhen: (previous, current) => current is! MerchantInitial,
                buildWhen: (previous, current) => current is! MerchantInitial,
                listener: (context, state) {
                  if (state is ErrorState) {
                    // MSG.warningSnackBar(
                    //     context, state.error);
                    Navigator.pop(context);
                  } else if (state is AccessTokenExpireState) {

                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {

                    case MerchantSuccess:
                      final merchants = state as MerchantSuccess;

                      return SizedBox(
                        height: AppUtils.deviceScreenSize(context).height - 100,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: merchants.merchants.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 7),
                          itemBuilder: (context, index) {
                            final merchant = merchants.merchants[index];
                            return FadeInMerchantCard(
                              merchant: merchant,
                              index: index,
                            );
                          },
                        ),
                      );

                    case LoadingState:
                      return const Center(
                        child: AppLoadingPage("Fetching merchants..."),
                      );
                    default:
                      return const Center(
                        child: AppLoadingPage("Fetching merchants..."),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FadeInMerchantCard extends StatefulWidget {
  final dynamic merchant;
  final int index;

  const FadeInMerchantCard({
    Key? key,
    required this.merchant,
    required this.index,
  }) : super(key: key);

  @override
  State<FadeInMerchantCard> createState() => _FadeInMerchantCardState();
}

class _FadeInMerchantCardState extends State<FadeInMerchantCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              widget.merchant.merchantImage,
            ),
            radius: 28,
          ),
          title: Text(
            widget.merchant.merchantName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            widget.merchant.merchantDescription,
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              AppNavigator.pushAndStackPage(
                context,
                page: HistoryPage(merchant: widget.merchant),
              );
            },
          ),
        ),
      ),
    );
  }
}