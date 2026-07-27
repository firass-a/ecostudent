import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/eco_widgets.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final user = ref.watch(authUserProvider).valueOrNull;
    final settings = ref.watch(settingsProvider);

    if (user == null) return const Scaffold(body: LoadingView());

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(title: Text(s.profile)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EcoCard(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              children: [
                Hero(
                  tag: 'avatar',
                  child: CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.mintTint,
                    backgroundImage: user.avatarUrl != null
                        ? AssetImage(user.avatarUrl!) as ImageProvider?
                        : null,
                    child: user.avatarUrl == null
                        ? Text(
                            user.fullName.isNotEmpty
                                ? user.fullName[0].toUpperCase()
                                : '?',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(color: AppColors.primaryGreen),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.fullName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  user.studentId,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${user.university} · ${user.campus}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.butterYellow,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        PhosphorIconsFill.coins,
                        color: AppColors.gold,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        s.ptsApproxDzd(user.pointsBalance),
                        style: const TextStyle(
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          EcoCard(
            child: Column(
              children: [
                _tile(
                  context,
                  icon: PhosphorIconsFill.userCircle,
                  title: s.editProfile,
                  onTap: () => context.push('/edit-profile'),
                ),
                _tile(
                  context,
                  icon: PhosphorIconsFill.gift,
                  title: s.referral,
                  onTap: () => context.push('/referral'),
                ),
                _tile(
                  context,
                  icon: PhosphorIconsFill.clockCounterClockwise,
                  title: s.history,
                  onTap: () => context.push('/history'),
                ),
                _tile(
                  context,
                  icon: PhosphorIconsFill.bell,
                  title: s.notifications,
                  onTap: () => context.push('/notifications'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          EcoCard(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.globe),
                  title: Text(s.language),
                  subtitle: Text(settings.locale.languageCode.toUpperCase()),
                  trailing: DropdownButton<String>(
                    value: settings.locale.languageCode,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                      DropdownMenuItem(value: 'fr', child: Text('Français')),
                      DropdownMenuItem(value: 'en', child: Text('English')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        ref
                            .read(settingsProvider.notifier)
                            .setLocale(Locale(v));
                      }
                    },
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(PhosphorIconsRegular.moon),
                  title: Text(s.darkMode),
                  value: settings.isDark,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setDark(v),
                ),
                SwitchListTile(
                  secondary: const Icon(PhosphorIconsRegular.bell),
                  title: Text(s.notifications),
                  value: settings.notificationsEnabled,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setNotifications(v),
                ),
                SwitchListTile(
                  secondary: const Icon(PhosphorIconsRegular.buildings),
                  title: Text(s.adminMode),
                  subtitle: Text(s.adminModeSubtitle),
                  value: settings.isAdminMode,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setAdminMode(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          EcoButton(
            label: s.logout,
            outlined: true,
            onPressed: () async {
              await ref.read(authUserProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(s.deleteAccount),
                  content: Text(s.deleteAccountBody),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(s.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(
                        s.delete,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
              if (ok == true) {
                await ref.read(authUserProvider.notifier).deleteAccount();
                if (context.mounted) context.go('/login');
              }
            },
            child: Text(
              s.deleteAccount,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  String? _university;
  String? _campus;
  String? _avatarPath;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authUserProvider).valueOrNull;
    _name = TextEditingController(text: user?.fullName ?? '');
    _phone = TextEditingController(text: user?.phone ?? '');
    _university = user?.university;
    _campus = user?.campus;
    _avatarPath = user?.avatarUrl;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, maxWidth: 512);
    if (file != null) setState(() => _avatarPath = file.path);
  }

  Future<void> _save() async {
    final user = ref.read(authUserProvider).valueOrNull;
    if (user == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(authUserProvider.notifier).updateProfile(
            user.copyWith(
              fullName: _name.text.trim(),
              phone: _phone.text.trim(),
              university: _university,
              campus: _campus,
              avatarUrl: _avatarPath,
            ),
          );
      if (!mounted) return;
      context.pop();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    return Scaffold(
      appBar: AppBar(title: Text(s.editProfile)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                final source = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (ctx) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: Text(s.gallery),
                          onTap: () => Navigator.pop(ctx, ImageSource.gallery),
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: Text(s.camera),
                          onTap: () => Navigator.pop(ctx, ImageSource.camera),
                        ),
                      ],
                    ),
                  ),
                );
                if (source != null) await _pickAvatar(source);
              },
              child: Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor:
                      AppColors.primaryGreen.withValues(alpha: 0.15),
                  child: const Icon(
                    PhosphorIconsRegular.camera,
                    color: AppColors.primaryGreen,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: s.fullName),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phone,
            decoration: InputDecoration(labelText: s.phone),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _university,
            decoration: InputDecoration(labelText: s.university),
            items: AppConstants.universities
                .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                .toList(),
            onChanged: (v) => setState(() => _university = v),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _campus,
            decoration: InputDecoration(labelText: s.campus),
            items: AppConstants.campuses
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _campus = v),
          ),
          const SizedBox(height: 32),
          EcoButton(label: s.save, loading: _loading, onPressed: _save),
        ],
      ),
    );
  }
}
