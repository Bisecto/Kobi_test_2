part of 'merchant_bloc.dart';

@immutable
sealed class MerchantState {}

final class MerchantInitial extends MerchantState {}

class LoadingState extends MerchantState {}

class OnClickedState extends MerchantState {}

class ErrorState extends MerchantState {
  final String error;

  ErrorState(this.error);
}

class MerchantSuccess extends MerchantState {
  final List<Merchant> merchants;

  MerchantSuccess(this.merchants);
}

class AccessTokenExpireState extends MerchantState {}

class InitialSuccessState extends MerchantState {
  final String msg;

  InitialSuccessState(this.msg);
}
