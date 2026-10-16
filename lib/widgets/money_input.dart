import 'package:flutter/material.dart';

/// Amount entry shared by setup and all money editors.
class MoneyInput extends StatefulWidget {
  final TextEditingController controller;
  final String label, doneLabel;
  final String? helperText;
  final bool enabled;
  final int maxLength;

  const MoneyInput({
    super.key,
    required this.controller,
    required this.label,
    required this.doneLabel,
    this.helperText,
    this.enabled = true,
    this.maxLength = 80,
  });

  @override
  State<MoneyInput> createState() => _MoneyInputState();
}

class _MoneyInputState extends State<MoneyInput> {
  final focus = FocusNode();

  @override
  void initState() {
    super.initState();
    focus.addListener(focusChanged);
  }

  void focusChanged() {
    // Clear once on entry, not on subsequent taps while editing the amount.
    if (focus.hasFocus) widget.controller.clear();
  }

  @override
  void dispose() {
    focus.removeListener(focusChanged);
    focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: widget.controller,
    focusNode: focus,
    enabled: widget.enabled,
    maxLength: widget.maxLength,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    textInputAction: TextInputAction.done,
    onSubmitted: (_) => focus.unfocus(),
    decoration: InputDecoration(
      labelText: widget.label,
      helperText: widget.helperText,
      counterText: '',
      // iOS's decimal keypad has no return key, so keep an explicit action
      // within reach on the field as well as requesting the keyboard action.
      suffixIcon: TextButton(
        onPressed: widget.enabled ? focus.unfocus : null,
        child: Text(widget.doneLabel),
      ),
    ),
  );
}
