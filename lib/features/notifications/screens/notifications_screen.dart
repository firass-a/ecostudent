import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  IconData _icon(NotificationType t) => switch (t) {
        NotificationType.reward => PhosphorIconsFill.coins,
        NotificationType.system => PhosphorIconsFill.info,
        NotificationType.promo => PhosphorIconsFill.megaphone,
      };

  Color _color(NotificationType t) => switch (t) {
        NotificationType.reward => AppColors.goldDark,
        NotificationType.system => AppColors.info,
        NotificationType.promo => AppColors.primaryGreen,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final async = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(
        title: Text(s.notifications),
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsProvider);
              ref.invalidate(unreadCountProvider);
            },
            child: Text(s.markAllRead),
          ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorStateView(
          title: s.errorOccurred,
          message: e.toString(),
          retryLabel: s.retry,
          onRetry: () => ref.invalidate(notificationsProvider),
        ),
        data: (list) {
          if (list.isEmpty) {
            return EmptyStateView(
              message: s.emptyState,
              icon: PhosphorIconsRegular.bellSlash,
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final n = list[i];
              final localized = s.localizedNotification(n.id, n.title, n.body);
              return Dismissible(
                key: ValueKey(n.id),
                onDismissed: (_) async {
                  await ref
                      .read(notificationRepositoryProvider)
                      .deleteNotification(n.id);
                  ref.invalidate(notificationsProvider);
                  ref.invalidate(unreadCountProvider);
                },
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  padding: const EdgeInsetsDirectional.only(end: 20),
                  color: AppColors.error,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: EcoCard(
                    onTap: () async {
                      await ref
                          .read(notificationRepositoryProvider)
                          .markAsRead(n.id);
                      ref.invalidate(notificationsProvider);
                      ref.invalidate(unreadCountProvider);
                    },
                    color: n.read
                        ? null
                        : AppColors.primaryGreen.withValues(alpha: 0.06),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(_icon(n.type), color: _color(n.type)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localized.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      fontWeight: n.read
                                          ? FontWeight.w500
                                          : FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(localized.body,
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat.MMMd().add_jm().format(n.createdAt),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: AppColors.warmGray),
                              ),
                            ],
                          ),
                        ),
                        if (!n.read)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
