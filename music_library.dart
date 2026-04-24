class Song {
  final String id;
  final String title;
  final String url;
  final double bpm;

  Song({required this.id, required this.title, required this.url, required this.bpm});
}

class MusicLibrary {
  // AUDITORÍA: Cambiamos el nombre a 'estilos' para que main.dart lo reconozca
  static final Map<String, List<Song>> estilos = {
    "Urbano":[
      Song(id: "u1", title: "Urban Beat 1", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", bpm: 95),
      Song(id: "u2", title: "Street Flow", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", bpm: 100),
      Song(id: "u3", title: "City Lights", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", bpm: 90),
      Song(id: "u4", title: "Havana Trap", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", bpm: 110),
      Song(id: "u5", title: "Reggaeton Base", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", bpm: 98),
      Song(id: "u6", title: "Night Drive", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", bpm: 105),
      Song(id: "u7", title: "Bass Drop", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3", bpm: 120),
      Song(id: "u8", title: "Urban Groove", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3", bpm: 92),
      Song(id: "u9", title: "Street Dance", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3", bpm: 115),
      Song(id: "u10", title: "Club Mix", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3", bpm: 125),
    ],
    "Cinematográfico":[
      Song(id: "c1", title: "Epic Journey", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3", bpm: 80),
      Song(id: "c2", title: "Hero's Rise", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3", bpm: 85),
      Song(id: "c3", title: "Dark Tension", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3", bpm: 75),
      Song(id: "c4", title: "Triumphant", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3", bpm: 90),
      Song(id: "c5", title: "Cinematic Intro", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3", bpm: 70),
      Song(id: "c6", title: "Battle Theme", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3", bpm: 100),
      Song(id: "c7", title: "Sad Piano", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", bpm: 60),
      Song(id: "c8", title: "Grand Finale", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", bpm: 88),
      Song(id: "c9", title: "Suspense", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", bpm: 65),
      Song(id: "c10", title: "Orchestral", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", bpm: 82),
    ],
    "Bodas":[
      Song(id: "b1", title: "Romantic Walk", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", bpm: 70),
      Song(id: "b2", title: "First Dance", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", bpm: 65),
      Song(id: "b3", title: "Love Story", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3", bpm: 75),
      Song(id: "b4", title: "Acoustic Vows", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3", bpm: 80),
      Song(id: "b5", title: "Tender Moments", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3", bpm: 68),
      Song(id: "b6", title: "Bridal Chorus", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3", bpm: 72),
      Song(id: "b7", title: "Sweet Memories", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3", bpm: 78),
      Song(id: "b8", title: "Forever", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3", bpm: 60),
      Song(id: "b9", title: "Joyful Tears", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3", bpm: 85),
      Song(id: "b10", title: "Wedding Bells", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3", bpm: 90),
    ],
    "Pop":[
      Song(id: "p1", title: "Upbeat Pop", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3", bpm: 120),
      Song(id: "p2", title: "Summer Vibes", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3", bpm: 115),
      Song(id: "p3", title: "Happy Days", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", bpm: 125),
      Song(id: "p4", title: "Dance Pop", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", bpm: 130),
      Song(id: "p5", title: "Teen Spirit", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3", bpm: 110),
      Song(id: "p6", title: "Radio Hit", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3", bpm: 118),
      Song(id: "p7", title: "Catchy Tune", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3", bpm: 122),
      Song(id: "p8", title: "Pop Rock", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3", bpm: 135),
      Song(id: "p9", title: "Synth Pop", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3", bpm: 105),
      Song(id: "p10", title: "Party Time", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-8.mp3", bpm: 128),
    ],
    "Lofi":[
      Song(id: "l1", title: "Chill Beats", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-9.mp3", bpm: 70),
      Song(id: "l2", title: "Study Time", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-10.mp3", bpm: 75),
      Song(id: "l3", title: "Rainy Day", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-11.mp3", bpm: 65),
      Song(id: "l4", title: "Coffee Shop", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-12.mp3", bpm: 80),
      Song(id: "l5", title: "Late Night", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3", bpm: 72),
      Song(id: "l6", title: "Relaxing", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-14.mp3", bpm: 68),
      Song(id: "l7", title: "Smooth Jazz", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-15.mp3", bpm: 85),
      Song(id: "l8", title: "Vinyl Crackle", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-16.mp3", bpm: 78),
      Song(id: "l9", title: "Mellow Mood", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3", bpm: 60),
      Song(id: "l10", title: "Sleepy", url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3", bpm: 55),
    ],
  };
}
