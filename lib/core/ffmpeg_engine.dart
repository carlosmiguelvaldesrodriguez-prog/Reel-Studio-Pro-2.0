import 'dart:io';
import 'package:process_run/shell.dart';
import 'clip.dart'; // Corregido: Importa el modelo de clip

class FFmpegEngine {
  final String ffmpegPath = "${Directory.current.path}\\bin\\ffmpeg.exe";

  Future<String> renderVideo({
    required List<String> imagePaths,
    required String audioPath,
    required List<VideoClip> clips, // Corregido: Necesita los clips para las transiciones
    required String outputPath,
  }) async {
    if (!File(ffmpegPath).existsSync()) return "Error: ffmpeg.exe no encontrado.";
    
    List<String> args = [];
    String filterComplex = "";
    
    for (int i = 0; i < clips.length; i++) {
      String path = imagePaths[i % imagePaths.length].replaceAll(r'\', '/');
      args.addAll(['-loop', '1', '-t', '${clips[i].durationSeconds + 0.5}', '-i', path]);
      filterComplex += "[$i:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1:color=black,format=yuv420p,setsar=1[v$i];";
    }
    
    args.addAll(['-i', audioPath]);
    
    String lastOutput = "[v0]";
    double offset = clips[0].durationSeconds - 0.5;
    
    for (int i = 1; i < clips.length; i++) {
      String trans = clips[i].transitionType;
      String nextOutput = (i == clips.length - 1) ? "[vout]" : "[f$i]";
      filterComplex += "$lastOutput[v$i]xfade=transition=$trans:duration=0.5:offset=$offset$nextOutput;";
      lastOutput = "[f$i]";
      offset += clips[i].durationSeconds - 0.5;
    }
    
    if (clips.length == 1) filterComplex += "[0:v]null[vout]";
    
    args.addAll(['-filter_complex', filterComplex, '-map', '[vout]', '-map', '${clips.length}:a', '-c:v', 'libx264', '-t', '30', '-y', outputPath]);
    
    var shell = Shell(verbose: false);
    var result = await shell.runExecutableArguments(ffmpegPath, args);
    
    return result.exitCode == 0 ? "¡Éxito! Video en: $outputPath" : "Error FFmpeg: ${result.stderr}";
  }
}
