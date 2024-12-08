//* return episode time based on seconds
String getEpDuration(String durationInSeconds) {
  int timeInSeconds = int.tryParse(durationInSeconds) ?? 0;
  Duration duration = Duration(seconds: timeInSeconds);
  
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));

  if (duration.inHours > 0) {
    return '$hours:$minutes:$seconds';
  } else {
    return '$minutes:$seconds';
  }
}
