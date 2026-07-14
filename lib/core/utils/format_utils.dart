import 'package:intl/intl.dart';

String formatDuration(Object value) {
  final Duration duration;
  if (value is Duration) {
    duration = value;
  } else if (value is int) {
    duration = Duration(seconds: value);
  } else {
    throw ArgumentError('Expected int seconds or Duration, got $value');
  }

  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  return '${minutes.toString().padLeft(2, '0')}:'
      '${seconds.toString().padLeft(2, '0')}';
}

String formatDateTime(DateTime dateTime, {String? locale}) {
  return DateFormat.yMMMd(locale).add_Hm().format(dateTime);
}

String formatDate(DateTime date, {String? locale}) {
  return DateFormat.yMMMd(locale).format(date);
}

String formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) {
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
}
