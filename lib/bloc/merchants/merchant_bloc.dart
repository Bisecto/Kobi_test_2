import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:kobi_test_2/res/apis.dart';
import 'package:meta/meta.dart';

import '../../model/merchant_model.dart';
import '../../repository/repository.dart';
import '../../utills/app_utils.dart';

part 'merchant_event.dart';

part 'merchant_state.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  MerchantBloc() : super(MerchantInitial()) {
    on<GetMerchantInitialEvent>(getMerchantInitialEvent);

    // on<MerchantEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
  }

  FutureOr<void> getMerchantInitialEvent(
    GetMerchantInitialEvent event,
    Emitter<MerchantState> emit,
  ) async {
    emit(LoadingState());
    //emit(LeviesSuccessState());
    AppRepository repository = AppRepository();
    try {
      final merchantMethodResponse = await repository.getRequest(
          AppApis.getMerchantApi);


      if (merchantMethodResponse.statusCode == 200 ||
          merchantMethodResponse.statusCode == 201) {
        List<dynamic> paymentMethodListResponse =
        json.decode(merchantMethodResponse.body)['merchants'];

        List<Merchant> merchantMethodList = paymentMethodListResponse
            .map((item) => Merchant.fromJson(item))
            .toList();
        emit(MerchantSuccess(
          merchantMethodList,
           ));
      } else {
        emit(ErrorState(json.decode(merchantMethodResponse.body)['detail'] ??
            json.decode(merchantMethodResponse.body)['error']));
        AppUtils().debuglog(json.decode(merchantMethodResponse.body));
        emit(MerchantInitial());
      }
    } catch (e) {
      AppUtils().debuglog(e);
      emit(MerchantInitial());
      AppUtils().debuglog(12345678);
    }
  }
}
