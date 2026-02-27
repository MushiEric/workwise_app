/// All dropdown/catalog data needed to render the jobcard creation form.
///
/// Each list contains raw maps from the backend.  The presentation layer
/// converts them into display-ready items; keeping them as maps avoids
/// introducing extra model classes for data that is used only in a form.
class JobcardFormData {
  final List<Map<String, dynamic>> vehicles;
  final List<Map<String, dynamic>> users;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> productUnits;

  const JobcardFormData({
    required this.vehicles,
    required this.users,
    required this.products,
    required this.productUnits,
  });

  /// Empty fallback – used when data cannot be loaded.
  const JobcardFormData.empty()
      : vehicles = const [],
        users = const [],
        products = const [],
        productUnits = const [];
}
