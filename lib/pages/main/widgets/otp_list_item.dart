import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:verifyme/l10n/generated/localizations.dart';
import 'package:verifyme/pages/editform/view.dart';
import 'package:verifyme/utils/generate/controller.dart';
import 'package:verifyme/utils/notify.dart';

class OtpListItem extends StatelessWidget {
  final int index;
  final Map<String, dynamic> item;
  final GenerateController controller;
  final VoidCallback onDelete;

  const OtpListItem({
    super.key,
    required this.index,
    required this.item,
    required this.controller,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final accountName = item['accountName']!;
    final secret = item['secret']!;
    final algorithm = item['algorithm']!;
    final length = item['length']!;
    final mode = item['mode']!;
    final counter = item['counter'] ?? 0;
    final code = mode == "TOTP"
        ? controller.generate(secret, algorithm, length, mode)
        : controller.generate(secret, algorithm, length, mode,
            counter: counter);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Clipboard.setData(ClipboardData(text: code));
            showNotification(loc.code_has_been_copied);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                mode == "TOTP"
                    ? Obx(() {
                        return CircularProgressIndicator(
                          year2023: false,
                          value: controller.progress.value,
                          color: Theme.of(context).colorScheme.primary,
                        );
                      })
                    : Container(
                        margin: const EdgeInsets.all(12.2),
                        child: Icon(
                          Icons.lock,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        code,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: 2.0,
                            ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (mode == "HOTP")
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () {
                          controller.totpList[index]['counter']++;
                          controller.saveList();
                          controller.refreshList();
                          showNotification(loc.added);
                        },
                      ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      onSelected: (value) {
                        if (value == 'edit') {
                          Get.to(() => EditForm(
                                accountName: accountName,
                                secret: secret,
                                algorithm: algorithm,
                                length: length.toString(),
                                mode: mode,
                                isEdit: true,
                              ));
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  loc.edit,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  MaterialLocalizations.of(context)
                                      .deleteButtonTooltip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
