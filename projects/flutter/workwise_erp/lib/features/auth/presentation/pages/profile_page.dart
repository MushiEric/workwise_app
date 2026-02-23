import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:workwise_erp/core/widgets/app_textfield.dart';

import '../../domain/entities/user.dart' as domain;
import '../providers/auth_providers.dart';
import '../state/auth_state.dart';
import '../../../../core/provider/tenant_provider.dart';
import '../../../../core/storage/tenant_local_data_source.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_modal.dart';
import '../../../../core/themes/app_colors.dart';
import 'package:workwise_erp/core/utils/image_utils.dart';
import 'package:intl/intl.dart';
import 'package:workwise_erp/core/provider/locale_provider.dart';

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
  String? _selectedAvatarColor;

  final List<Color> _avatarColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
  ];

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
    
    final payload = {
      'name': _nameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'bio': _bioController.text.trim(),
    };

    try {
      await ref.read(authNotifierProvider.notifier).updateProfile(payload);
      setState(() {
        _isLoading = false;
        _isEditing = false;
      });
      
      if (mounted) {
        context.showSuccessModal(
          title: 'Success!',
          message: 'Your profile has been updated successfully.',
          buttonText: 'Done',
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        context.showInfoModal(
          title: 'Update Failed',
          message: e.toString(),
          buttonText: 'Try Again',
        );
      }
    }
  }

  Future<void> _changePassword() async {
    // Navigate to change password screen or show modal
    if (mounted) {
      context.showFormModal(
        title: 'Change Password',
        form: Column(
          children: [
            AppTextField(
              obscureText: true,
              
            ),
            const SizedBox(height: 16),
            AppTextField(
              obscureText: true,
                labelText: 'New Password',
            ),
            const SizedBox(height: 16),
            AppTextField(
              obscureText: true,
            labelText: 'Confirm New Password',
            ),
          ],
        ),
        onSubmit: () {
          // Handle password change
          Navigator.pop(context);
          context.showSuccessModal(
            title: 'Password Updated',
            message: 'Your password has been changed successfully.',
            buttonText: 'OK',
          );
        },
        submitText: 'Save Changes',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;
    
    // Use currentUserProvider to prefill form (falls back to auth state)
    final currentUserAsync = ref.watch(currentUserProvider);

    domain.User? user;
    currentUserAsync.maybeWhen(
      data: (either) => either.fold((l) => null, (r) => user = r),
      orElse: () {},
    );

    // if provider not ready, try AuthState
    final authState = ref.watch(authNotifierProvider);
    authState.maybeWhen(authenticated: (u) => user ??= u, orElse: () {});

    // populate controllers once (when user becomes available)
    WidgetsBinding.instance.addPostFrameCallback((_) => _populateFromUser(user));

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          if (mounted && !_isLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(LucideIcons.checkCircle, color: Colors.green.shade400),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Profile updated successfully')),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green.shade50,
              
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        error: (msg) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(LucideIcons.alertCircle, color: Colors.red.shade400),
                    const SizedBox(width: 12),
                    Expanded(child: Text(msg)),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red.shade50,
                
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        },
        orElse: () {},
      );
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: "My Profile",
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
                  _buildProfileHeader(context, user, isDark, primaryColor),
                  
                  const SizedBox(height: 24),
                  
                  // Stats Cards
                  _buildStatsCards(context, isDark, primaryColor),
                  
                  const SizedBox(height: 24),
                  
                  // Profile Form Card
                  _buildProfileForm(context, user, isDark, primaryColor),
                  
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

  Widget _buildProfileHeader(BuildContext context, domain.User? user, bool isDark, Color primaryColor) {
    final initials = _getInitials(user?.name);
    final avatarColor = _selectedAvatarColor != null 
        ? Color(int.parse(_selectedAvatarColor!.replaceFirst('#', '0xff')))
        : primaryColor;

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
                  backgroundImage: imageProviderFromUrl(user?.avatar),
                  child: (user?.avatar == null || user!.avatar!.isEmpty)
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
                'Member since ${_formatDate(user?.createdAt)}',
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
        // Expanded(
        //   child: _buildStatCard(
        //     'Projects',
        //     '24',
        //     LucideIcons.folder,
        //     Colors.blue,
        //     isDark,
        //   ),
        // ),
        const SizedBox(width: 12),
        // Expanded(
        //   child: _buildStatCard(
        //     'Tasks',
        //     '156',
        //     LucideIcons.checkSquare,
        //     Colors.green,
        //     isDark,
        //   ),
        // ),
        // const SizedBox(width: 12),
        // Expanded(
        //   child: _buildStatCard(
        //     'Tickets',
        //     '8',
        //     LucideIcons.headphones,
        //     Colors.orange,
        //     isDark,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2634),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
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
                    'Personal Information',
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
                label: 'Full Name',
                icon: LucideIcons.user,
                controller: _nameController,
                enabled: _isEditing,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter name' : null,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Email Field (read-only)
              _buildFormField(
                label: 'Email Address',
                icon: LucideIcons.mail,
                controller: _emailController,
                enabled: false,
                isDark: isDark,
              ),
              
              const SizedBox(height: 16),
              
              // Phone Field (show only when auth provides phone)
              if (user?.phone != null && user!.phone!.isNotEmpty) ...[
                _buildFormField(
                  label: 'Phone Number',
                  icon: LucideIcons.phone,
                  controller: _phoneController,
                  enabled: _isEditing,
                  keyboardType: TextInputType.phone,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),
              ],

              // Bio Field (kept commented)
              const SizedBox(height: 16),
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
            label: 'Change Password',
            subtitle: 'Update your password regularly',
            color: Colors.blue,
            onTap: _changePassword,
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: LucideIcons.bell,
            label: 'Notification Settings',
            subtitle: 'Manage your notifications',
            color: Colors.green,
            onTap: () {},
            isDark: isDark,
          ),
          /* -- Temporarily disabled (may be re-activated later): Privacy & Security, Help & Support
          _buildDivider(isDark),
          _buildOptionTile(
            icon: LucideIcons.shield,
            label: 'Privacy & Security',
            subtitle: 'Two-factor authentication, login history',
            color: Colors.purple,
            onTap: () {},
            isDark: isDark,
          ),
          _buildDivider(isDark),
          _buildOptionTile(
            icon: LucideIcons.helpCircle,
            label: 'Help & Support',
            subtitle: 'FAQs, contact support',
            color: Colors.orange,
            onTap: () {},
            isDark: isDark,
            showBorder: false,
          ),
          */
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
    bool showBorder = true,
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
            : const Text(
                'Save Changes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _showAvatarPicker() {
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
              const Text(
                'Choose Avatar Color',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _avatarColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatarColor = '#${color.value.toRadixString(16).substring(2)}';
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
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
                label: 'Dark Mode',
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
                    label: 'Language',
                    subtitle: languageLabel(code),
                    onTap: _showLanguageSelection,
                  );
                },
              ),
              _buildMenuTile(
                icon: LucideIcons.volume,
                label: 'Sound',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeThumbColor: AppColors.primary,
                ),
              ),
              _buildMenuTile(
                icon: LucideIcons.server,
                label: 'Switch Workspace',
                subtitle: 'Change workspace / tenant',
                onTap: () {
                  Navigator.pop(context);
                  _showSwitchWorkspaceConfirmation();
                },
              ),
              _buildMenuTile(
                icon: LucideIcons.logOut,
                label: 'Sign Out',
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
      builder: (context) => Consumer(builder: (context, ref, _) {
        final selected = ref.watch(appLocaleProvider);

        Widget _langTile(String code, String label) {
          return ListTile(
            title: Text(label),
            trailing: selected == code ? Icon(LucideIcons.check, color: AppColors.primary) : null,
            onTap: () async {
              Navigator.pop(context); // close language selector

              // if no change, skip (prefer local app setting)
              final currentLang = ref.read(appLocaleProvider);
              if (currentLang == code) return;

              // persist locally and update provider
              await ref.read(appLocaleProvider.notifier).setLocale(code);

              // show confirmation to user
              if (mounted) {
                context.showSuccessModal(
                  title: 'Success!',
                  message: 'Language updated successfully.',
                  buttonText: 'Done',
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
                Container(margin: const EdgeInsets.only(top: 12), width: 40, height: 4, decoration: BoxDecoration(color: isDark ? Colors.white24 : Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(alignment: Alignment.centerLeft, child: Text('Select Language', style: Theme.of(context).textTheme.titleMedium)),
                ),
                const SizedBox(height: 8),
                _langTile('en', 'English'),
                _langTile('sw', 'Swahili'),
                _langTile('fr', 'French'),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      }),
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
      title: 'Sign Out',
      message: 'Are you sure you want to sign out of your account?',
      confirmText: 'Sign Out',
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
      title: 'Switch Workspace',
      message: 'Switching workspace will sign you out and require entering a new workspace URL. Continue?',
      confirmText: 'Switch',
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