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

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const ReelStudioApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  String apiKey = "";
  List<PlatformFile> photos = []; // Auditado: Usamos archivos reales
  String selectedStyle = "Urbano";
  int currentSongIndex = 0;
  String? downloadedAudioPath;
  String marketMessage = "Bienvenido. Analiza el mercado de Santa Clara para empezar.";
  bool cargando = false;

  void setApiKey(String key) => { apiKey = key, notifyListeners() };
  
  void setPhotos(List<PlatformFile> newPhotos) {
    photos = newPhotos;
    notifyListeners();
  }

  void clearPhotos() {
    photos.clear();
    notifyListeners();
  }

  void removePhoto(int index) {
    photos.removeAt(index);
    notifyListeners();
  }

  void reorderPhotos(int old, int newIdx) {
    if (newIdx > old) newIdx -= 1;
    final item = photos.removeAt(old);
    photos.insert(newIdx, item);
    notifyListeners();
  }

  void setMarketData(String msg, String style) {
    marketMessage = msg;
    selectedStyle = style;
    notifyListeners();
  }

  void setAudioPath(String path) {
    downloadedAudioPath = path;
    notifyListeners();
  }
}

class ReelStudioApp extends StatelessWidget {
  const ReelStudioApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reel Studio Pro 2.0',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: Colors.cyanAccent,
      ),
      home: const MainWorkspace(),
    );
  }
}
class MainWorkspace extends StatefulWidget {
  const MainWorkspace({super.key});
  @override
  State<MainWorkspace> createState() => _MainWorkspaceState();
}

class _MainWorkspaceState extends State<MainWorkspace> {
  final TextEditingController _chatController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<String> _chatHistory = [];

  // NAVEGACIÓN DE JUKEBOX
  void _nextSong(AppState state) {
    final canciones = MusicLibrary.estilos[state.selectedStyle]!;
    state.currentSongIndex = (state.currentSongIndex + 1) % canciones.length;
    _audioPlayer.stop();
    state.notifyListeners();
  }

  void _prevSong(AppState state) {
    final canciones = MusicLibrary.estilos[state.selectedStyle]!;
    state.currentSongIndex = (state.currentSongIndex - 1) % canciones.length;
    if (state.currentSongIndex < 0) state.currentSongIndex = canciones.length - 1;
    _audioPlayer.stop();
    state.notifyListeners();
  }

  // ANÁLISIS REAL DE SANTA CLARA
  void _analyzeMarket() async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.apiKey.isEmpty) return;
    
    setState(() => appState.cargando = true);
    final agent = MarketAgent(apiKey: appState.apiKey);
    final result = await agent.analyzeSantaClaraMarket();
    
    appState.setMarketData(result.message, result.recommendedStyle);
    setState(() {
      _chatHistory.add("📊 Análisis Santa Clara: ${result.niche}");
      appState.cargando = false;
    });
  }

  // DESCARGAR MÚSICA SELECCIONADA
  void _downloadMusic(AppState state) async {
    setState(() => state.cargando = true);
    final song = MusicLibrary.estilos[state.selectedStyle]![state.currentSongIndex];
    final response = await http.get(Uri.parse(song.url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/musica_temp.mp3');
    await file.writeAsBytes(response.bodyBytes);
    state.setAudioPath(file.path);
    setState(() {
      state.cargando = false;
      _chatHistory.add("🎵 Música lista: ${song.title}");
    });
  }

  // RENDERIZADO FINAL NATIVO
  void _renderVideo() async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (appState.photos.isEmpty || appState.downloadedAudioPath == null) return;

    final engine = FFmpegEngine();
    String? outputPath = await FilePicker.platform.saveFile(
      fileName: 'Mi_Reel_Pro.mp4',
      type: FileType.video,
    );

    if (outputPath != null) {
      final res = await engine.renderVideo(
        imagePaths: appState.photos.map((p) => p.path!).toList(),
        audioPath: appState.downloadedAudioPath!,
        bpm: MusicLibrary.estilos[appState.selectedStyle]![appState.currentSongIndex].bpm,
        outputPath: outputPath,
      );
      _chatHistory.add(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final song = MusicLibrary.estilos[appState.selectedStyle]![appState.currentSongIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("REEL STUDIO PRO 2.0 - ENTERPRISE"),
        actions: [
          IconButton(icon: const Icon(Icons.analytics, color: Colors.cyanAccent), onPressed: _analyzeMarket),
          IconButton(icon: const Icon(Icons.movie_creation, color: Colors.blueAccent), onPressed: _renderVideo),
        ],
      ),
      body: Row(
        children: [
          // PANEL IZQUIERDO: JUKEBOX
          Container(
            width: 300,
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "API Key de Gemini"),
                  onChanged: (val) => appState.setApiKey(val),
                ),
                const SizedBox(height: 20),
                const Text("Sintonizador de Estilos", style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: appState.selectedStyle,
                  isExpanded: true,
                  items: MusicLibrary.estilos.keys.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) => setState(() => appState.selectedStyle = val!),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.black26,
                  child: Column(
                    children: [
                      Text(song.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: const Icon(Icons.skip_previous), onPressed: () => _prevSong(appState)),
                          IconButton(icon: const Icon(Icons.play_circle_fill, size: 40), onPressed: () => _audioPlayer.play(UrlSource(song.url))),
                          IconButton(icon: const Icon(Icons.skip_next), onPressed: () => _nextSong(appState)),
                        ],
                      ),
                      ElevatedButton(onPressed: () => _downloadMusic(appState), child: const Text("USAR ESTA PISTA")),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // PANEL CENTRAL: TIMELINE
          Expanded(
            child: Column(
              children: [
                Expanded(child: appState.photos.isEmpty 
                  ? const Center(child: Text("Sube fotos para empezar")) 
                  : const TimelineEditor()),
                ElevatedButton.icon(
                  onPressed: () async {
                    var res = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
                    if (res != null) appState.setPhotos(res.files);
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text("CARGAR FOTOS DE ESTUDIO"),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          // PANEL DERECHO: CHAT
          Container(
            width: 300,
            color: const Color(0xFF1A1A1A),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(8), child: Text("CHAT ASISTENTE")),
                Expanded(
                  child: ListView.builder(
                    itemCount: _chatHistory.length,
                    itemBuilder: (c, i) => ListTile(title: Text(_chatHistory[i], style: const TextStyle(fontSize: 12))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _chatController,
                    decoration: const InputDecoration(hintText: "Escribe a Gemini..."),
                    onSubmitted: (val) {
                      setState(() => _chatHistory.add("Tú: $val"));
                      _chatController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
