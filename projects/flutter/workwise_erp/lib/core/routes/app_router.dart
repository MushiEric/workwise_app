import 'package:flutter/widgets.dart';

import '../../features/auth/presentation/routes/auth_router.dart';
import '../../features/logistic/presentation/routes/logistic_router.dart';
import '../../features/jobcard/presentation/routes/jobcard_router.dart';
import '../../features/support/presentation/routes/support_router.dart';

// Remaining feature pages not yet split into their own routers
import '../../features/index/presentation/pages/index_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/pfi/presentation/pages/pfi_page.dart';
import '../../features/customer/presentation/pages/customer_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/project/presentation/pages/project_page.dart';
import '../../features/project/presentation/pages/projects_page.dart';
import '../../features/project/presentation/pages/project_detail_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/notification/presentation/pages/notifications_page.dart';
import '../../features/hr/presentation/pages/hr_page.dart';

// TODO(assets): Temporarily disabled — uncomment when assets module is restored
// import '../../features/assets/presentation/pages/assets_page.dart';
// import '../../features/assets/presentation/pages/asset_detail_page.dart';

class AppRouter {
  AppRouter._();

  static Map<String, WidgetBuilder> get routes => {
    ...AuthRouter.routes,
    ...LogisticRouter.routes,
    ...JobcardRouter.routes,
    ...SupportRouter.routes,

    '/index': (_) => const IndexPage(),
    '/sales': (_) => const SalesPage(),
    '/pfi': (_) => const PfiPage(),
    '/customers': (_) => const CustomerPage(),
    '/inventory': (_) => const InventoryPage(),
    '/project': (_) => const ProjectPage(),
    '/projects': (_) => const ProjectsPage(),
    '/projects/detail': (_) => const ProjectDetailPage(),
    '/documents': (_) => const DocumentPage(),
    '/notifications': (_) => const NotificationsPage(),
    '/hr': (_) => const HRPage(),
    // TODO(assets): Temporarily disabled
    // '/assets': (_) => const AssetsPage(),
    // '/assets/detail': (_) => const AssetDetailPage(),
  };
}
