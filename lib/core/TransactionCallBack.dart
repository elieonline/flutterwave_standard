abstract class TransactionCallBack {
  onTransactionSuccess({String? id, String? txRef, String? status});
  onTransactionError([String? message]);
  onCancelled({String? id, String? txRef, String? status});
}