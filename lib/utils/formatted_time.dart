String formatTime(String time) {
  try {
    List<String> parts = time.split(':');
    if (parts.length != 3) return 'Invalid time format';

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    Duration duration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
    );

    String formatted =
        '${duration.inMinutes.remainder(60)} mnt ${duration.inSeconds.remainder(60)} scnd';
    return formatted;
  } catch (e) {
    return time;
  }
}
