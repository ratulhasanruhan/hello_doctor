
String calculateTimeDifference({required DateTime startDate,required DateTime endDate}) {
  int seconds = endDate.difference(startDate).inSeconds;
  if (seconds < 60) {
    return '$seconds সেকেন্ড';
  } else if (seconds >= 60 && seconds < 3600) {
    return '${startDate.difference(endDate).inMinutes.abs()} মিনিট';
  } else if (seconds >= 3600 && seconds < 86400) {
    return '${startDate.difference(endDate).inHours} ঘন্টা';
  } else {
    return '${startDate.difference(endDate).inDays} দিন';
  }
}