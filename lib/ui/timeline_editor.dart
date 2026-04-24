import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../main.dart'; // Importamos AppState

class TimelineEditor extends StatelessWidget {
  const TimelineEditor({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    // Si no hay fotos, no mostramos nada
    if (appState.photos.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 150,
      color: Colors.black26,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: appState.photos.length,
        itemBuilder: (context, index) {
          return Container(
            width: 100,
            margin: const EdgeInsets.all(8),
            child: Image.file(File(appState.photos[index].path!), fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
