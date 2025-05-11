import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../model/transaction_model.dart';
import '../../repository/repository.dart';
import '../../res/apis.dart';

part 'transaction_event.dart';

part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<GetTransactionsEvent>(_getTransactions);
  }

  Future<void> _getTransactions(
      GetTransactionsEvent event,
      Emitter<TransactionState> emit,
      ) async {
    emit(TransactionLoading());
    try {
      AppRepository repository = AppRepository();
      final response = await repository.getRequest(
          AppApis.getTransactionList);
      // final response = await http.get(
      //   Uri.parse('https://mocki.io/v1/53d63c19-62d4-4de7-9279-fcaa7716e9b1'),
      //   headers: {
      //     'Content-Type': 'application/json',
      //     // Add your auth headers here if needed
      //   },
      // );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['transactions'];
        print(data);
        final List<TransactionModel> transactions = data
            .map((json) => TransactionModel.fromJson(json))
            .toList();
        print(event.merchantId);;
        print(transactions[0].merchantId);
        print(transactions[1].merchantId);
        print(transactions[2].merchantId);
        print(transactions[3].merchantId);
        print(transactions[4].merchantId);
        print(transactions[5].merchantId);
        print(transactions[6].merchantId);
        final filteredTransactions = transactions
            .where((tx) => tx.merchantId.toLowerCase() == event.merchantId)
            .toList();
        // Calculate total amount
        double totalAmount = 0;
        for (var transaction in filteredTransactions) {
          totalAmount += transaction.amountPaid;
        }

        emit(TransactionSuccess(
          transactions: filteredTransactions,
          totalAmount: totalAmount,
        ));
      } else {
        emit(TransactionError(message: 'Failed to load transactions'));
      }
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }
}
