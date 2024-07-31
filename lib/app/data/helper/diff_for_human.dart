import 'package:intl/intl.dart';

String diffForHuman(String isoDate) {
  DateTime dateTime = DateTime.parse(isoDate);
  Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) {
    return 'Just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes} minutes ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours} hours ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays} days ago';
  } else {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }
}
