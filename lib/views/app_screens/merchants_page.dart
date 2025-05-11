import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kobi_test_2/bloc/merchants/merchant_bloc.dart';

import '../../res/app_colors.dart';
import '../../utills/app_utils.dart';
import '../widgets/app_custom_text.dart';
import '../widgets/app_loading_widget.dart';
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
              TextStyles.textHeadings(textValue: "Merchants",textSize: 20),

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
                    // AppNavigator
                    //     .pushAndRemovePreviousPages(
                    //     context,
                    //     page:
                    //     const ExistingSignIn());
                  }
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                  // case PostsFetchingState:
                  //   return const Center(
                  //     child: CircularProgressIndicator(),
                  //   );
                    case MerchantSuccess:
                      final merchants = state as MerchantSuccess;

                      return Container(
                        height: AppUtils.deviceScreenSize(context).height-100,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(8),
                          itemCount: merchants.merchants.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 7),
                          itemBuilder: (context, index) {
                            final merchant = merchants.merchants[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    merchant.merchantImage,
                                  ),
                                  radius: 28,
                                ),
                                title: Text(
                                  merchant.merchantName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  merchant.merchantDescription,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.arrow_forward_ios),
                                  onPressed: () {
                                    // Navigate to transaction page
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder:
                                    //         (_) => MerchantTransactionPage(
                                    //           merchantId: merchant.merchantId,
                                    //         ),
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
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
