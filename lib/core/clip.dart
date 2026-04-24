class VideoClip {
  final String id;
  final String imagePath;
  double durationSeconds;
  String transitionType;

  VideoClip({ required this.id, required this.imagePath, this.durationSeconds = 3.0, this.transitionType = 'fade' });
}
