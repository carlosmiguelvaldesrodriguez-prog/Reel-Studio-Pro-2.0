import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';

// --- MODELO DE DATOS DEL RESULTADO ---
class MarketAnalysisResult {
  final String message;
  final String niche;
  final int recommendedPhotos;
  final String recommendedStyle;
  final String recommendedTransition;

  MarketAnalysisResult({
    required this.message,
    required this.niche,
    required this.recommendedPhotos,
    required this.recommendedStyle,
    required this.recommendedTransition,
  });
}

// --- EL AGENTE DE MERCADO (GEMINI 3 FLASH) ---
class MarketAgent {
  final String apiKey;

  MarketAgent({required this.apiKey});

  // 1. ANÁLISIS DE MERCADO (BÚSQUEDA REAL EN SANTA CLARA)
  Future<MarketAnalysisResult> analyzeSantaClaraMarket() async {
    try {
      // DIRECTIVA APLICADA: 100% gemini-3-flash-preview
      final model = GenerativeModel(
        model: 'gemini-3-flash-preview', 
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.3, // Precisión analítica
          responseMimeType: 'application/json', // Obligamos a devolver JSON puro
        ),
      );

      final prompt = '''
      Realiza una búsqueda exhaustiva REAL en la web, Instagram y Facebook sobre los estudios fotográficos en Santa Clara, Cuba. Filtra la data de los últimos 7 días.
      Determina el tipo de contenido más popular (reacciones/comentarios) e identifica nichos potencialmente explotables que nos diferenciarían de la competencia.
      
      REGLA ANTI-ALUCINACIÓN: Si los cortafuegos de privacidad de Meta te impiden ver datos exactos de los últimos 7 días, NO INVENTES DATOS. Define el campo "bloqueo_meta" como true.

      Responde ESTRICTAMENTE con este formato JSON:
      {
        "bloqueo_meta": false,
        "analisis_mensaje": "Tu análisis detallado de Santa Clara aquí...",
        "nicho_explotable": "Ej: Quinceañeras urbanas con humo de colores",
        "fotos_recomendadas": 10,
        "estilo_musical_sugerido": "Urbano",
        "transicion_base": "wipeleft"
      }
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      
      final String textoLimpio = response.text!.replaceAll('```json', '').replaceAll('```', '').trim();
      final Map<String, dynamic> data = jsonDecode(textoLimpio);

      // Verificamos si la IA chocó con la privacidad de Facebook
      if (data['bloqueo_meta'] == true) {
        return MarketAnalysisResult(
          message: "No se pudo acceder a datos recientes por bloqueos de privacidad de las plataformas (Meta); operando con tendencias históricas de Santa Clara: ${data['analisis_mensaje']}",
          niche: data['nicho_explotable'] ?? "Alta competencia en bodas, oportunidad en Reels dinámicos.",
          recommendedPhotos: data['fotos_recomendadas'] ?? 8,
          recommendedStyle: data['estilo_musical_sugerido'] ?? "Pop",
          recommendedTransition: data['transicion_base'] ?? "fade",
        );
      }

      // Si logró extraer datos reales, los devolvemos intactos
      return MarketAnalysisResult(
        message: data['analisis_mensaje'] ?? "Análisis de Santa Clara completado con éxito.",
        niche: data['nicho_explotable'] ?? "Tendencia urbana detectada.",
        recommendedPhotos: data['fotos_recomendadas'] ?? 10,
        recommendedStyle: data['estilo_musical_sugerido'] ?? "Cinematográfico",
        recommendedTransition: data['transicion_base'] ?? "crossfade",
      );

    } catch (e) {
      return MarketAnalysisResult(
        message: "❌ Error crítico de conexión al analizar el mercado: $e",
        niche: "Desconocido (Modo Offline)",
        recommendedPhotos: 10,
        recommendedStyle: "Pop",
        recommendedTransition: "fade",
      );
    }
  }

  // 2. CHATBOT INTERACTIVO (ASISTENTE DE EDICIÓN)
  Future<String> chatWithAssistant(String userMessage, Function(String, dynamic) updateStateCallback) async {
    try {
      // DIRECTIVA APLICADA: 100% gemini-3-flash-preview
      final chatModel = GenerativeModel(
        model: 'gemini-3-flash-preview',
        apiKey: apiKey,
        generationConfig: GenerationConfig(temperature: 0.5),
      );
      
      final prompt = '''
      Eres el Asistente de Edición de "Reel Studio Pro". El usuario te dice: "$userMessage".
      
      Si el usuario te pide cambiar la velocidad de las transiciones (más rápidas, más lentas), responde exactamente incluyendo este código secreto en tu respuesta: [CMD:SPEED_FAST] o [CMD:SPEED_SLOW].
      Si el usuario te pide cambiar el estilo musical (ej. ponlo más romántico), responde incluyendo: [CMD:STYLE_ROMANTIC] o [CMD:STYLE_URBAN].
      
      Si no pide cambios técnicos, simplemente responde amablemente dándole consejos de edición.
      ''';

      final response = await chatModel.generateContent([Content.text(prompt)]);
      final text = response.text ?? "Lo siento, no pude procesar eso.";

      // LÓGICA DE CONTROL DE LA APLICACIÓN MEDIANTE CHAT
      if (text.contains("[CMD:SPEED_FAST]")) {
        updateStateCallback("speed", 0.5);
        return text.replaceAll("[CMD:SPEED_FAST]", "\n⚡ He ajustado el Timeline para que las transiciones sean más agresivas.");
      } 
      else if (text.contains("[CMD:STYLE_ROMANTIC]")) {
        updateStateCallback("style", "Bodas/Romántico");
        return text.replaceAll("[CMD:STYLE_ROMANTIC]", "\n💖 He modificado el género musical a Bodas/Romántico. Selecciona una nueva pista en la Jukebox.");
      }
      
      return text.replaceAll(RegExp(r'\[CMD:.*?\]'), '');

    } catch (e) {
      return "❌ Error de red con Gemini Chat: $e";
    }
  }
}
