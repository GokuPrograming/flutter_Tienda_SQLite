import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastNotification {
  void showToast(
      BuildContext context, String title, String message, String type) {
    // Define las propiedades de acuerdo al tipo de toast
    ToastificationType toastType;
    Color primaryColor;
    Icon icon;

    switch (type) {
      case 'success':
        toastType = ToastificationType.success;
        primaryColor = Colors.green;
        icon = const Icon(Icons.check);
        break;
      case 'warning':
        toastType = ToastificationType.warning;
        primaryColor = Colors.orange;
        icon = const Icon(Icons.warning);
        break;
      case 'error':
      default:
        toastType = ToastificationType.error;
        primaryColor = Colors.red;
        icon = const Icon(Icons.error);
        break;
    }

    // Llama al método toastification.show con los parámetros configurados
    toastification.show(
      context: context, // optional if you use ToastificationWrapper
      type: toastType,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
      animationDuration: const Duration(milliseconds: 300),
      animationBuilder: (context, animation, alignment, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      icon: icon,
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
      callbacks: ToastificationCallbacks(
        onTap: (toastItem) => print('Toast ${toastItem.id} tapped'),
        onCloseButtonTap: (toastItem) =>
            print('Toast ${toastItem.id} close button tapped'),
        onAutoCompleteCompleted: (toastItem) =>
            print('Toast ${toastItem.id} auto complete completed'),
        onDismissed: (toastItem) => print('Toast ${toastItem.id} dismissed'),
      ),
    );
  }
}
