part of 'transaction_bloc.dart';


abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final List<TransactionModel> transactions;
  final double totalAmount;

  TransactionSuccess({
    required this.transactions,
    required this.totalAmount,
  });
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError({required this.message});
}