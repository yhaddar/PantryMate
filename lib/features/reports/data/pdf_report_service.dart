import 'dart:typed_data';

import 'package:pdf/widgets.dart' as pw;

import '../../dashboard/data/local_dashboard_repository.dart';

class PdfReportService {
  Future<Uint8List> generateDashboardSummary(
    DashboardSummary summary, {
    required DateTime generatedAt,
  }) async {
    final document = pw.Document();
    document.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'PantryMate dashboard summary',
              style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 12),
            pw.Text('Generated: ${generatedAt.toIso8601String()}'),
            pw.SizedBox(height: 24),
            pw.Text('Active inventory batches: ${summary.activeBatches}'),
            pw.Text('Expiring soon: ${summary.expiringSoonBatches}'),
            pw.Text('Expired: ${summary.expiredBatches}'),
          ],
        ),
      ),
    );
    return document.save();
  }
}
