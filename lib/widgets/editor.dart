import 'package:flutter/material.dart';
import '../l10n/strings.dart';
import '../models/family.dart';
import 'goal_image.dart';
import 'money_input.dart';
import 'surfaces.dart';

class InputField {
  final String key, label, initial;
  final List<String>? choices;
  final bool amount, secret, multiline, date;
  final int maxLength;
  final bool imageChoices;
  const InputField(
    this.key,
    this.label, {
    this.initial = '',
    this.choices,
    this.amount = false,
    this.secret = false,
    this.multiline = false,
    this.date = false,
    this.maxLength = 80,
    this.imageChoices = false,
  });
}

Future<bool> editor(
  BuildContext context,
  Strings strings,
  String title,
  List<InputField> fields,
  Future<void> Function(Map<String, String>) save, {
  String? help,
}) async =>
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => _Editor(
        strings: strings,
        title: title,
        fields: fields,
        save: save,
        help: help,
      ),
    ) ??
    false;

class _Editor extends StatefulWidget {
  final Strings strings;
  final String title;
  final List<InputField> fields;
  final Future<void> Function(Map<String, String>) save;
  final String? help;
  const _Editor({
    required this.strings,
    required this.title,
    required this.fields,
    required this.save,
    this.help,
  });
  @override
  State<_Editor> createState() => _EditorState();
}

class _EditorState extends State<_Editor> {
  late final Map<String, TextEditingController> controls;
  bool busy = false;
  String? error;
  String t(String k) => widget.strings(k);
  @override
  void initState() {
    super.initState();
    controls = {
      for (final f in widget.fields)
        f.key: TextEditingController(text: f.initial),
    };
  }

  @override
  void dispose() {
    for (final c in controls.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> save() async {
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.save(controls.map((k, v) => MapEntry(k, v.text.trim())));
      if (mounted) Navigator.pop(context, true);
    } on DomainError catch (e) {
      if (mounted) setState(() => error = t(e.key));
    } catch (_) {
      if (mounted) setState(() => error = t('connectionError'));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t(widget.title),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (widget.help != null) ...[
            const SizedBox(height: 12),
            Text(t(widget.help!)),
          ],
          for (final f in widget.fields) ...[
            const SizedBox(height: 18),
            if (f.imageChoices) ...[
              Text(t(f.label)),
              const SizedBox(height: 10),
              Text(t('browseGoals'), style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 8),
              SizedBox(
                height: 340,
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final value in goalImages)
                        ChoiceChip(
                          showCheckmark: false,
                          selected: controls[f.key]!.text == value,
                          label: SizedBox(
                            width: 96,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GoalImage(value),
                                Text(
                                  t('item_$value'),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          onSelected: busy
                              ? null
                              : (_) => setState(() {
                                  controls[f.key]!.text = value;
                                  controls['name']?.text = t('item_$value');
                                }),
                        ),
                    ],
                  ),
                ),
              ),
            ] else if (f.choices != null)
              DropdownButtonFormField<String>(
                initialValue: f.initial,
                isExpanded: true,
                decoration: InputDecoration(labelText: t(f.label)),
                items: f.choices!
                    .map((v) => DropdownMenuItem(value: v, child: Text(t(v))))
                    .toList(),
                onChanged: busy
                    ? null
                    : (v) {
                        if (v != null) controls[f.key]!.text = v;
                      },
              )
            else if (f.amount)
              MoneyInput(
                controller: controls[f.key]!,
                enabled: !busy,
                label: t(f.label),
                doneLabel: t('keyboardDone'),
                maxLength: f.maxLength,
              )
            else
              TextField(
                controller: controls[f.key],
                enabled: !busy,
                obscureText: f.secret,
                readOnly: f.date,
                maxLines: f.multiline ? 3 : 1,
                maxLength: f.maxLength,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: t(f.label),
                  counterText: '',
                  suffixIcon: f.date ? const Icon(Icons.calendar_month) : null,
                ),
                onTap: !f.date
                    ? null
                    : () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.tryParse(controls[f.key]!.text) ??
                              DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) controls[f.key]!.text = day(date);
                      },
              ),
          ],
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(error!, style: const TextStyle(color: danger)),
          ],
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              FilledButton(
                onPressed: busy ? null : save,
                child: Text(t(busy ? 'loading' : 'save')),
              ),
              TextButton(
                onPressed: busy ? null : () => Navigator.pop(context, false),
                child: Text(t('cancel')),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
