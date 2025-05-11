part of 'transaction_bloc.dart';

abstract class TransactionEvent {}

class GetTransactionsEvent extends TransactionEvent {
  final String merchantId;

  GetTransactionsEvent({required this.merchantId});
}