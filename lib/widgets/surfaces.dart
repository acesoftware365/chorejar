import 'package:flutter/material.dart';

/// ChoreJar's shared palette.  Screens use these tokens rather than inventing
/// near-identical greens and creams, so parent and child views feel like one
/// calm product.
const ink = Color(0xFF183B38),
    green = Color(0xFF07866B),
    cream = Color(0xFFFFFCF6),
    paper = Color(0xFFFFFFFF),
    mint = Color(0xFFE3F4ED),
    muted = Color(0xFF5B746C),
    border = Color(0xFFB6D7CA),
    gold = Color(0xFFF4BE47),
    paleGold = Color(0xFFFFEDBE),
    danger = Color(0xFFB63832),
    dangerContainer = Color(0xFFFFE8E5);
bool compactPhone(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  return size.width < 430 || size.height < 720;
}

Widget panel(Widget child, {Color color = paper}) => Builder(
  builder: (context) => Container(
    width: double.infinity,
    margin: EdgeInsets.only(bottom: compactPhone(context) ? 12 : 16),
    padding: EdgeInsets.all(compactPhone(context) ? 12 : 20),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: border),
    ),
    child: child,
  ),
);
Widget heading(String title, [String? subtitle]) => Builder(
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: compactPhone(context) ? 12 : 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: compactPhone(context) ? 20 : 28,
            fontWeight: FontWeight.w800,
            color: ink,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(fontSize: 15, color: muted)),
        ],
      ],
    ),
  ),
);
Widget pageBody(List<Widget> children, {bool adaptiveColumns = false}) =>
    Builder(
      builder: (context) => SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: adaptiveColumns ? 1100 : 720),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final split = children.indexWhere(
                  (w) => w.key == const Key('section-start'),
                );
                final wide =
                    adaptiveColumns &&
                    constraints.maxWidth >= 640 &&
                    MediaQuery.textScalerOf(context).scale(16) <= 24 &&
                    split > 0;
                return ListView(
                  padding: EdgeInsets.all(compactPhone(context) ? 12 : 22),
                  children: wide
                      ? [
                          Row(
                            key: const Key('wide-parent-layout'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: children.take(split).toList(),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: children.skip(split).toList(),
                                ),
                              ),
                            ],
                          ),
                        ]
                      : children,
                );
              },
            ),
          ),
        ),
      ),
    );
