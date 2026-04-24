import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'core/market_agent.dart';
import 'core/music_library.dart';
import 'core/ffmpeg_engine.dart';
import 'ui/timeline_editor.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => AppState(), child: const ReelStudioApp()));

class AppState extends ChangeNotifier {
  String apiKey = "";
  List<PlatformFile> photos = [];
  List<VideoClip> clips = [];
  String selectedStyle = "Urbano";
  int currentSongIndex = 0;
  String? downloadedAudioPath;
  String log = "V2.1 - Sistema Estable";

  void setApiKey(String key) => apiKey = key;
  void setPhotos(List<PlatformFile> p) { photos = p; notifyListeners(); }
  void setClips(List<VideoClip> c) { clips = c; notifyListeners(); }
  void setStyle(String s) { selectedStyle = s; currentSongIndex = 0; notifyListeners(); }
  void setLog(String newLog) { log = newLog; notifyListeners(); }
  void setAudioPath(String path) { downloadedAudioPath = path; notifyListeners(); }
}

class ReelStudioApp extends StatelessWidget {
  const ReelStudioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(theme: ThemeData.dark(), home: const MainWorkspace());
}

class MainWorkspace extends StatelessWidget {
  const MainWorkspace({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final songs = MusicLibrary.estilos[appState.selectedStyle] ?? [];
    final currentSong = songs.isNotEmpty ? songs[appState.currentSongIndex] : null;

    return Scaffold(
      appBar: AppBar(title: const Text("Reel Studio Pro 2.1")),
      body: Column(
        children: [
          Padding(padding: const EdgeInsets.all(8.0), child: TextField(onChanged: (val) => appState.setApiKey(val), obscureText: true, decoration: const InputDecoration(labelText: "API Key"))),
          Text(appState.log, style: const TextStyle(color: Colors.cyan)),
          const Divider(),
          if (currentSong != null) ...[
            Text(currentSong.title),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(Icons.play_arrow), onPressed: () => AudioPlayer().play(UrlSource(currentSong.url))),
            ]),
          ],
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () async {
                  var res = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
                  if (res != null) appState.setPhotos(res.files);
                },
                child: const Text("SUBIR FOTOS"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para generar guion con la IA
                },
                child: const Text("GENERAR GUION IA"),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Lógica para renderizar video con FFmpeg
                },
                child: const Text("RENDERIZAR VIDEO"),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Expanded(child: TimelineEditor()),
        ],
      ),
    );
  }
}
