import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../views/invoice_pdf_view.dart';

class InvoicePdfController extends GetxController
    with StateMixin<InvoicePdfView> {
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();

  RxString url = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getpdf();
  }

  Future<void> getpdf() async {
    change(null, status: RxStatus.loading());
    if (Get.arguments != null) {
      url.value = Get.arguments[0] as String;
      log('remotePDFpath : ${url.value}');
    }
    change(null, status: RxStatus.success());
  }

  void onPageChanged(int page, int total) {
    currentPage.value = page;
    totalPages.value = total;
  }

  Future<void> downloadPdf() async {
    log('download Pdf');
    try {
      final http.Response response = await http.get(Uri.parse(url.value));
      final Uint8List bytes = response.bodyBytes;

      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/pdf.pdf');
      await file.writeAsBytes(bytes);

      Get.snackbar('PDF Downloaded', 'The PDF has been downloaded.');
    } catch (e) {
      log('download $e');
    }
  }

  Future<void> sharePdf() async {
    log('share pdf');
    try {
      final http.Response response = await http.get(Uri.parse(url.value));
      final Uint8List bytes = response.bodyBytes;

      final Directory directory = await getTemporaryDirectory();
      final File file = File('${directory.path}/pdf.pdf');
      await file.writeAsBytes(bytes);

      await Share.shareFiles(<String>[file.path], text: 'Check out this PDF!');
    } catch (e) {
      log('share $e');
    }
  }
}
