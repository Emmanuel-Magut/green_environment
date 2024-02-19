import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'Just Now';
  } else if (difference.inMinutes < 60) {
    return _formatTimeUnit('minute', difference.inMinutes);
  } else if (difference.inHours < 24) {
    return _formatTimeUnit('hour', difference.inHours);
  } else if (difference.inDays < 7) {
    return _formatTimeUnit('day', difference.inDays);
  } else {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }
}

String _formatTimeUnit(String unit, int value) {
  if (value == 1) {
    return '1 $unit ago';
  } else {
    return '$value ${unit}s ago';
  }
}
