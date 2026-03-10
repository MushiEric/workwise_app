import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Semantic icon tokens — prefer `LucideIcons` here so the app can migrate
/// icon usage in a single place.
class AppIcons {
  AppIcons._();

  static const IconData menu = LucideIcons.menu;
  static const IconData search = LucideIcons.search;
  static const IconData plus = LucideIcons.plus;
  static const IconData bell = LucideIcons.bell;
  static const IconData user = LucideIcons.user;
  static const IconData x = LucideIcons.x;
  static const IconData moreHorizontal = LucideIcons.moreHorizontal;

  // auth / profile icons
  static const IconData mail = LucideIcons.mail;
  static const IconData lock = LucideIcons.lock;
  static const IconData edit = LucideIcons.edit;
  static const IconData settings = LucideIcons.settings;
  static const IconData camera = LucideIcons.camera;
  static const IconData calendar = LucideIcons.calendar;
  static const IconData phone = LucideIcons.phone;
  static const IconData chevronRight = LucideIcons.chevronRight;

  // additional icons used by auth/profile pages
  static const IconData image = LucideIcons.image;
  static const IconData trash2 = LucideIcons.trash2;
  static const IconData moon = LucideIcons.moon;
  static const IconData globe = LucideIcons.globe;
  static const IconData volume = LucideIcons.volume;
  static const IconData server = LucideIcons.server;
  static const IconData logOut = LucideIcons.logOut;
  static const IconData check = LucideIcons.check;

  // jobcard feature icons
  static const IconData eye = LucideIcons.eye;
  static const IconData eyeOff = LucideIcons.eyeOff;
  static const IconData slidersHorizontal = LucideIcons.slidersHorizontal;
  static const IconData file = LucideIcons.file;
  static const IconData share2 = LucideIcons.share2;
  static const IconData moreVertical = LucideIcons.moreVertical;

  // material icons used by jobcard/detail pages
  static const IconData addRounded = Icons.add_rounded;
  static const IconData assignmentRounded = Icons.assignment_rounded;
  static const IconData circle = Icons.circle;
  static const IconData errorOutlineRounded = Icons.error_outline_rounded;
  static const IconData refreshRounded = Icons.refresh_rounded;
  static const IconData assignmentOutlined = Icons.assignment_outlined;
  static const IconData searchOffRounded = Icons.search_off_rounded;
  static const IconData clearRounded = Icons.clear_rounded;
  static const IconData closeRounded = Icons.close_rounded;
  static const IconData infoRounded = Icons.info_rounded;
  static const IconData summarizeRounded = Icons.summarize_rounded;
  static const IconData inventory2Rounded = Icons.inventory_2_rounded;
  static const IconData attachMoneyRounded = Icons.attach_money_rounded;
  static const IconData noteRounded = Icons.note_rounded;
  static const IconData buildOutlined = Icons.build_outlined;
  static const IconData historyRounded = Icons.history_rounded;
  static const IconData approvalRounded = Icons.approval_rounded;
  static const IconData searchRounded = Icons.search_rounded;
  static const IconData receiptLongRounded = Icons.receipt_long_rounded;
  static const IconData settingsOutlined = Icons.settings_outlined;
  static const IconData flagRounded = Icons.flag_rounded;
  static const IconData editRounded = Icons.edit_rounded;
  static const IconData accessTimeRounded = Icons.access_time_rounded;
  static const IconData autorenew = Icons.autorenew;
  static const IconData subjectRounded = Icons.subject_rounded;
  static const IconData eventRounded = Icons.event_rounded;
  static const IconData calendarTodayRounded = Icons.calendar_today_rounded;
  // static const IconData editRounded = Icons.edit_rounded;
  // static const IconData inventory2Rounded = Icons.inventory_2_rounded;
  static const IconData buildRounded = Icons.build_rounded;
  static const IconData visibilityRounded = Icons.visibility_rounded;
  static const IconData saveOutlined = Icons.save_outlined;
  static const IconData deleteOutlineRounded = Icons.delete_outline_rounded;
  static const IconData checkCircleRounded = Icons.check_circle_rounded;
  static const IconData receiptRounded = Icons.receipt_rounded;
  static const IconData uploadFileRounded = Icons.upload_file_rounded;
}

/// Lightweight icon wrapper (keeps sizing/color consistent)
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const AppIcon(
    this.icon, {
    super.key,
    this.size = 20,
    this.color,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Icon(
        icon,
        size: size,
        color: color ?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
