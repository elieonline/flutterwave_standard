import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutterwave_standard_auto/core/TransactionCallBack.dart';

class FlutterwaveInAppBrowser extends InAppBrowser {
  final TransactionCallBack callBack;
  final bool debugMode;

  var hasCompletedProcessing = false;
  var haveCallBacksBeenCalled = false;

  FlutterwaveInAppBrowser({required this.callBack, this.debugMode = false});

  @override
  Future onBrowserCreated() async {}

  @override
  Future onLoadStart(url) async {
    if (debugMode) {
      print("current url is $url");
    }
    final status = url?.queryParameters["status"];
    final txRef = url?.queryParameters["tx_ref"];
    final id = url?.queryParameters["transaction_id"];
    final hasRedirected = status != null && txRef != null;
    if (hasRedirected && url != null) {
      hasCompletedProcessing = hasRedirected;
      _processResponse(url, status, txRef, id);
    }
  }

  _processResponse(Uri url, String? status, String? txRef, String? id) {
    if ("successful" == status || "completed" == status) {
      callBack.onTransactionSuccess(id: id, txRef: txRef!);
    } else {
      callBack.onCancelled(id: id, txRef: txRef, status: status);
    }
    haveCallBacksBeenCalled = true;
    close();
  }

  @override
  Future onLoadStop(url) async {}

  @override
  void onLoadError(url, code, message) {
    if (debugMode) {
      print("error is $message");
    }
    callBack.onTransactionError(message);
  }

  @override
  void onProgressChanged(progress) {}

  @override
  void onExit() {
    if (!haveCallBacksBeenCalled) {
      callBack.onCancelled();
    }
  }
}
