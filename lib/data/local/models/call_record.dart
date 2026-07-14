class CallRecord {
  final String id;
  final String? phoneNumber;
  final String? contactName;
  final DateTime dateTime;
  final int durationSeconds;
  final String? audioFilePath;
  final String? transcriptionText;
  final String? summaryText;
  final String status;
  final DateTime? processedAt;
  final bool syncedToServer;

  const CallRecord({
    required this.id,
    this.phoneNumber,
    this.contactName,
    required this.dateTime,
    required this.durationSeconds,
    this.audioFilePath,
    this.transcriptionText,
    this.summaryText,
    required this.status,
    this.processedAt,
    this.syncedToServer = false,
  });
}
