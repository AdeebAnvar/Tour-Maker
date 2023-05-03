import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../widgets/custom_appbar.dart';
import '../../pdf_view/views/pdf_view_view.dart';
import '../controllers/invoice_pdf_controller.dart';

class InvoicePdfView extends GetView<InvoicePdfController> {
  const InvoicePdfView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              controller.sharePdf();
            },
          ),
        ],
      ),
      body: controller.obx(
        onLoading: const Center(child: CircularProgressIndicator()),
        (InvoicePdfView? state) => SfPdfViewer.file(
          File(controller.url.value),
          key: controller.pdfViewerKey,
        ),
      ),
    );
  }
}
