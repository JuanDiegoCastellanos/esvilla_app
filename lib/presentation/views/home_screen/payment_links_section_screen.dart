import 'package:esvilla_app/core/config/app_router.dart';
import 'package:esvilla_app/core/error/app_exceptions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentLinksSectionScreen extends ConsumerWidget {
  const PaymentLinksSectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Link para pago de Servicios',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Text(
              'A continuación están los links para dirigirse a las apps para pagar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
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
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.width * 0.30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 4, color: Colors.red),
                        color: Colors.white
                      ),
                      child: Image.asset(
                        'assets/img/BancoDavivienda01.png',
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.15,
                        width: MediaQuery.of(context).size.width * 0.30,
                      ),
                    ),
                  ),
                  /* const Text(
                    "Daviplata",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ) */
                ],
              )
            ]),
          ),
        ],
      ),
    );
  }
}

Future<void> launchDavivienda() async {
  try{
    final url = Uri.parse(
      'https://portalpagos.davivienda.com/#/comercio/10043/EMPRESA%20DE%20SERVICIOS%20PUBLICOS%20DE%20VILLA%20DE%20LEYVA');
  await launchUrl(url, mode: LaunchMode.externalApplication);
  }catch(e){
    throw AppException(message: 'Error al abrir Link Davivienda $e');
  }
}