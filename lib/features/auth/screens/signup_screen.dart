import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_strings.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/success_overlay.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _page = PageController();
  int _step = 0;
  bool _loading = false;
  bool _done = false;

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _referral = TextEditingController();
  String? _university;
  String? _campus;

  @override
  void dispose() {
    _page.dispose();
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _referral.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref
          .read(authUserProvider.notifier)
          .signUp(
            fullName: _name.text.trim(),
            email: _email.text.trim(),
            phone: _phone.text.trim(),
            university: _university ?? AppConstants.universities.first,
            campus: _campus ?? AppConstants.campuses.first,
            password: _password.text,
            referralCode: _referral.text.trim().isEmpty
                ? null
                : _referral.text.trim(),
          );
      if (!mounted) return;
      setState(() => _done = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.s.localizeError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _stepTitle(AppStrings s) => switch (_step) {
    0 => s.signUpSubtitle,
    1 => s.university,
    _ => s.password,
  };

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_done) {
      return SuccessOverlay(
        title: s.welcome,
        subtitle: _name.text,
        pointsEarned: _referral.text.isNotEmpty
            ? AppConstants.referralBonusPoints
            : null,
        pointsDzdLine: _referral.text.isNotEmpty
            ? s.pointsEarnedDzd(AppConstants.referralBonusPoints)
            : null,
        buttonLabel: s.getStarted,
        onContinue: () => context.go('/home'),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.charcoal : AppColors.pageBg,
      appBar: AppBar(
        centerTitle: false,
        title: Text(s.signUp),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            if (_step == 0) {
              context.pop();
            } else {
              _page.previousPage(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOut,
              );
            }
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 16),
            child: Center(
              child: Text(
                '${_step + 1}/3',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.greenEmerald,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
            child: Row(
              children: List.generate(3, (i) {
                final active = i <= _step;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: active ? AppColors.primaryCtaGradient : null,
                      color: active
                          ? null
                          : (isDark ? AppColors.slate : AppColors.cardBorder),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: PageView(
                  controller: _page,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) => setState(() => _step = i),
                  children: [
                    _centeredStep(
                      title: _stepTitle(s),
                      children: [
                        TextField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: s.fullName,
                            prefixIcon: const Icon(PhosphorIconsRegular.user),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: s.email,
                            prefixIcon: const Icon(
                              PhosphorIconsRegular.envelope,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: s.phone,
                            prefixIcon: const Icon(PhosphorIconsRegular.phone),
                          ),
                        ),
                      ],
                    ),
                    _centeredStep(
                      title: _stepTitle(s),
                      children: [
                        DropdownButtonFormField<String>(
                          value: _university,
                          isExpanded: true,
                          decoration: InputDecoration(labelText: s.university),
                          items: AppConstants.universities
                              .map(
                                (u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(
                                    u,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _university = v),
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          value: _campus,
                          isExpanded: true,
                          decoration: InputDecoration(labelText: s.campus),
                          items: AppConstants.campuses
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (v) => setState(() => _campus = v),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _referral,
                          decoration: InputDecoration(
                            labelText: s.referralCodeOptional,
                            prefixIcon: const Icon(PhosphorIconsRegular.gift),
                          ),
                        ),
                      ],
                    ),
                    _centeredStep(
                      title: _stepTitle(s),
                      children: [
                        TextField(
                          controller: _password,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: s.password,
                            prefixIcon: const Icon(PhosphorIconsRegular.lock),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.slate
                                : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const MetallicCoinIcon(size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  s.pointsEqualsDzd,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.goldDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: EcoButton(
                  label: _step == 2 ? s.confirm : s.continueLabel,
                  loading: _loading,
                  onPressed: () {
                    if (_step < 2) {
                      _page.nextPage(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOut,
                      );
                    } else {
                      _submit();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _centeredStep({
    required String title,
    required List<Widget> children,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                EcoCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ).animate().fadeIn(duration: 280.ms),
              ],
            ),
          ),
        );
      },
    );
  }
}
