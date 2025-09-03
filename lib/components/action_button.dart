import 'package:fluent_ui/fluent_ui.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.onPressed, required this.iconData});

  final void Function()? onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Icon(iconData, size: 20),
      ),
    );
  }
}
