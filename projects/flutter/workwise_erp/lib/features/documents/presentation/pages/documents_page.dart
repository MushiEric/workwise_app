import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/widgets/app_bar.dart';
import '../../../../core/themes/app_colors.dart';

class DocumentPage extends ConsumerStatefulWidget {
  const DocumentPage({super.key});

  @override
  ConsumerState<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends ConsumerState<DocumentPage> with TickerProviderStateMixin {
  bool _isGridView = true;
  bool _isSearching = false;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock folder data
  final List<DocumentFolder> _folders = const [
    DocumentFolder(
      name: 'Employees',
      icon: Icons.folder_open_rounded,
      color: Colors.blue,
      count: 24,
      size: '156 MB',
    ),
    DocumentFolder(
      name: 'Projects',
      icon: Icons.folder,
      color: Colors.green,
      count: 18,
      size: '892 MB',
    ),
    DocumentFolder(
      name: 'Logistics',
      icon: Icons.folder_open_rounded,
      color: Colors.orange,
      count: 12,
      size: '345 MB',
    ),
    DocumentFolder(
      name: 'Orders',
      icon: Icons.folder_open_rounded,
      color: Colors.purple,
      count: 36,
      size: '1.2 GB',
    ),
    DocumentFolder(
      name: 'Invoices',
      icon: Icons.folder_open_rounded,
      color: Colors.red,
      count: 42,
      size: '78 MB',
    ),
    DocumentFolder(
      name: 'Contracts',
      icon: Icons.folder_open_rounded,
      color: Colors.teal,
      count: 15,
      size: '234 MB',
    ),
    DocumentFolder(
      name: 'Reports',
      icon: Icons.folder_open_rounded,
      color: Colors.indigo,
      count: 28,
      size: '567 MB',
    ),
    DocumentFolder(
      name: 'Templates',
      icon: Icons.folder_open_rounded,
      color: Colors.brown,
      count: 9,
      size: '45 MB',
    ),
  ];

  // Mock recent files
  final List<DocumentFile> _recentFiles = const [
    DocumentFile(
      name: 'Q4_Report_2024.pdf',
      type: 'pdf',
      size: '2.4 MB',
      modified: 'Today, 10:30 AM',
      folder: 'Reports',
    ),
    DocumentFile(
      name: 'Employee_Handbook.docx',
      type: 'docx',
      size: '1.8 MB',
      modified: 'Yesterday',
      folder: 'Employees',
    ),
    DocumentFile(
      name: 'Project_Alpha_Specs.xlsx',
      type: 'xlsx',
      size: '856 KB',
      modified: 'Mar 15, 2024',
      folder: 'Projects',
    ),
    DocumentFile(
      name: 'Delivery_Note_1234.pdf',
      type: 'pdf',
      size: '3.2 MB',
      modified: 'Mar 12, 2024',
      folder: 'Logistics',
    ),
    DocumentFile(
      name: 'PO-2024-056.pdf',
      type: 'pdf',
      size: '1.1 MB',
      modified: 'Mar 10, 2024',
      folder: 'Orders',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primary;

    // Filter folders based on search
    final filteredFolders = _searchController.text.isEmpty
        ? _folders
        : _folders.where((f) => 
            f.name.toLowerCase().contains(_searchController.text.toLowerCase())
          ).toList();

    // Filter files based on search
    final filteredFiles = _searchController.text.isEmpty
        ? _recentFiles
        : _recentFiles.where((f) => 
            f.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            f.folder.toLowerCase().contains(_searchController.text.toLowerCase())
          ).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A0E21) : const Color(0xFFF8F9FC),
        appBar: CustomAppBar(
          title: "Documents",
          actions: [
            // Search button
            if (!_isSearching)
              IconButton(
                icon: Icon(
                 LucideIcons.search,
                  size: 18,
                  color: isDark ? Colors.white54 : AppColors.white,
                ),
                onPressed: () {
                  setState(() => _isSearching = true);
                },
              ),
            
            // View toggle (grid/list)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => setState(() => _isGridView = true),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isGridView 
                          ? primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                    LucideIcons.grid,
                      size: 20,
                      color: _isGridView 
                          ? primaryColor
                          : (isDark ? Colors.white54 : AppColors.white),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() => _isGridView = false),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !_isGridView 
                          ? primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                    LucideIcons.list,
                      size: 20,
                      color: !_isGridView 
                          ? primaryColor
                          : (isDark ? Colors.white54 : AppColors.white),
                    ),
                  ),
                ),
              ],
            ),

            // More options
            IconButton(
              icon: Icon(
                LucideIcons.moreHorizontal,
                size: 20,
                color: isDark ? Colors.white54 : AppColors.white,
              ),
              onPressed: _showMoreOptions,
            ),
          ],
        ),
        body: Column(
          children: [
            // Animated Search Bar
            if (_isSearching)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 70,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search folders and files...',
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey.shade500,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: isDark ? Colors.white54 : Colors.grey.shade600,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _isSearching = false;
                          });
                        },
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1A2634),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
              ),

            // Storage Info Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Storage Used',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: 0.68,
                                  backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '68%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '3.4 GB of 5 GB used',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.cloud_upload_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Upload',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Access Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickChip('All Files', Icons.folder_rounded, true, isDark, primaryColor),
                    _buildQuickChip('Recent', Icons.history_rounded, false, isDark, primaryColor),
                    _buildQuickChip('Shared', Icons.share_rounded, false, isDark, primaryColor),
                    _buildQuickChip('Starred', Icons.star_rounded, false, isDark, primaryColor),
                    _buildQuickChip('Trash', Icons.delete_outline_rounded, false, isDark, primaryColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Folders Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.folder_rounded,
                          size: 16,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Folders',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('View All'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Folders Grid/List
            if (filteredFolders.isEmpty && _searchController.text.isNotEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_off_rounded,
                        size: 64,
                        color: isDark ? Colors.white24 : Colors.grey.shade300,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No folders found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_isGridView)
              _buildFolderGrid(filteredFolders, isDark, primaryColor)
            else
              _buildFolderList(filteredFolders, isDark, primaryColor),

            // Recent Files Section
            if (_searchController.text.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.history_rounded,
                            size: 16,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Recent Files',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A2634),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Recent Files List
              _buildRecentFilesList(filteredFiles, isDark, primaryColor),
            ] else if (filteredFiles.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.search_rounded,
                        size: 16,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search Results',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A2634),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildRecentFilesList(filteredFiles, isDark, primaryColor),
            ],
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _showUploadOptions(context);
          },
          icon: const Icon(Icons.cloud_upload_rounded),
          label: const Text('Upload'),
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickChip(String label, IconData icon, bool isSelected, bool isDark, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        avatar: Icon(
          icon,
          size: 16,
          color: isSelected ? primaryColor : (isDark ? Colors.white54 : Colors.grey.shade600),
        ),
        backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
        selectedColor: primaryColor.withOpacity(0.1),
        checkmarkColor: primaryColor,
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : (isDark ? Colors.white70 : Colors.grey.shade700),
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? primaryColor : (isDark ? Colors.white10 : Colors.grey.shade300),
            width: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildFolderGrid(List<DocumentFolder> folders, bool isDark, Color primaryColor) {
    return Expanded(
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return _buildFolderCard(folder, isDark, primaryColor);
        },
      ),
    );
  }

  Widget _buildFolderList(List<DocumentFolder> folders, bool isDark, Color primaryColor) {
    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: folders.length,
        itemBuilder: (context, index) {
          final folder = folders[index];
          return _buildFolderListItem(folder, isDark, primaryColor);
        },
      ),
    );
  }

  Widget _buildFolderCard(DocumentFolder folder, bool isDark, Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: folder.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    folder.icon,
                    color: folder.color,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  folder.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? Colors.white : const Color(0xFF1A2634),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${folder.count} items • ${folder.size}',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFolderListItem(DocumentFolder folder, bool isDark, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: folder.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    folder.icon,
                    color: folder.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        folder.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${folder.count} items • ${folder.size}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white38 : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentFilesList(List<DocumentFile> files, bool isDark, Color primaryColor) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return _buildFileItem(file, isDark, primaryColor);
        },
      ),
    );
  }

  Widget _buildFileItem(DocumentFile file, bool isDark, Color primaryColor) {
    final fileColor = _getFileColor(file.type);
    final fileIcon = _getFileIcon(file.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151A2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: fileColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    fileIcon,
                    color: fileColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: isDark ? Colors.white : const Color(0xFF1A2634),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: fileColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              file.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: fileColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            file.size,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '•',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            file.modified,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 18,
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: isDark ? const Color(0xFF151A2E) : Colors.white,
                    onSelected: (value) {},
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'preview',
                        child: Row(
                          children: [
                            Icon(Icons.visibility_rounded, size: 18, color: primaryColor),
                            const SizedBox(width: 8),
                            const Text('Preview'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'download',
                        child: Row(
                          children: [
                            Icon(Icons.download_rounded, size: 18, color: Colors.green),
                            const SizedBox(width: 8),
                            const Text('Download'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            Icon(Icons.share_rounded, size: 18, color: Colors.blue),
                            const SizedBox(width: 8),
                            const Text('Share'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_rounded, size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getFileColor(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'docx':
      case 'doc':
        return Colors.blue;
      case 'xlsx':
      case 'xls':
        return Colors.green;
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'docx':
      case 'doc':
        return Icons.description_rounded;
      case 'xlsx':
      case 'xls':
        return Icons.table_chart_rounded;
      case 'jpg':
      case 'png':
      case 'jpeg':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  void _showMoreOptions() {
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
              _buildOptionTile(
                icon: Icons.create_new_folder_rounded,
                label: 'New Folder',
                color: Colors.blue,
              ),
              _buildOptionTile(
                icon: Icons.cloud_upload_rounded,
                label: 'Upload Files',
                color: Colors.green,
              ),
              _buildOptionTile(
                icon: Icons.drive_folder_upload_rounded,
                label: 'Upload Folder',
                color: Colors.orange,
              ),
              _buildOptionTile(
                icon: Icons.storage_rounded,
                label: 'Storage Settings',
                color: Colors.purple,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A2634),
        ),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  void _showUploadOptions(BuildContext context) {
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
                'Upload Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildUploadOption(
                icon: Icons.image_rounded,
                label: 'Photos & Images',
                color: Colors.purple,
              ),
              _buildUploadOption(
                icon: Icons.picture_as_pdf_rounded,
                label: 'Documents & PDFs',
                color: Colors.red,
              ),
              _buildUploadOption(
                icon: Icons.folder_rounded,
                label: 'Folder',
                color: Colors.blue,
              ),
              _buildUploadOption(
                icon: Icons.camera_alt_rounded,
                label: 'Take Photo',
                color: Colors.green,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF1A2634),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isDark ? Colors.white38 : Colors.grey.shade400,
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}

// Mock data classes
class DocumentFolder {
  final String name;
  final IconData icon;
  final Color color;
  final int count;
  final String size;

  const DocumentFolder({
    required this.name,
    required this.icon,
    required this.color,
    required this.count,
    required this.size,
  });
}

class DocumentFile {
  final String name;
  final String type;
  final String size;
  final String modified;
  final String folder;

  const DocumentFile({
    required this.name,
    required this.type,
    required this.size,
    required this.modified,
    required this.folder,
  });
}