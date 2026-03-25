import '../../domain/entities/sales_settings.dart';

/// Converts raw JSON from /sales/getSalesSettings into a typed [SalesSettings].
///
/// Also provides [toFormConfig] which expands the raw map with alias keys so
/// the create-order form's legacy `_fieldEnabled(cfg, [...])` calls resolve
/// the correct API values without requiring any changes inside the form widget.
class SalesSettingsModel {
  // ── Private helpers ──────────────────────────────────────────────────────────

  static bool _b(dynamic v, {required bool def}) {
    if (v == null) return def;
    if (v is bool) return v;
    if (v is int) return v != 0;
    final s = v.toString().trim().toLowerCase();
    return s != '0' && s != 'false' && s != 'no' && s != 'off';
  }

  static int _i(dynamic v, {required int def}) {
    if (v == null) return def;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? def;
  }

  static String _s(dynamic v, {required String def}) {
    if (v == null) return def;
    return v.toString();
  }

  // ── Factory ──────────────────────────────────────────────────────────────────

  static SalesSettings fromJson(Map<String, dynamic> j) => SalesSettings(
    taxPerItem: _i(j['tax_per_item'], def: 1),
    discountPerItem: _i(j['discount_per_item'], def: 1),
    orderShowTitle: _b(j['order_show_title'], def: false),
    orderShowCustomer: _b(j['order_show_customer'], def: true),
    orderShowCurrency: _b(j['order_show_currency'], def: false),
    orderShowVehicleAllocation: _b(
      j['order_show_vehicle_allocation'],
      def: false,
    ),
    orderShowCargo: _b(j['order_show_cargo'], def: false),
    orderShowEndDate: _b(j['order_show_end_date'], def: false),
    orderShowPriority: _b(j['order_show_priority'], def: false),
    orderShowSenderReceiver: _b(j['order_show_sender_receiver'], def: false),
    orderShowAmount: _b(j['order_show_amount'], def: false),
    orderAmountRequired: _b(j['order_amount_required'], def: false),
    orderShowPackage: _b(j['order_show_package'], def: false),
    orderShowContract: _b(j['order_show_contract'], def: false),
    orderContractRequired: _b(j['order_contract_required'], def: false),
    orderShowRequest: _b(j['order_show_request'], def: false),
    orderShowPfi: _b(j['order_show_pfi'], def: false),
    orderShowLpo: _b(j['order_show_lpo'], def: false),
    orderShowPaymentType: _b(j['order_show_payment_type'], def: false),
    orderShowProf: _b(j['order_show_prof'], def: false),
    enableAutoQtyUnitCapture: _b(j['enable_auto_qty_unit_capture'], def: true),
    orderShowProductService: _b(j['order_show_product_service'], def: true),
    orderShowTruckList: _b(j['order_show_truck_list'], def: true),
    orderEnableVehicleCheckinCheckout: _b(
      j['order_enable_vehicle_checkin_checkout'],
      def: false,
    ),
    orderShowLocation: _b(j['order_show_location'], def: false),
    orderShowStatus: _b(j['order_show_status'], def: true),
    orderShowUserAssignment: _b(j['order_show_user_assignment'], def: false),
    orderAllowMultipleSenderReceiver: _b(
      j['order_allow_multiple_sender_receiver'],
      def: false,
    ),
    orderShowCustomerBalance: _b(j['order_show_customer_balance'], def: false),
    orderPrefix: _s(j['order_prefix'], def: 'ORD'),
    orderNumberFormat: _s(j['order_number_format'], def: 'year_number'),
    orderAfterSave: _s(j['order_after_save'], def: 'Nothing'),
  );

  // ── Form-config expansion ────────────────────────────────────────────────────

