import 'surfaces.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/strings.dart';
import '../models/family.dart';
import '../services/money.dart';
import 'goal_image.dart';
import '../assets/library.dart';

const childCream = cream;
const childGreen = green;
const childInk = ink;
const childMuted = muted;
const childMint = mint;

String childCash(
  int amount,
  ChildData child,
  String language, {
  bool compact = false,
}) => NumberFormat.simpleCurrency(
  locale: moneyLocale,
  name: child.currency,
  decimalDigits: compact && amount % units(child.currency) == 0 ? 0 : null,
).format(amount / units(child.currency));

class ChildMoney extends StatelessWidget {
  final ChildData child;
  final Strings strings;
  final String language;
  final VoidCallback onGoal, onDetails;
  const ChildMoney({
    super.key,
    required this.child,
    required this.strings,
    required this.language,
    required this.onGoal,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final rewards =
        child.entries.values
            .where(
              (e) =>
                  e.kind == 'reward' && !child.reversed(e.id) && e.amount > 0,
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    final progress = child.goalAmount > 0
        ? (child.goalMoney / child.goalAmount).clamp(0.0, 1.0)
        : 0.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide =
            constraints.maxWidth >= 640 &&
            MediaQuery.textScalerOf(context).scale(16) <= 24;
        final compact =
            constraints.maxWidth < 430 || constraints.maxHeight < 560;
        final jarHeight = (constraints.maxHeight * (compact ? .40 : .51)).clamp(
          130.0,
          compact ? 260.0 : 430.0,
        );
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: wide ? 1000 : 540),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  compact ? 14 : 22,
                  0,
                  compact ? 14 : 22,
                  12,
                ),
                child: _MoneyLayout(
                  wide: wide,
                  children: [
                    Semantics(
                      label: strings('jarDescription'),
                      image: true,
                      child: Image.asset(
                        AssetLibrary.jar.path,
                        height: wide
                            ? (constraints.maxHeight * .75).clamp(180.0, 360.0)
                            : jarHeight,
                        width: double.infinity,
                        fit: BoxFit.contain,
                        excludeFromSemantics: true,
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: strings('moneyDetails'),
                      child: InkWell(
                        onTap: onDetails,
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  childCash(child.pending, child, language),
                                  key: const Key('child-pending'),
                                  style: TextStyle(
                                    fontSize: compact ? 48 : 66,
                                    height: 1.12,
                                    fontWeight: FontWeight.w900,
                                    color: childInk,
                                  ),
                                ),
                              ),
                              Text(
                                strings('pendingToReceive'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: childMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (rewards.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: childMint,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const GoldCoin(starOnly: true, size: 34),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                strings('earnedReward').replaceAll(
                                  '{amount}',
                                  childCash(
                                    rewards.first.amount,
                                    child,
                                    language,
                                    compact: true,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                  color: childGreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      Text(
                        strings('startEarning'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: childGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    SizedBox(height: compact ? 12 : 20),
                    Material(
                      color: paper,
                      elevation: 2,
                      shadowColor: const Color(0x18000000),
                      borderRadius: BorderRadius.circular(28),
                      child: InkWell(
                        onTap: onGoal,
                        borderRadius: BorderRadius.circular(28),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Image.asset(
                                AssetLibrary.pig.path,
                                width: compact ? 62 : 100,
                                height: compact ? 72 : 106,
                                fit: BoxFit.contain,
                                excludeFromSemantics: true,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            strings('mySavings'),
                                            style: TextStyle(
                                              fontSize: compact ? 19 : 24,
                                              fontWeight: FontWeight.w900,
                                              color: childInk,
                                            ),
                                          ),
                                        ),
                                        GoalImage(
                                          goalImageFor(child),
                                          size: compact ? 36 : 48,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      child.goalName.isEmpty
                                          ? strings('noGoal')
                                          : child.goalName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: childMuted,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    if (child.goalAmount > 0) ...[
                                      Text(
                                        '${childCash(child.goalMoney, child, language, compact: true)} / ${childCash(child.goalAmount, child, language, compact: true)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: childMuted,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ],
                                    Semantics(
                                      label: strings('mySavings'),
                                      value: '${(progress * 100).round()}%',
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 17,
                                        color: green,
                                        backgroundColor: const Color(
                                          0xFFDDEBE5,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MoneyLayout extends StatelessWidget {
  const _MoneyLayout({required this.wide, required this.children});
  final bool wide;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (!wide) return Column(children: children);
    return Row(
      key: const Key('wide-child-money'),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: children.first),
        const SizedBox(width: 24),
        Expanded(child: Column(children: children.skip(1).toList())),
      ],
    );
  }
}

class GoldCoin extends StatelessWidget {
  final double size;
  final bool starOnly;
  const GoldCoin({super.key, this.size = 34, this.starOnly = false});
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: starOnly
        ? null
        : BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE17C), Color(0xFFFFB92D)],
            ),
            border: Border.all(color: const Color(0xFFE8A519), width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0xFFCF9114), offset: Offset(0, 2)),
            ],
          ),
    child: Icon(
      Icons.star_rounded,
      size: size * (starOnly ? 1 : .74),
      color: const Color(0xFFFFCC42),
      shadows: const [
        Shadow(color: Color(0xFFCF921E), offset: Offset(0, 1), blurRadius: 1),
      ],
    ),
  );
}

class ChildNavigation extends StatelessWidget {
  final int selected;
  final Strings strings;
  final ValueChanged<int> onSelected;
  const ChildNavigation({
    super.key,
    required this.selected,
    required this.strings,
    required this.onSelected,
  });
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: paper,
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      boxShadow: [
        BoxShadow(
          color: Color(0x08000000),
          blurRadius: 20,
          offset: Offset(0, -3),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < 3; i++)
              Expanded(
                child: Semantics(
                  selected: selected == i,
                  button: true,
                  child: InkWell(
                    key: Key('child-tab-$i'),
                    onTap: () => onSelected(i),
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 3,
                      ),
                      decoration: BoxDecoration(
                        color: selected == i ? childMint : Colors.transparent,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (i == 1)
                            GoldCoin(size: compactPhone(context) ? 28 : 34)
                          else
                            Icon(
                              i == 0
                                  ? Icons.home_rounded
                                  : Icons.track_changes_rounded,
                              size: compactPhone(context) ? 29 : 35,
                              color: selected == i ? childGreen : childMuted,
                            ),
                          const SizedBox(height: 3),
                          Text(
                            strings(['tasks', 'money', 'goal'][i]),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: compactPhone(context) ? 13 : 15,
                              fontWeight: FontWeight.w800,
                              color: selected == i ? childGreen : childMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
