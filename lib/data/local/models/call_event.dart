class CallEvent {
  final String id;
  final String callId;
  final String type;
  final String title;
  final String? description;
  final DateTime? eventDateTime;
  final bool isCompleted;
  final int? notificationId;

  const CallEvent({
    required this.id,
    required this.callId,
    required this.type,
    required this.title,
    this.description,
    this.eventDateTime,
    this.isCompleted = false,
    this.notificationId,
  });
}
