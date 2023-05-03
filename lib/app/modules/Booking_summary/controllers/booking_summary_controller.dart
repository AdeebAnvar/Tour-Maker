// ignore_for_file: unnecessary_overrides

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:pdf/widgets.dart' as pw;
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../../core/theme/style.dart';
import '../../../data/models/local_model/customer.dart';
import '../../../data/models/local_model/invoice_item.dart';
import '../../../data/models/local_model/supplier.dart';
import '../../../data/models/network_models/razorpay_model.dart';
import '../../../data/models/network_models/single_booking_model.dart';
import '../../../data/repo/local_repo/pdf_api.dart';
import '../../../data/repo/local_repo/pdf_invoice_api.dart';
import '../../../data/repo/network_repo/booking_repo.dart';
import '../../../data/repo/network_repo/passenger_repo.dart';
import '../../../data/repo/network_repo/razorpay_repo.dart';
import '../../../routes/app_pages.dart';
import '../../../services/network_services/dio_client.dart';
import '../views/booking_summary_view.dart';

class BookingSummaryController extends GetxController
    with StateMixin<BookingSummaryView> {
  // final pw.Document pdf = pw.Document();
  RxList<SingleBookingModel> bookingList = <SingleBookingModel>[].obs;
  Rx<bool> isLoading = false.obs;
  Rx<OrderPaymentModel> orderPaymentModel = OrderPaymentModel().obs;
  late Razorpay razorPay;
  int? id;
  @override
  void onInit() {
    super.onInit();
    loadData();
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void loadData() {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      id = Get.arguments as int;
      log('sfg $id');
      loadBookingDetails(id!);
    }
  }

  Future<void> loadBookingDetails(int id) async {
    final ApiResponse<List<SingleBookingModel>> res =
        await BookingRepository().getSingleBooking(id);
    log('message ${res.message}');
    if (res.data != null) {
      bookingList.value = res.data!;
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  int getTotalTravellersCount() {
    final int sum = bookingList[0].noOfAdults! + bookingList[0].noOfKids!;
    return sum;
  }

  num getRemainingAmount() {
    final num sum = bookingList[0].payableAmount! - bookingList[0].amountPaid!;
    return sum;
  }

  void onClickPassengers(int? id) {
    Get.toNamed(Routes.TRAVELLERS_SCREEN, arguments: id)!
        .whenComplete(() => loadData());
  }

  Future<void> onClickPayRemainingAmount(int id) async {
    isLoading.value = true;
    log('Payment pay full amount id $id');
    //CreatePayment
    orderPaymentModel.value = await createPayment(id);
    log('Payment pay full amount orderPayment ${orderPaymentModel.value.id}');
    log('kunukunu ${orderPaymentModel.value}');
    // //open razorpay
    openRazorPay(orderPaymentModel.value.id.toString());
    isLoading.value = false;
  }

  Future<OrderPaymentModel> createPayment(int iD) async {
    log('Payment xcreate $iD');
    final OrderPaymentModel omp =
        OrderPaymentModel(orderId: iD, currency: 'INR');

    try {
      final ApiResponse<OrderPaymentModel> res =
          await PassengerRepository().createRemainingAmountPayment(omp);
      log('dsgaefv d ms${res.message}');
      log('dsgaefv d ${res.data}');
      log('dsgaefv d ${res.status}');

      if (res.data != null) {
        orderPaymentModel.value = res.data!;
      } else {
        // log(' adeeb raz emp ');
      }
    } catch (e) {
      log('raz catch $e');
    }
    return orderPaymentModel.value;
  }

  void openRazorPay(String paymentID) {
    log('Payment openRazorPay $paymentID');
    final Map<String, Object?> options = <String, Object?>{
      'key': 'rzp_test_yAFypxWUiCD7H7',
      'name': 'TourMaker',
      'description': 'Pay for your Package Order',
      'order_id': paymentID,
      'external': <String, Object?>{
        'wallets': <String>['paytm'],
      },
    };
    log('adeeb anvar $options');

    try {
      razorPay.open(options);
      log('adeeb anvar raz op');
    } catch (e) {
      log('kunukunu error op $e');
      log('Error opening Razorpay checkout: $e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final String? signature = response.signature;
    final String? orderId = orderPaymentModel.value.id;
    final String? paymentId = response.paymentId;
    log('Payment bbddibdi sing $signature');
    log('Payment bbddibdi id $orderId');
    log('Payment bbddibdi payid $paymentId');

    final ApiResponse<bool> res = await RazorPayRepository()
        .verifyOrderPayment(paymentId, signature, orderId);
    try {
      if (res.status == ApiResponseStatus.completed && res.data!) {
        log('kunukunu completed payment fro the tour');
        Get.offAllNamed(
          Routes.HOME,
        )!
            .then(
          (dynamic value) => Get.snackbar(
            'Success ',
            'Payment Suucess for the tour ${bookingList[0].tourName}',
            backgroundColor: englishViolet,
            colorText: Colors.white,
          ),
        );
      } else {
        log('kunukunu Payment verification failed: ${res.message}');
      }
    } catch (e) {
      log('kunukunu Error while handling payment success: $e');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Payment error: ${response.code}', '${response.message}');
    log('kunukunu Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Get.snackbar('Payment successed: ', 'on : ${response.walletName}');

    log('External wallet: ${response.walletName}');
  }

  num getPackageGSTamount(num totalAmount, num gst) {
    final num gstAmount = (totalAmount * gst) / 100;
    return gstAmount;
  }

  Future<void> generateInvoicePDF({
    required String tourName,
    required String tourCode,
    required String bookedDate,
    required String dateOfTravel,
    required num totalAmount,
    required num packageAmount,
    required num gstPercentage,
    required num gstAmount,
    required num amountPaid,
    required num remainingAmount,
    required int adults,
    required int kids,
  }) async {
    // pdf.addPage(pw.MultiPage(
    //   pageFormat: PdfPageFormat.a4,
    //   header: (pw.Context context) {
    //     return pw.Container(
    //       child: pw.Column(
    //         children: <pw.Widget>[
    //           pw.SizedBox(width: 10),
    //           pw.Text('Tax Invoice', tightBounds: true, textScaleFactor: 4),
    //           pw.SizedBox(height: 15),
    //           pw.Row(children: [
    //             pw.Text('TourMaker '),
    //           ]),
    //           pw.SizedBox(height: 2),
    //           pw.Row(children: [
    //             pw.Text(
    //                 ' A Tower Complex, kalvary, junction,\n Poothole Road, Thrissur,\n Kerala 680004'),
    //             pw.Spacer(),
    //             pw.Text('Invoice Number # FAC7XD2400160506'),
    //           ]),
    //           pw.SizedBox(height: 10),
    //           pw.Divider(),
    //           pw.SizedBox(height: 5),
    //         ],
    //       ),
    //     );
    //   },
    //   margin: const pw.EdgeInsets.all(32),
    //   build: (pw.Context context) {
    //     return <pw.Widget>[
    //       pw.Row(
    //         children: [
    //           pw.Column(
    //             children: [
    //               pw.Text('Order ID :\n OD427868665028367100'),
    //               pw.Text('Order Date : 18-04-2023'),
    //               pw.Text('Invoice Date : 18-04-2023'),
    //             ],
    //           ),
    //           pw.Spacer(),
    //           pw.Column(children: [
    //             pw.Text('Bill to '),
    //             pw.Text('G672+MQF, Poothole,\n Thrissur,680004, India'),
    //             pw.Text('phone number : +917592864440'),
    //             pw.Text('Type Of User : Standard'),
    //             pw.Text('Enterprise Name : Not GIven'),
    //           ]),
    //           pw.Divider(),
    //         ],
    //       ),
    //       pw.Table.fromTextArray(
    //         border: pw.TableBorder(),
    //         data: [
    //           ['Tour', 'Tour Code', 'Amount'],
    //           ['Royal Kahmir', 'RK6D', '12000'],
    //           ['kfio', 'ojhiuf', 'jdbfi'],
    //         ],
    //       )
    // // pw.Header(
    // //   level: 0,
    // //   child: pw.Column(
    // //     mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    // //     children: <pw.Widget>[
    // //       pw.Text('Tour Maker', textScaleFactor: 2),
    // //     ],
    // //   ),
    // // ),

    // pw.Header(
    //   text: tourName,
    // ),
    // pw.Paragraph(text: tourCode),
    // pw.Row(
    //   children: [
    //     pw.Paragraph(text: 'Ordered Date : '),
    //     pw.Paragraph(text: bookedDate),
    //   ],
    // ),
    // pw.Header(text: 'Order Details'),
    // pw.Row(
    //   mainAxisAlignment: pw.MainAxisAlignment.end,
    //   children: [
    //     pw.Column(
    //       children: [
    //         pw.Paragraph(text: 'Adeeb Anvar'),
    //         pw.Paragraph(
    //             text: 'G672+MQF, Poothole,\n Thrissur,\n 680004, India'),
    //         pw.Paragraph(text: "adeebanvar66@gmail.com"),
    //         pw.Paragraph(text: "ContactCarriage"),
    //         pw.Paragraph(text: 'kulkuli'),
    //         pw.Paragraph(text: '+917592864440"'),
    //       ],
    //     )
    //   ],
    // ),
    // pw.Padding(padding: const pw.EdgeInsets.all(10)),
    // pw.Table.fromTextArray(
    //   context: context,
    //   data: <List<dynamic>>[
    //     <dynamic>['', ''],
    //     <dynamic>['Package Amount', packageAmount],
    //     <dynamic>['SGST(${gstPercentage / 2}%)', '${gstAmount / 2}'],
    //     <dynamic>['CGST(${gstPercentage / 2}%)', '${gstAmount / 2}'],
    //     <dynamic>['Total Amount', totalAmount],
    //     <dynamic>['Paid Amount', amountPaid],
    //     <dynamic>['Remaining', remainingAmount],
    //   ],
    // ),
    //     ];
    //   },
    // ));
  }

  Future<void> invoicePdf() async {
    final DateTime date = DateTime.now();
    final DateTime dueDate = date.add(const Duration(days: 7));

    final Invoice invoice = Invoice(
      supplier: const Supplier(
        name: 'Sarah Field',
        address: 'Sarah Street 9, Beijing, China',
        paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      customer: const Customer(
        name: 'Apple Inc.',
        address: 'Apple Street, Cupertino, CA 95014',
      ),
      info: InvoiceInfo(
        date: date,
        dueDate: dueDate,
        description: 'My description...',
        number: '${DateTime.now().year}-9999',
      ),
      items: <InvoiceItem>[
        InvoiceItem(
          description: 'Coffee',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 5.99,
        ),
        InvoiceItem(
          description: 'Water',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Orange',
          date: DateTime.now(),
          quantity: 3,
          vat: 0.19,
          unitPrice: 2.99,
        ),
        InvoiceItem(
          description: 'Apple',
          date: DateTime.now(),
          quantity: 8,
          vat: 0.19,
          unitPrice: 3.99,
        ),
        InvoiceItem(
          description: 'Mango',
          date: DateTime.now(),
          quantity: 1,
          vat: 0.19,
          unitPrice: 1.59,
        ),
        InvoiceItem(
          description: 'Blue Berries',
          date: DateTime.now(),
          quantity: 5,
          vat: 0.19,
          unitPrice: 0.99,
        ),
        InvoiceItem(
          description: 'Lemon',
          date: DateTime.now(),
          quantity: 4,
          vat: 0.19,
          unitPrice: 1.29,
        ),
      ],
    );

    final File pdfFile = await PdfInvoiceApi.generate(invoice);

    PdfApi.openFile(pdfFile);
  }

  // Future<String> savePdf() async {
  //   final String fileName = 'Invoice.pdf';
  //   final Directory documentDirectory =
  //       await getApplicationDocumentsDirectory();
  //   final String documentPath = documentDirectory.path;
  //   File existingFile = File('$documentPath/$fileName');
  //   int count = 1;
  //   while (await existingFile.exists()) {
  //     final String newFileName =
  //         '${fileName.replaceAll('.pdf', '')}_$count.pdf';
  //     existingFile = File('$documentPath/$newFileName');
  //     count++;
  //   }
  //   final File file = await existingFile.create();
  //   await file.writeAsBytes(await pdf.save());
  //   return file.path;
  //   // final Directory documentDirectory =
  //   //     await getApplicationDocumentsDirectory();
  //   // final String documentPath = documentDirectory.path;
  //   // String filename = '${bookingList[0].createdAt}.pdf';
  //   // File file = File('$documentPath/$filename');

  //   // // file = File('$documentPath/$newFilename');

  //   // await file.writeAsBytes(await pdf.save());
  //   // return file.path;
  // }
}
//] /data/user/0/com.example.tour_maker/app_flutter/Invoice_1.pdf
// class DownloadService {
//   static Future<void> downloadFile(String path) async {
//     final Directory? dir = await getExternalStorageDirectory();
//     final File file = File(path);

//     if (await file.exists()) {
//       final Uint8List bytes = await file.readAsBytes();
//       final File downloadedFile = File('${dir!.path}/invoice.pdf');
//       await downloadedFile.writeAsBytes(bytes);
//     }
//   }

//   double getSGST(num packageAmount, num gst) {
//     final num totalAmount = packageAmount;
//     final double sgstpercentage = gst / 2;
//     final double sgst = (totalAmount * sgstpercentage) / 100;
//     return sgst;
//   }

//   double getCGST(num packageAmount, num gst) {
//     final num totalAmount = packageAmount;
//     final double cgstPercentage = gst / 2;
//     final double sgst = (totalAmount * cgstPercentage) / 100;
//     return sgst;
//   }
// }
