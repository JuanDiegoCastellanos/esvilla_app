import 'package:esvilla_app/core/utils/enums/pqrs_status_enum.dart';
import 'package:esvilla_app/presentation/widgets/home/pqrs/decoration_container_status.dart';
import 'package:flutter/material.dart';

class StatusDynamicContainer extends StatelessWidget {
  final PqrsStatusEnum status;
  const StatusDynamicContainer({super.key, required this.status});
  @override
  Widget build(BuildContext context) {
    final decorationContainerStatus = DecorationContainerStatus.fromStatus(status);
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: decorationContainerStatus.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Text(
          status.name.toUpperCase() ,
          style: TextStyle(
            fontSize: 18,
            color: decorationContainerStatus.textColor,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          width: 10,
        ),
          decorationContainerStatus.icon,
      ]),
    );
  }
}