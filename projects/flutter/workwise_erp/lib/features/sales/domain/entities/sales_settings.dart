/// Typed representation of the sales settings returned by /sales/getSalesSettings.
/// Only fields relevant to the order creation form are modelled here.
class SalesSettings {
  // ── Shared ──────────────────────────────────────────────────────────────────
  /// Controls whether tax can be applied per line-item (>0 = enabled).
  final int taxPerItem;

  /// Controls whether discount can be applied per line-item (>0 = enabled).
  final int discountPerItem;

  // ── Order form visibility ────────────────────────────────────────────────────
  final bool orderShowTitle;
  final bool orderShowCustomer;
  final bool orderShowCurrency;

  /// Vehicle allocation dropdown in the Details section.
  final bool orderShowVehicleAllocation;
  final bool orderShowCargo;
  final bool orderShowEndDate;
  final bool orderShowPriority;

  // Sender & Receiver section (and all inner fields)
  final bool orderShowSenderReceiver;

  final bool orderShowAmount;

  /// Enforces the Amount field as required when [orderShowAmount] is also true.
  final bool orderAmountRequired;

  final bool orderShowPackage;
  final bool orderShowContract;

  /// Enforces the Contract field as required when [orderShowContract] is also true.
  final bool orderContractRequired;

  final bool orderShowRequest;

  /// Show the PFI / Quotation dropdown.
  final bool orderShowPfi;
  final bool orderShowLpo;
  final bool orderShowPaymentType;

  /// Proof of payment file upload.
  final bool orderShowProf;

  /// When true: selecting a product auto-fills qty to 1 and keeps the field
  /// editable. When false: qty is NOT auto-filled and the field is disabled.
  final bool enableAutoQtyUnitCapture;

  /// Products / Services items section.
  final bool orderShowProductService;

  /// Order Truck List section (and My Vehicle dropdown inside it).
  final bool orderShowTruckList;

  /// Check-in weight field inside the Truck List section.
  final bool orderEnableVehicleCheckinCheckout;

  final bool orderShowLocation;
  final bool orderShowStatus;
  final bool orderShowUserAssignment;
  final bool orderAllowMultipleSenderReceiver;

  /// Future use: show customer balance next to the customer selector.
  final bool orderShowCustomerBalance;

  // ── Config / meta ────────────────────────────────────────────────────────────
  final String orderPrefix;
  final String orderNumberFormat;

  /// Default "After Save Order" action pre-selected in the radio group.
  final String orderAfterSave;

  const SalesSettings({
    required this.taxPerItem,
    required this.discountPerItem,
    required this.orderShowTitle,
    required this.orderShowCustomer,
    required this.orderShowCurrency,
    required this.orderShowVehicleAllocation,
    required this.orderShowCargo,
    required this.orderShowEndDate,
    required this.orderShowPriority,
    required this.enableAutoQtyUnitCapture,
    required this.orderShowSenderReceiver,
    required this.orderShowAmount,
    required this.orderAmountRequired,
    required this.orderShowPackage,
    required this.orderShowContract,
    required this.orderContractRequired,
    required this.orderShowRequest,
    required this.orderShowPfi,
    required this.orderShowLpo,
    required this.orderShowPaymentType,
    required this.orderShowProf,
    required this.orderShowProductService,
    required this.orderShowTruckList,
    required this.orderEnableVehicleCheckinCheckout,
    required this.orderShowLocation,
    required this.orderShowStatus,
    required this.orderShowUserAssignment,
    required this.orderAllowMultipleSenderReceiver,
    required this.orderShowCustomerBalance,
    required this.orderPrefix,
    required this.orderNumberFormat,
    required this.orderAfterSave,
  });

  /// Safe fallback used when the settings API call fails — shows a
  /// sensible minimal set so the form remains usable offline.
  static const SalesSettings defaults = SalesSettings(
    taxPerItem: 1,
    discountPerItem: 1,
    enableAutoQtyUnitCapture: true,
    orderShowTitle: false,
    orderShowCustomer: true,
    orderShowCurrency: false,
    orderShowVehicleAllocation: false,
    orderShowCargo: false,
    orderShowEndDate: false,
    orderShowPriority: false,
    orderShowSenderReceiver: false,
    orderShowAmount: false,
    orderAmountRequired: false,
    orderShowPackage: false,
    orderShowContract: false,
    orderContractRequired: false,
    orderShowRequest: false,
    orderShowPfi: false,
    orderShowLpo: false,
    orderShowPaymentType: false,
    orderShowProf: false,
    orderShowProductService: true,
    orderShowTruckList: true,
    orderEnableVehicleCheckinCheckout: false,
    orderShowLocation: false,
    orderShowStatus: true,
    orderShowUserAssignment: false,
    orderAllowMultipleSenderReceiver: false,
    orderShowCustomerBalance: false,
    orderPrefix: 'ORD',
    orderNumberFormat: 'year_number',
    orderAfterSave: 'Nothing',
  );
}
