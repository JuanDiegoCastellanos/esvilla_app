import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:esvilla_app/presentation/widgets/shared/title_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class PaymentLinksSectionScreen extends ConsumerStatefulWidget {
  const PaymentLinksSectionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaymentLinksSectionScreenState();
}

class _PaymentLinksSectionScreenState
    extends ConsumerState<PaymentLinksSectionScreen> {
  late VideoPlayerController _bancolombiaVideoController;
  late Future<void> _initializeBancolombiaVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador de video para Bancolombia
    _bancolombiaVideoController = VideoPlayerController.asset(
      'assets/videos/guiaBancolombia.mp4', // Cambia a la ruta de tu video
    );

    _initializeBancolombiaVideoPlayerFuture =
        _bancolombiaVideoController.initialize().then((_) {
      // Opcional: Si quieres que el video se reproduzca en bucle
      _bancolombiaVideoController.setLooping(false);
      // Opcional: Si quieres que el video se reproduzca automáticamente
      // _bancolombiaVideoController.play();
    });
    _bancolombiaVideoController.addListener(() {
      if (mounted) {
        setState(() {}); // Actualiza la UI para reflejar la posición del video
      }
    });
  }

  @override
  void dispose() {
    _bancolombiaVideoController.dispose();
    super.dispose();
  }

  void _fastForward() {
    final currentPosition = _bancolombiaVideoController.value.position;
    final newPosition =
        currentPosition + const Duration(seconds: 10); // Adelantar 10 segundos
    _bancolombiaVideoController.seekTo(newPosition);
  }

  // Método para atrasar el video
  void _rewind() {
    final currentPosition = _bancolombiaVideoController.value.position;
    final newPosition =
        currentPosition - const Duration(seconds: 10); // Atrasar 10 segundos
    _bancolombiaVideoController.seekTo(newPosition.isNegative
        ? Duration.zero
        : newPosition); // Evitar posiciones negativas
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: TitleSection(
                titleText: 'Medios de pago de Servicios',
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                'Acceda ahora mismo a nuestros canales digitales para pagos rápidos y seguros.',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),

            // Sección de Davivienda
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await launchDavivienda();

                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(const Duration(seconds: 2), () {
                              ref.read(goRouterProvider).pop();
                            });
                            return const AlertDialog(
                              backgroundColor: Colors.red,
                              title: Text(
                                'Redirigiendo a Daviplata',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              content: CupertinoActivityIndicator(
                                radius: 25,
                                animating: true,
                                color: Colors.white,
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      height: 120,
                      width: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 4, color: Colors.red),
                          color: Colors.white),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          'assets/img/BancoDavivienda01.png',
                          fit: BoxFit.contain,
                          height: 120,
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Sección de Bancolombia con video
            const Text(
              "Bancolombia",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                minHeight: 200,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 4, color: Colors.red),
                color: Colors.white,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder(
                  future: _initializeBancolombiaVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return GestureDetector(
                        onTap: () async {
                          if (_bancolombiaVideoController.value.isPlaying) {
                            _bancolombiaVideoController.pause();
                          } else {
                            _bancolombiaVideoController.play();
                          }
                        },
                        child: AspectRatio(
                          aspectRatio:
                              _bancolombiaVideoController.value.aspectRatio,
                          child: VideoPlayer(_bancolombiaVideoController),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),

            // Controles del video
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.replay_10, size: 30),
                    onPressed: _rewind,
                  ),
                  IconButton(
                    icon: Icon(
                      _bancolombiaVideoController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_bancolombiaVideoController.value.isPlaying) {
                          _bancolombiaVideoController.pause();
                        } else {
                          _bancolombiaVideoController.play();
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, size: 30),
                    onPressed: _fastForward,
                  ),
                ],
              ),
            ),

            // Barra de progreso
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: VideoProgressIndicator(
                _bancolombiaVideoController,
                allowScrubbing: true,
                padding: const EdgeInsets.all(0),
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                  backgroundColor: Colors.black26,
                ),
              ),
            ),

            // Indicadores de tiempo
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(_bancolombiaVideoController.value.position),
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    _formatDuration(_bancolombiaVideoController.value.duration),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Función de ayuda para formatear Durations a String (ej. 00:30)
String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hours = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  if (duration.inHours > 0) {
    return '$hours:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

Future<void> launchDavivienda() async {
  try {
    final url = Uri.parse(
        'https://portalpagos.davivienda.com/#/comercio/10043/EMPRESA%20DE%20SERVICIOS%20PUBLICOS%20DE%20VILLA%20DE%20LEYVA');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (e) {
    throw AppException(message: 'Error al abrir Link Davivienda $e');
  }
}
