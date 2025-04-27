import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:flutter/material.dart';

class DecorationContainerStatus {
  final Color backgroundColor;
  final Color textColor;
  final Icon icon;

  DecorationContainerStatus({
    required this.backgroundColor,
    this.textColor = Colors.white,
    required this.icon,
  });

  factory DecorationContainerStatus.fromStatus(PqrsStatusEnum status) {
    switch (status) {
      case PqrsStatusEnum.pendiente:
        return DecorationContainerStatus(
          backgroundColor: Colors.yellow.shade700,
          textColor: Color(0xFF2F277D),
          icon: const Icon(
            Icons.pending_actions,
            color: Color(0xFF2F277D),
            size: 34,
          ),
        );
      case PqrsStatusEnum.EnProceso:
        return DecorationContainerStatus(
          backgroundColor: Color(0xFF2F277D),
          icon: const Icon(
            Icons.route_outlined,
            color: Colors.white,
            size: 34,
            ),
        );
      case PqrsStatusEnum.solucionado:
        return DecorationContainerStatus(
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.check,
            color: Colors.white,
            size: 34,
          ),
        );
      case PqrsStatusEnum.cerrado:
        return DecorationContainerStatus(
          backgroundColor: Colors.brown,
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 34,
          ),
        );
      case PqrsStatusEnum.cancelado:
        return DecorationContainerStatus(
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.cancel,
            color: Colors.white,
            size: 34,
          ),
        );
    }
  }
}
