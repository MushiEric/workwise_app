import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';

import '../../domain/entities/user.dart' as domain;
import '../providers/auth_providers.dart';
import '../../../../core/provider/tenant_provider.dart';
import '../../../../core/storage/tenant_local_data_source.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/themes/app_colors.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/provider/locale_provider.dart';
import 'package:workwise_erp/core/extensions/l10n_extension.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  bool _isEditing = false;
  File? _pickedAvatarFile;
  domain.User? _cachedUser;   // persists user across loading transitions
  bool _hasPopulated = false; // ensure controllers are populated only once

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _bioController = TextEditingController();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _populateFromUser(domain.User? user) {
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phone ?? '';
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    final Map<String, dynamic> payload = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'phone': _phoneController.text.trim(),
      'bio': _bioController.text.trim(),
    };
    if (_pickedAvatarFile != null) {
      payload['avatar'] = await MultipartFile.fromFile(
        _pickedAvatarFile!.path,
        filename: _pickedAvatarFile!.path.split('/').last,
      );
    }

    try {
      await ref.read(authNotifierProvider.notifier).updateProfile(payload);
      // Only reached on success (notifier throws on failure after restoring state).
      // Re-populate controllers with the server-confirmed user data.
      final updatedUser = ref.read(authNotifierProvider).maybeWhen(
        authenticated: (u) => u,
        orElse: () => null,
      );
      if (updatedUser != null) _populateFromUser(updatedUser);
      setState(() {
        _isLoading = false;
        _isEditing = false;
        _pickedAvatarFile = null;
      });
      if (mounted) {
        context.showSuccessModal(
          title: context.l10n.success,
          message: context.l10n.profileUpdatedSuccess,
          buttonText: context.l10n.done,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showInfoModal(
          title: context.l10n.updateFailed,
          message: e.toString().replaceFirst('Exception: ', ''),
          buttonText: context.l10n.tryAgain,
        );
      }
    }
  }

  Future<void> _changePassword() async {
    // Navigate to change password screen or show modal
    if (mounted) {
      context.showFormModal(
        title: context.l10n.changePassword,
        form: Column(
          children: [
            AppTextField(
              obscureText: true,
            ),
            const SizedBox(height: 16),
            AppTextField(
              obscureText: true,
              labelText: context.l10n.newPassword,
            ),
            const SizedBox(height: 16),
            AppTextField(
              obscureText: true,
              labelText: context.l10n.confirmNewPassword,
            ),
          ],
        ),
        onSubmit: () {
          Navigator.pop(context);
          context.showSuccessModal(
            title: context.l10n.passwordUpdated,
            message: context.l10n.passwordUpdatedMessage,
            buttonText: context.l10n.done,
          );
        },
        submitText: context.l10n.saveChanges,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // Derive user exclusively from authNotifierProvider so we always reflect
    // the latest server-confirmed data without depending on FutureProvider.
    final authState = ref.watch(authNotifierProvider);

    domain.User? user;
    authState.maybeWhen(authenticated: (u) => user = u, orElse: () {});

    // Also watch currentUserProvider (backend profile endpoint) to get the
    // avatar URL, which may not be present in the auth token response.
    final currentUserAsync = ref.watch(currentUserProvider);
    String? backendAvatar;
    currentUserAsync.maybeWhen(
      data: (either) {
        either.fold((_) => null, (u) {
          backendAvatar =
              (u.avatar != null && u.avatar!.isNotEmpty) ? u.avatar : null;
        });
      },
      orElse: () {},
    );

    // Always keep the last known good user so the UI never collapses to
    // defaults while the notifier is in loading state.
    if (user != null) _cachedUser = user;
    final displayUser = _cachedUser;

    // Resolved avatar: prefer backend profile endpoint over auth-token user.
    final resolvedAvatar =
        backendAvatar ??
        (displayUser?.avatar?.isNotEmpty == true ? displayUser!.avatar : null);

    // Populate form controllers exactly once (when user first becomes available).
    if (!_hasPopulated && displayUser != null) {
      _hasPopulated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => _populateFromUser(displayUser));
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: context.l10n.profileTitle,
          actions: [
            if (!_isEditing)
              IconButton(
                icon: Icon(
                  LucideIcons.edit,
                  size: 20,
                  color: isDark ? Colors.white70 : AppColors.white,
                ),
                onPressed: () => setState(() => _isEditing = true),
              ),
            IconButton(
              icon: Icon(
                LucideIcons.settings,
                size: 20,
                color: isDark ? Colors.white70 : AppColors.white,
              ),
              onPressed: _showSettingsMenu,
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Header with Avatar
                  _buildProfileHeader(context, displayUser, isDark, primaryColor, avatarUrl: resolvedAvatar),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Cards
                  _buildStatsCards(context, isDark, primaryColor),
                  
                  const SizedBox(height: 24),
                  
                  // Profile Form Card
                  _buildProfileForm(context, displayUser, isDark, primaryColor),
                  
                  const SizedBox(height: 16),
                  
                  // Additional Options
                  _buildAdditionalOptions(context, isDark, primaryColor),
                  
                  const SizedBox(height: 20),
                  
                  // Save Button (when editing)
                  if (_isEditing) _buildSaveButton(context, isDark, primaryColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, domain.User? user, bool isDark, Color primaryColor, {String? avatarUrl}) {
    final initials = _getInitials(user?.name);
    final avatarColor = primaryColor;
    final effectiveAvatar = avatarUrl ?? user?.avatar;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar with edit option
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.grey.shade200,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: avatarColor,
                  backgroundImage: _pickedAvatarFile != null
                      ? FileImage(_pickedAvatarFile!) as ImageProvider
                      : imageProviderFromUrl(effectiveAvatar),
                  child: (_pickedAvatarFile == null &&
                          (effectiveAvatar == null || effectiveAvatar.isEmpty))
                      ? Text(
                          initials,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(LucideIcons.camera, size: 20, color: primaryColor),
                      onPressed: _showAvatarPicker,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // User name and role
          Text(
            user?.name ?? 'User Name',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1A2634),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              // Prefer explicit admin flag, otherwise show first role name when
              // available (backend may supply `roles` or `type`). Fallback to
              // legacy `'company'` label.
              user?.isAdmin == true
                  ? 'Administrator'
                  : (user?.roles != null && user!.roles!.isNotEmpty && (user.roles!.first.name?.isNotEmpty ?? false)
                      ? user.roles!.first.name!
                      : 'company'),
              style: TextStyle(
                color: isDark ? Colors.white : primaryColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Member since
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.calendar, size: 14, color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                context.l10n.memberSince(_formatDate(user?.createdAt)),
                style: TextStyle(
                  color: isDark ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, bool isDark, Color primaryColor) {
    return Row(
      children: [
        // Stats cards commented out as in original
      ],
    );
  }

  Widget _buildProfileForm(BuildContext context, domain.User? user, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(LucideIcons.user, color: primaryColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    context.l10n.personalInformation,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Name Field
              _buildFormField(
                label: context.l10n.fullName,
                icon: LucideIcons.user,
                controller: _nameController,
                enabled: _isEditing,
                validator: (v) => (v == null || v.trim().isEmpty) ? context.l10n.pleaseEnterName : null,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Email Field (read-only)
              _buildFormField(
                label: context.l10n.emailAddress,
                icon: LucideIcons.mail,
                controller: _emailController,
                enabled: false,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Phone Field (show only when auth provides phone)
              if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                _buildFormField(
                  label: context.l10n.phoneNumber,
                  icon: LucideIcons.phone,
                  controller: _phoneController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white54 : Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          style: TextStyle(
            color: enabled 
                ? (isDark ? Colors.white : const Color(0xFF1A2634))
                : (isDark ? Colors.white38 : Colors.grey.shade500),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: isDark ? Colors.white54 : Colors.grey.shade500),
            filled: true,
            fillColor: enabled
                ? (isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50)
                : (isDark ? Colors.white.withOpacity(0.02) : Colors.grey.shade100),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildOptionTile(
            icon: LucideIcons.lock,
            label: context.l10n.changePassword,
            subtitle: context.l10n.changePasswordSubtitle,
            color: Colors.blue,
            onTap: _changePassword,
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: LucideIcons.bell,
            label: context.l10n.notificationSettings,
            subtitle: context.l10n.manageNotifications,
            color: Colors.green,
            onTap: () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: isDark ? Colors.white38 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 72,
      color: isDark ? Colors.white10 : Colors.grey.shade200,
    );
  }

  Widget _buildSaveButton(BuildContext context, bool isDark, Color primaryColor) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 20),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                context.l10n.saveChanges,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Future<void> _showAvatarPicker() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                context.l10n.updateProfilePhoto,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2634),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.choosePhotoFromDevice,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
              // Gallery option
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(LucideIcons.image, color: AppColors.primary, size: 20),
                ),
                title: Text(
                  context.l10n.chooseFromGallery,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                ),
                subtitle: Text(
                  context.l10n.pickImageFromPhotos,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImageFromGallery();
                },
              ),
              // Remove photo option (only if there's a current avatar or picked file)
              if (_pickedAvatarFile != null)
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
                  ),
                  title: Text(
                    context.l10n.removeSelectedPhoto,
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _pickedAvatarFile = null);
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return;
      final path = result.files.single.path;
      if (path == null) return;
      setState(() => _pickedAvatarFile = File(path));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  void _showSettingsMenu() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF151A2E) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              _buildMenuTile(
                icon: LucideIcons.moon,
                label: context.l10n.darkMode,
                trailing: Switch(
                  value: isDark,
                  onChanged: (value) {
                    // Toggle theme
                    Navigator.pop(context);
                  },
                  activeThumbColor: AppColors.primary,
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  // prefer authenticated user's lang, otherwise app provider
                  final code = ref.watch(authNotifierProvider).maybeWhen(
                    authenticated: (u) => u.lang ?? ref.watch(appLocaleProvider),
                    orElse: () => ref.watch(appLocaleProvider),
                  );
                  return _buildMenuTile(
                    icon: LucideIcons.globe,
                    label: context.l10n.language,
                    // subtitle: languageLabel(code),
                    onTap: _showLanguageSelection,
                  );
                },
              ),
              _buildMenuTile(
                icon: LucideIcons.volume,
                label: context.l10n.sound,
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildMenuTile(
                icon: LucideIcons.server,
                label: context.l10n.switchWorkspace,
                subtitle: context.l10n.changeWorkspaceSubtitle,
                onTap: () {
                  Navigator.pop(context);
                  _showSwitchWorkspaceConfirmation();
                },
              ),
              _buildMenuTile(
                icon: LucideIcons.logOut,
                label: context.l10n.signOut,
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmation();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final selected = ref.watch(appLocaleProvider);

          Widget langTile(String code, String label) {
            return ListTile(
              title: Text(label),
              trailing: selected == code
                  ? Icon(LucideIcons.check, color: AppColors.primary)
                  : null,
              onTap: () async {
                Navigator.pop(context); // close language selector

                // if no change, skip (prefer local app setting)
                final currentLang = ref.read(appLocaleProvider);
                if (currentLang == code) return;

                // Update provider
                ref.read(appLocaleProvider.notifier).setLocale(code);
                
                // Show confirmation
                if (mounted) {
                  context.showSuccessModal(
                    title: context.l10n.success,
                    message: context.l10n.languageUpdatedSuccess,
                    buttonText: context.l10n.done,
                  );
                }
              },
            );
          }

          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF151A2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.l10n.selectLanguage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Language options
                  langTile('en', 'English'),
                  langTile('sw', 'Swahili'),
                  langTile('fr', 'Français'),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String label,
    String? subtitle,
    Widget? trailing,
    Color? color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = color ?? (isDark ? Colors.white70 : Colors.grey.shade700);
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? (isDark ? Colors.white : const Color(0xFF1A2634)),
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(color: isDark ? Colors.white54 : Colors.grey.shade600))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLogoutConfirmation() {
    context.showConfirmationModal(
      title: context.l10n.signOut,
      message: context.l10n.signOutMessage,
      confirmText: context.l10n.signOut,
      onConfirm: () async {
        await ref.read(authNotifierProvider.notifier).logout();
        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      },
      icon: LucideIcons.logOut,
      confirmColor: Colors.red,
    );
  }

  void _showSwitchWorkspaceConfirmation() {
    context.showConfirmationModal(
      title: context.l10n.switchWorkspace,
      message: context.l10n.switchWorkspaceMessage,
      confirmText: context.l10n.switchButton,
      onConfirm: () async {
        // clear tenant and session
        await ref.read(tenantLocalDataSourceProvider).clearTenant();
        ref.read(tenantProvider.notifier).state = null;
        await ref.read(authNotifierProvider.notifier).logout();

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil('/workspace', (route) => false);
        }
      },
      icon: LucideIcons.server,
      confirmColor: Colors.orange,
    );
  }

  String _formatDate(dynamic dateTime) {
    if (dateTime == null) return 'Unknown';
    try {
      final date = dateTime is DateTime ? dateTime : DateTime.parse(dateTime.toString());
      final formatter = DateFormat('MMMM yyyy');
      return formatter.format(date);
    } catch (e) {
      return 'Unknown';
    }
  }
}

String languageLabel(String code) {
  switch (code) {
    case 'en':
      return 'English';
    case 'sw':
      return 'Swahili';
    case 'fr':
      return 'French';
    default:
      return 'English';
  }
}