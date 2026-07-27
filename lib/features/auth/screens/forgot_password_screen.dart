import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/success_overlay.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  int _step = 0;
  bool _loading = false;
  bool _done = false;
  final _contact = TextEditingController();
  final _otp = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _contact.dispose();
    _otp.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final repo = ref.read(userRepositoryProvider);
    setState(() => _loading = true);
    try {
      if (_step == 0) {
        await repo.requestPasswordReset(_contact.text.trim());
        setState(() => _step = 1);
      } else if (_step == 1) {
        final ok = await repo.verifyOtp(_otp.text.trim());
        if (!ok) throw Exception(ref.s.invalidOtp);
        setState(() => _step = 2);
      } else {
        await repo.resetPassword(_password.text);
        setState(() => _done = true);
      }
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
    if (_done) {
      return SuccessOverlay(
        title: s.passwordUpdated,
        buttonLabel: s.login,
        onContinue: () => context.go('/login'),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(s.forgotPassword)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_step == 0)
              TextField(
                controller: _contact,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: s.studentId,
                ),
              ),
            if (_step == 1)
              TextField(
                controller: _otp,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: s.otpHint),
              ),
            if (_step == 2)
              TextField(
                controller: _password,
                obscureText: true,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: s.password),
              ),
            const Spacer(),
            EcoButton(
              label: _step == 2 ? s.confirm : s.continueLabel,
              loading: _loading,
              onPressed: _next,
            ),
          ],
        ),
      ),
    );
  }
}
