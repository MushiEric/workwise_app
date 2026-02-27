import 'package:flutter/material.dart';

Widget projectTaskTile(BuildContext context, Map<String, dynamic> t) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final title = t['title'] ?? 'Task';
  final assignee = t['assignee'] != null ? t['assignee']['name'] : null;
  final status = t['status'] ?? '';
  final progress = (t['progress'] is int) ? (t['progress'] as int).clamp(0, 100) : 0;

  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF151A2E) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Row(
      children: [
        Container(
          width: 6,
          height: 40,
          decoration: BoxDecoration(
            color: status == 'done' ? Colors.green : (status == 'in-progress' ? Colors.orange : Colors.blue),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Row(children: [
                if (assignee != null) ...[
                  CircleAvatar(radius: 10, backgroundColor: Colors.grey.shade200, child: Text(assignee[0].toUpperCase(), style: const TextStyle(fontSize: 10))),
                  const SizedBox(width: 8),
                  Text(assignee, style: const TextStyle(fontSize: 12)),
                  const SizedBox(width: 12),
                ],
                Text(status, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Text('$progress%', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ])
            ],
          ),
        )
      ],
    ),
  );
}
