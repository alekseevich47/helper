import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/local/models/call_record.dart';

class CallListTile extends StatelessWidget {
  const CallListTile({super.key, required this.call});

  final CallRecord call;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final title = call.contactName ?? call.phoneNumber ?? l10n.unknown;
    final letter = title.isNotEmpty ? title[0].toUpperCase() : '?';
    final subtitle =
        '${formatDateTime(call.dateTime, locale: locale)}'
        ' · ${formatDuration(call.durationSeconds)}';

    return ListTile(
      leading: CircleAvatar(child: Text(letter)),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subtitle),
      trailing: _StatusChip(status: call.status),
      onTap: () => context.push('/call/${call.id}'),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusStyle(status);
    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.15),
      side: BorderSide.none,
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  (String, Color) _statusStyle(String status) {
    return switch (status) {
      'new' => ('new', Colors.blue),
      'pending' => ('pending', Colors.orange),
      'processing' => ('processing', Colors.deepPurple),
      'done' => ('done', Colors.green),
      'error' => ('error', Colors.red),
      _ => (status, Colors.grey),
    };
  }
}