  /// Returns a copy of [raw] enriched with alias keys that match the keys the
  /// create-order form's `_fieldEnabled(cfg, [...])` helper checks.
  ///
  /// This lets the form's existing field-visibility logic work correctly with the
  /// real API response without modifying every widget call in the form.
  static Map<String, dynamic> toFormConfig(Map<String, dynamic> raw) {
    final out = Map<String, dynamic>.from(raw);

    // Helper: copy the value of [rawKey] into every [formKeys] entry (if absent).
    void alias(String rawKey, List<String> formKeys) {
      final val = raw[rawKey];
      for (final k in formKeys) {
        out.putIfAbsent(k, () => val);
      }
    }

    // Fields / sections that are always visible (no API key controls them).
    out['show_details_section'] = 1;
    out['enable_details_section'] = 1;
    out['show_other_details'] = 1;
    out['enable_other_details'] = 1;
    out['enable_start_date'] = 1;
    out['enable_order_number'] = 1;
    out['show_order_number'] = 1;
    out['enable_warehouse'] = 1;
    out['show_warehouse'] = 1;

    alias('order_show_title', ['enable_title', 'show_title']);
    alias('order_show_customer', ['enable_customer_id', 'enable_customer']);
    alias('order_show_currency', [
      'enable_currency',
      'show_currency',
      'enable_exchange_rate',
      'show_exchange_rate',
    ]);
    alias('order_show_vehicle_allocation', [
      'enable_vehicle_id',
      'enable_vehicle_dropdowns',
      'show_vehicle_dropdowns',
    ]);
    alias('order_show_cargo', ['enable_cargo_value', 'show_cargo_value']);
    alias('order_show_end_date', ['enable_end_date', 'show_end_date']);
    alias('order_show_priority', ['enable_priority', 'show_priority']);
    alias('order_show_status', [
      'enable_status_id',
      'enable_status',
      'show_status',
    ]);
    alias('order_show_user_assignment', [
      'enable_assign_user',
      'show_assign_user',
    ]);
    alias('order_show_sender_receiver', [
      'show_sender_receiver',
      'enable_sender_receiver',
      'enable_sender_name',
      'show_sender_name',
      'enable_sender_phone',
      'show_sender_phone',
      'enable_receiver_name',
      'show_receiver_name',
      'enable_receiver_phone',
      'show_receiver_phone',
      'enable_consignment_details',
      'show_consignment_details',
    ]);
    alias('order_show_amount', ['enable_amount', 'show_amount']);
    alias('order_show_package', ['enable_package_type', 'show_package_type']);
    alias('order_show_contract', ['enable_contract', 'show_contract']);
    alias('order_show_request', ['enable_request_id', 'show_request_id']);
    alias('order_show_pfi', ['enable_quotation', 'show_quotation']);
    alias('order_show_lpo', [
      'enable_lpo_number',
      'show_lpo_number',
      'enable_lpo_document',
      'show_lpo_document',
    ]);
    alias('order_show_payment_type', [
      'enable_payment_type',
      'show_payment_type',
    ]);
    alias('order_show_prof', [
      'enable_prof_of_payment',
      'show_prof_of_payment',
    ]);
    alias('order_show_product_service', [
      'show_items_section',
      'enable_items_section',
      'enable_items',
    ]);
    alias('order_show_truck_list', [
      'show_trucks_section',
      'enable_truck_details',
      'enable_trucks',
      'show_truck_list',
      'enable_truck_vehicle_id',
      'enable_vehicle_name',
      'show_vehicle_name',
      'enable_vehicle_plate_number',
      'show_vehicle_plate_number',
      'enable_vehicle_trailer_number',
      'show_vehicle_trailer_number',
      'enable_driver_name',
      'show_driver_name',
      'enable_driver_phone',
      'show_driver_phone',
      'enable_driver_license_number',
      'show_driver_license_number',
      'enable_truck_details',
      'show_truck_details',
    ]);
    alias('order_enable_vehicle_checkin_checkout', [
      'enable_checkin_weight',
      'show_checkin_weight',
    ]);
    alias('order_show_location', ['enable_location', 'show_location']);

    // The "Contract & Quotation" section header is shown if any of its
    // sub-fields are visible.
    final showContractSection =
        _b(raw['order_show_contract'], def: false) ||
        _b(raw['order_show_request'], def: false) ||
        _b(raw['order_show_pfi'], def: false) ||
        _b(raw['order_show_lpo'], def: false) ||
        _b(raw['order_show_payment_type'], def: false) ||
        _b(raw['order_show_prof'], def: false);
    out['show_contract_section'] = showContractSection ? 1 : 0;
    out['enable_contract_section'] = showContractSection ? 1 : 0;

    return out;
  }
}
