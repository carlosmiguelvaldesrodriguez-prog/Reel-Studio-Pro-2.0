import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../main.dart'; // Para acceder al estado global

class TimelineEditor extends StatelessWidget {
  const TimelineEditor({super.key});

  @override
  Widget build(BuildContext context) {
    // Auditamos que AppState sea el nombre correcto en main.dart
    final appState = Provider.of<AppState>(context);

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        border: Border(top: BorderSide(color: Colors.cyanAccent.withOpacity(0.2), width: 1)),
      ),
      child: Column(
        children: [
          // CABECERA DEL TIMELINE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers_outlined, color: Colors.cyanAccent, size: 18),
                    SizedBox(width: 8),
                    Text("LÍNEA DE TIEMPO RÍTMICA", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => appState.clearPhotos(),
                  icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 18),
                  label: const Text("Desechar Todo", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                )
              ],
            ),
          ),
          
          // LISTA INTERACTIVA (DRAG & DROP)
          Expanded(
            child: ReorderableListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onReorder: (oldIndex, newIndex) {
                // AUDITORÍA: Corrección matemática de índices para Windows
                if (newIndex > oldIndex) newIndex -= 1;
                appState.reorderPhotos(oldIndex, newIndex);
              },
              children: [
                for (int i = 0; i < appState.photos.length; i++)
                  Container(
                    key: ValueKey(appState.photos[i].path), // Clave única por archivo
                    width: 130,
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D2D2D),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white10),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          // MINIATURA REAL DE LA FOTO
                          Positioned.fill(
                            child: Image.file(
                              File(appState.photos[i].path!),
                              fit: BoxFit.cover,
                              // Optimización para Celeron: Cargamos miniatura pequeña
                              cacheWidth: 200, 
                            ),
                          ),
                          // CAPA DE INFORMACIÓN (Estilo CapCut)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black54,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Text(
                                "Escena ${i + 1}\n${appState.clips.length > i ? appState.clips[i].duration : 3.0}s",
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            ),
                          ),
                          // BOTÓN PARA ELIMINAR CLIP INDIVIDUAL
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => appState.removePhoto(i),
                              child: Container(
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: const Icon(Icons.close, color: Colors.white, size: 14),
                              ),
                            ),
                          ),
                          // ICONO DE TRANSICIÓN
                          const Positioned(
                            bottom: 5,
                            right: 5,
                            child: Icon(Icons.auto_awesome, color: Colors.cyanAccent, size: 14),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
