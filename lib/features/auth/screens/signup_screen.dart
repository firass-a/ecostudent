import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/success_overlay.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool _loading = false;
  bool _done = false;
  bool _obscure = true;

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _studentId = TextEditingController();
  final _password = TextEditingController();
  final _referral = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _studentId.dispose();
    _password.dispose();
    _referral.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final s = ref.s;
    if (_firstName.text.trim().isEmpty ||
        _lastName.text.trim().isEmpty ||
        _studentId.text.trim().isEmpty ||
        _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.enterSignUpFields)),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authUserProvider.notifier).signUp(
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
            studentId: _studentId.text.trim(),
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

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fullName =
        '${_firstName.text.trim()} ${_lastName.text.trim()}'.trim();

    if (_done) {
      return SuccessOverlay(
        title: s.welcome,
        subtitle: fullName,
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
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    s.signUpSubtitle,
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
                      children: [
                        TextField(
                          controller: _firstName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: s.firstName,
                            prefixIcon: const Icon(PhosphorIconsRegular.user),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _lastName,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: s.lastName,
                            prefixIcon:
                                const Icon(PhosphorIconsRegular.userCircle),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _studentId,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: s.studentId,
                            prefixIcon: const Icon(
                              PhosphorIconsRegular.identificationCard,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _password,
                          obscureText: _obscure,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: s.password,
                            prefixIcon: const Icon(PhosphorIconsRegular.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? PhosphorIconsRegular.eye
                                    : PhosphorIconsRegular.eyeSlash,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
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
                  ).animate().fadeIn(duration: 280.ms),
                  const SizedBox(height: 20),
                  EcoButton(
                    label: s.confirm,
                    loading: _loading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
