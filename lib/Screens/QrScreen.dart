import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRScreen extends StatelessWidget {
  const QRScreen({super.key});
  String date() {
    final now = DateTime.now();
    final year = now.year.toString();
    final month = now.month.toString();
    final day = now.day.toString();
    return year + month + day;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: PrettyQr(
        size: 400,
        data: date(),
        errorCorrectLevel: QrErrorCorrectLevel.M,
        typeNumber: null,
        roundEdges: true,
      ),
    );
  }
}
