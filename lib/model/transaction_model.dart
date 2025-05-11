class TransactionModel {
  final String merchantId;
  final String merchantImage;
  final String merchantSubCategory;
  final double amountPaid;
  final DateTime dateOfTransaction;
  final String transactionId;

  TransactionModel({
    required this.merchantId,
    required this.merchantImage,
    required this.merchantSubCategory,
    required this.amountPaid,
    required this.dateOfTransaction,
    required this.transactionId,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      merchantId: json['merchantId'],
      merchantImage: json['merchantImage'],
      merchantSubCategory: json['merchantSubCategory'],
      amountPaid: json['amountPaid'].toDouble(),
      dateOfTransaction: DateTime.parse(json['dateOfTransaction']),
      transactionId: json['transactionId'],
    );
  }
}