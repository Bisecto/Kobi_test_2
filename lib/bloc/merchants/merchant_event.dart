part of 'merchant_bloc.dart';

@immutable
sealed class MerchantEvent {}

class GetMerchantInitialEvent extends MerchantEvent {
  GetMerchantInitialEvent();
}
