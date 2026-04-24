class Song {
  final String title;
  final String url;
  final int bpm;
  Song({required this.title, required this.url, required this.bpm});
}

class MusicLibrary {
  static final Map<String, List<Song>> estilos = {
    "Urbano": [ Song(title: "Street Beat", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", bpm: 110) ],
    "Cinematográfico": [ Song(title: "Epic Story", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", bpm: 80) ],
  };
}
