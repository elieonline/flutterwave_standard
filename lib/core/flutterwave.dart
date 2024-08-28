import 'package:flutter/material.dart';
import 'package:flutterwave_standard_auto/models/requests/customer.dart';
import 'package:flutterwave_standard_auto/models/requests/customizations.dart';
import 'package:flutterwave_standard_auto/models/requests/standard_request.dart';
import 'package:flutterwave_standard_auto/models/responses/charge_response.dart';
import 'package:flutterwave_standard_auto/models/subaccount.dart';
import 'package:flutterwave_standard_auto/view/flutterwave_style.dart';
import 'package:flutterwave_standard_auto/view/payment_widget.dart';

class Flutterwave {
  BuildContext context;
  String txRef;
  String amount;
  Customization? customization;
  Customer customer;
  bool isTestMode;
  String publicKey;
  String? paymentOptions;
  String? currency;
  String? paymentPlanId;
  String redirectUrl;
  List<SubAccount>? subAccounts;
  Map<dynamic, dynamic>? meta;
  FlutterwaveStyle? style;

  Flutterwave(
      {required this.context,
      required this.publicKey,
      required this.txRef,
      required this.amount,
      required this.customer,
      this.paymentOptions,
      this.customization,
      this.isTestMode = false,
      this.currency,
      this.paymentPlanId,
      required this.redirectUrl,
      this.subAccounts,
      this.meta,
      this.style});


  /// Starts Standard Transaction
  Future<ChargeResponse> charge() async {
    final request = StandardRequest(
        txRef: txRef,
        amount: amount,
        customer: customer,
        paymentOptions: paymentOptions,
        customization: customization,
        isTestMode: isTestMode,
        publicKey: publicKey,
        currency: currency,
        paymentPlanId: paymentPlanId,
        redirectUrl: redirectUrl,
        subAccounts: subAccounts,
        meta: meta);

    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentWidget(
          request: request,
          style: style ?? FlutterwaveStyle(),
          mainContext: context,
        ),
      ),
    );
  }
}
