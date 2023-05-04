import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final Uint8List bytes = await pdf.save();

    final Directory dir = await getApplicationDocumentsDirectory();
    final File file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  // static Future openFile(File file) async {
  //   final String url = file.path;

  //   final  openFileUrl = await OpenFile.open(url);
  //   return openFileUrl;
  // }
}
