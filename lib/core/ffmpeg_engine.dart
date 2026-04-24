import 'dart:io';
import 'package:process_run/shell.dart';

class FFmpegEngine {
  // AUDITORÍA: Buscamos el motor en la carpeta local para evitar el Error 69
  final String ffmpegPath = "${Directory.current.path}\\bin\\ffmpeg.exe";

  Future<String> renderVideo({
    required List<String> imagePaths,
    required String audioPath,
    required double bpm,
    required String outputPath,
  }) async {
    if (imagePaths.isEmpty) return "Error: No hay imágenes.";

    // CÁLCULO DE RITMO (Beat-Sync)
    double beatDuration = 60.0 / bpm;
    double transitionDuration = 0.5; // Duración del efecto visual
    // Cada clip durará lo que dicte el ritmo para ser dinámico
    double clipDuration = (30.0 / imagePaths.length); 

    List<String> args = [];
    String filterComplex = "";

    // 1. PREPARACIÓN E INPUTS
    // Obligamos a todas las fotos a ser Verticales (1080x1920) para evitar errores
    for (int i = 0; i < imagePaths.length; i++) {
      String path = imagePaths[i].replaceAll(r'\', '/');
      args.addAll(['-loop', '1', '-t', '${clipDuration + transitionDuration}', '-i', path]);
      
      // Filtro de escalado inteligente (ajusta y rellena con negro si falta espacio)
      filterComplex += "[$i:v]scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:-1:-1:color=black,format=yuv420p,setsar=1[v$i];";
    }
    // 2. INPUT DE AUDIO
    args.addAll(['-i', audioPath.replaceAll(r'\', '/')]);
    int audioIndex = imagePaths.length;

    // 3. CONSTRUCCIÓN DE TRANSICIONES DINÁMICAS
    String lastOutput = "[v0]";
    double currentOffset = clipDuration - (transitionDuration / 2);
    
    // Lista de transiciones variadas (concordantes con el ritmo)
    List<String> transitionStyles = ['fade', 'wipeleft', 'wiperight', 'slideup', 'slidedown', 'pixelize'];

    for (int i = 1; i < imagePaths.length; i++) {
      String trans = transitionStyles[i % transitionStyles.length];
      String nextOutput = (i == imagePaths.length - 1) ? "[vout]" : "[f$i]";
      
      filterComplex += "$lastOutput[v$i]xfade=transition=$trans:duration=$transitionDuration:offset=$currentOffset$nextOutput;";
      lastOutput = "[f$i]";
      currentOffset += (clipDuration - (transitionDuration / 2));
    }

    // 4. ENSAMBLAJE DEL COMANDO FINAL
    args.addAll([
      '-filter_complex', filterComplex,
      '-map', '[vout]',
      '-map', '$audioIndex:a',
      '-c:v', 'libx264',
      '-preset', 'fast',
      '-pix_fmt', 'yuv420p',
      '-c:a', 'aac',
      '-shortest', // El video se corta cuando termine la música
      '-y',
      outputPath.replaceAll(r'\', '/')
    ]);

    try {
      var shell = Shell(verbose: false);
      // Ejecutamos el motor nativo de Windows
      ProcessResult result = await Process.run(ffmpegPath, args);
      
      if (result.exitCode == 0) {
        return "✨ ¡REEL CREADO CON ÉXITO!\nGuardado en: $outputPath";
      } else {
        return "❌ Error de motor FFmpeg:\n${result.stderr}";
      }
    } catch (e) {
      return "❌ Error fatal de sistema: $e";
    }
  }
}
