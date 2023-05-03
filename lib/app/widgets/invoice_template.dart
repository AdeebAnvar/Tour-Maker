import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class InvoiceTemplate {
  static pw.Widget buildInvoice({
    required String tourName,
    required String tourCode,
    required String bookedDate,
    required String dateOfTravel,
    required num packageAmount,
    required num gstPercentage,
    required num gstAmount,
    required num amountPaid,
    required num remainingAmount,
    required int adults,
    required int kids,
  }) {
    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey,
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(
            'Invoice',
          ),
          pw.SizedBox(height: 16),
          pw.Text('Tour Name: $tourName'),
          pw.SizedBox(height: 8),
          pw.Text('Tour Code: $tourCode'),
          pw.SizedBox(height: 8),
          pw.Text('Booked Date: $bookedDate'),
          pw.SizedBox(height: 8),
          pw.Text('Date of Travel: $dateOfTravel'),
          pw.SizedBox(height: 8),
          pw.Text('Package Amount: $packageAmount'),
          pw.SizedBox(height: 8),
          pw.Text('GST Percentage: $gstPercentage%'),
          pw.SizedBox(height: 8),
          pw.Text('GST Amount: $gstAmount'),
          pw.SizedBox(height: 8),
          pw.Text('Amount Paid: $amountPaid'),
          pw.SizedBox(height: 8),
          pw.Text('Remaining Amount: $remainingAmount'),
          pw.SizedBox(height: 8),
          pw.Text('Number of Adults: $adults'),
          pw.SizedBox(height: 8),
          pw.Text('Number of Kids: $kids'),
        ],
      ),
    );
  }
}
