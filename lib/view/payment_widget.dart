import 'package:flutter/material.dart';
import 'package:flutterwave_standard_auto/core/TransactionCallBack.dart';
import 'package:flutterwave_standard_auto/models/requests/standard_request.dart';
import 'package:flutterwave_standard_auto/models/responses/charge_response.dart';
import 'package:flutterwave_standard_auto/core/navigation_controller.dart';
import 'package:flutterwave_standard_auto/view/view_utils.dart';
import 'package:http/http.dart';

import 'flutterwave_style.dart';

class PaymentWidget extends StatefulWidget {
  final FlutterwaveStyle style;
  final StandardRequest request;
  final BuildContext mainContext;

  PaymentWidget(
      {required this.request, required this.style, required this.mainContext});

  @override
  State<StatefulWidget> createState() => _PaymentState();
}

class _PaymentState extends State<PaymentWidget>
    implements TransactionCallBack {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late NavigationController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePayment();
    });
  }

  @override
  Widget build(BuildContext context) {
    controller = NavigationController(Client(), widget.style, this);
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: widget.request.isTestMode,
      home: Scaffold(
          backgroundColor: widget.style.getMainBackgroundColor(),
          body: widget.style.initialLoadingWidget ??
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: widget.style.progressIndicatorColor),
                    const SizedBox(height: 10),
                    Text(
                      widget.style.getProgressText,
                      textAlign: TextAlign.center,
                      style: widget.style.mainTextStyle,
                    ),
                  ],
                ),
              )),
    );
  }

  void _handlePayment() async {
    try {
      controller.startTransaction(widget.request);
    } catch (error) {
      _showErrorAndClose(error.toString());
    }
  }

  void _showErrorAndClose(final String errorMessage) {
    FlutterwaveViewUtils.showToast(widget.mainContext, errorMessage);
    Navigator.pop(widget.mainContext); // return response to user
  }

  @override
  onTransactionError([String? message]) {
    _showErrorAndClose(message ?? "transaction error");
  }

  @override
  onCancelled({String? id, String? txRef, String? status}) {
    final ChargeResponse chargeResponse = ChargeResponse(
        status: status, success: false, transactionId: id, txRef: txRef);
    Navigator.pop(this.widget.mainContext, chargeResponse);
  }

  @override
  onTransactionSuccess({String? id, String? txRef, String? status}) {
    final ChargeResponse chargeResponse = ChargeResponse(
        status: "success", success: true, transactionId: id, txRef: txRef);
    Navigator.pop(this.widget.mainContext, chargeResponse);
  }
}
