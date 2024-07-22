import 'package:get/get.dart';

bool validateString({
  required String text,
  required int minLength,
  int? maxLength,
  required Rxn<String> errorMessage,
  required String emptyMessage,
  required String minLengthMessage,
  String? maxLengthMessage,
}) {
  if (text.isEmpty) {
    errorMessage.value = emptyMessage;
    return false;
  }

  if (text.length < minLength) {
    errorMessage.value = minLengthMessage;
    return false;
  }

  if (maxLength != null && text.length > maxLength) {
    errorMessage.value = maxLengthMessage ?? 'Text exceeds maximum length';
    return false;
  }

  errorMessage.value = null;
  return true;
}
