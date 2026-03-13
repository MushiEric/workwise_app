// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'support_ticket_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SupportTicketModel _$SupportTicketModelFromJson(Map<String, dynamic> json) {
  return _SupportTicketModel.fromJson(json);
}

/// @nodoc
mixin _$SupportTicketModel {
  int? get id => throw _privateConstructorUsedError;
  String? get subject => throw _privateConstructorUsedError;
  @JsonKey(name: 'ticket_code')
  String? get ticketCode => throw _privateConstructorUsedError;
  PriorityModel? get priority => throw _privateConstructorUsedError;
  StatusModel? get statuses => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  String? get endDate => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'customer_row')
  CustomerModel? get customerName => throw _privateConstructorUsedError;
  List<SupportReplyModel>? get replies => throw _privateConstructorUsedError;
  List<Map<String, dynamic>>? get attachments =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_by')
  int? get createdBy => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  List<String>? get services => throw _privateConstructorUsedError;
  @JsonKey(name: 'assign_user')
  AssignedUserModel? get assignUser => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get department => throw _privateConstructorUsedError;
  List<String>? get supervisors => throw _privateConstructorUsedError;

  /// Serializes this SupportTicketModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SupportTicketModelCopyWith<SupportTicketModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SupportTicketModelCopyWith<$Res> {
  factory $SupportTicketModelCopyWith(
    SupportTicketModel value,
    $Res Function(SupportTicketModel) then,
  ) = _$SupportTicketModelCopyWithImpl<$Res, SupportTicketModel>;
  @useResult
  $Res call({
    int? id,
    String? subject,
    @JsonKey(name: 'ticket_code') String? ticketCode,
    PriorityModel? priority,
    StatusModel? statuses,
    @JsonKey(name: 'end_date') String? endDate,
    String? description,
    @JsonKey(name: 'customer_row') CustomerModel? customerName,
    List<SupportReplyModel>? replies,
    List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') int? createdBy,
    String? category,
    List<String>? services,
    @JsonKey(name: 'assign_user') AssignedUserModel? assignUser,
    String? location,
    String? department,
    List<String>? supervisors,
  });

  $PriorityModelCopyWith<$Res>? get priority;
  $StatusModelCopyWith<$Res>? get statuses;
  $CustomerModelCopyWith<$Res>? get customerName;
}

/// @nodoc
class _$SupportTicketModelCopyWithImpl<$Res, $Val extends SupportTicketModel>
    implements $SupportTicketModelCopyWith<$Res> {
  _$SupportTicketModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? subject = freezed,
    Object? ticketCode = freezed,
    Object? priority = freezed,
    Object? statuses = freezed,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? customerName = freezed,
    Object? replies = freezed,
    Object? attachments = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? category = freezed,
    Object? services = freezed,
    Object? assignUser = freezed,
    Object? location = freezed,
    Object? department = freezed,
    Object? supervisors = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: freezed == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int?,
            subject: freezed == subject
                ? _value.subject
                : subject // ignore: cast_nullable_to_non_nullable
                      as String?,
            ticketCode: freezed == ticketCode
                ? _value.ticketCode
                : ticketCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            priority: freezed == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as PriorityModel?,
            statuses: freezed == statuses
                ? _value.statuses
                : statuses // ignore: cast_nullable_to_non_nullable
                      as StatusModel?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            customerName: freezed == customerName
                ? _value.customerName
                : customerName // ignore: cast_nullable_to_non_nullable
                      as CustomerModel?,
            replies: freezed == replies
                ? _value.replies
                : replies // ignore: cast_nullable_to_non_nullable
                      as List<SupportReplyModel>?,
            attachments: freezed == attachments
                ? _value.attachments
                : attachments // ignore: cast_nullable_to_non_nullable
                      as List<Map<String, dynamic>>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdBy: freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                      as int?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            services: freezed == services
                ? _value.services
                : services // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            assignUser: freezed == assignUser
                ? _value.assignUser
                : assignUser // ignore: cast_nullable_to_non_nullable
                      as AssignedUserModel?,
            location: freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                      as String?,
            department: freezed == department
                ? _value.department
                : department // ignore: cast_nullable_to_non_nullable
                      as String?,
            supervisors: freezed == supervisors
                ? _value.supervisors
                : supervisors // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PriorityModelCopyWith<$Res>? get priority {
    if (_value.priority == null) {
      return null;
    }

    return $PriorityModelCopyWith<$Res>(_value.priority!, (value) {
      return _then(_value.copyWith(priority: value) as $Val);
    });
  }

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StatusModelCopyWith<$Res>? get statuses {
    if (_value.statuses == null) {
      return null;
    }

    return $StatusModelCopyWith<$Res>(_value.statuses!, (value) {
      return _then(_value.copyWith(statuses: value) as $Val);
    });
  }

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomerModelCopyWith<$Res>? get customerName {
    if (_value.customerName == null) {
      return null;
    }

    return $CustomerModelCopyWith<$Res>(_value.customerName!, (value) {
      return _then(_value.copyWith(customerName: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SupportTicketModelImplCopyWith<$Res>
    implements $SupportTicketModelCopyWith<$Res> {
  factory _$$SupportTicketModelImplCopyWith(
    _$SupportTicketModelImpl value,
    $Res Function(_$SupportTicketModelImpl) then,
  ) = __$$SupportTicketModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? id,
    String? subject,
    @JsonKey(name: 'ticket_code') String? ticketCode,
    PriorityModel? priority,
    StatusModel? statuses,
    @JsonKey(name: 'end_date') String? endDate,
    String? description,
    @JsonKey(name: 'customer_row') CustomerModel? customerName,
    List<SupportReplyModel>? replies,
    List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'created_by') int? createdBy,
    String? category,
    List<String>? services,
    @JsonKey(name: 'assign_user') AssignedUserModel? assignUser,
    String? location,
    String? department,
    List<String>? supervisors,
  });

  @override
  $PriorityModelCopyWith<$Res>? get priority;
  @override
  $StatusModelCopyWith<$Res>? get statuses;
  @override
  $CustomerModelCopyWith<$Res>? get customerName;
}

/// @nodoc
class __$$SupportTicketModelImplCopyWithImpl<$Res>
    extends _$SupportTicketModelCopyWithImpl<$Res, _$SupportTicketModelImpl>
    implements _$$SupportTicketModelImplCopyWith<$Res> {
  __$$SupportTicketModelImplCopyWithImpl(
    _$SupportTicketModelImpl _value,
    $Res Function(_$SupportTicketModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? subject = freezed,
    Object? ticketCode = freezed,
    Object? priority = freezed,
    Object? statuses = freezed,
    Object? endDate = freezed,
    Object? description = freezed,
    Object? customerName = freezed,
    Object? replies = freezed,
    Object? attachments = freezed,
    Object? createdAt = freezed,
    Object? createdBy = freezed,
    Object? category = freezed,
    Object? services = freezed,
    Object? assignUser = freezed,
    Object? location = freezed,
    Object? department = freezed,
    Object? supervisors = freezed,
  }) {
    return _then(
      _$SupportTicketModelImpl(
        id: freezed == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int?,
        subject: freezed == subject
            ? _value.subject
            : subject // ignore: cast_nullable_to_non_nullable
                  as String?,
        ticketCode: freezed == ticketCode
            ? _value.ticketCode
            : ticketCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: freezed == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as PriorityModel?,
        statuses: freezed == statuses
            ? _value.statuses
            : statuses // ignore: cast_nullable_to_non_nullable
                  as StatusModel?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        customerName: freezed == customerName
            ? _value.customerName
            : customerName // ignore: cast_nullable_to_non_nullable
                  as CustomerModel?,
        replies: freezed == replies
            ? _value._replies
            : replies // ignore: cast_nullable_to_non_nullable
                  as List<SupportReplyModel>?,
        attachments: freezed == attachments
            ? _value._attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, dynamic>>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _value.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as int?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        services: freezed == services
            ? _value._services
            : services // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        assignUser: freezed == assignUser
            ? _value.assignUser
            : assignUser // ignore: cast_nullable_to_non_nullable
                  as AssignedUserModel?,
        location: freezed == location
            ? _value.location
            : location // ignore: cast_nullable_to_non_nullable
                  as String?,
        department: freezed == department
            ? _value.department
            : department // ignore: cast_nullable_to_non_nullable
                  as String?,
        supervisors: freezed == supervisors
            ? _value._supervisors
            : supervisors // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SupportTicketModelImpl implements _SupportTicketModel {
  const _$SupportTicketModelImpl({
    this.id,
    this.subject,
    @JsonKey(name: 'ticket_code') this.ticketCode,
    this.priority,
    this.statuses,
    @JsonKey(name: 'end_date') this.endDate,
    this.description,
    @JsonKey(name: 'customer_row') this.customerName,
    final List<SupportReplyModel>? replies,
    final List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'created_by') this.createdBy,
    this.category,
    final List<String>? services,
    @JsonKey(name: 'assign_user') this.assignUser,
    this.location,
    this.department,
    final List<String>? supervisors,
  }) : _replies = replies,
       _attachments = attachments,
       _services = services,
       _supervisors = supervisors;

  factory _$SupportTicketModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SupportTicketModelImplFromJson(json);

  @override
  final int? id;
  @override
  final String? subject;
  @override
  @JsonKey(name: 'ticket_code')
  final String? ticketCode;
  @override
  final PriorityModel? priority;
  @override
  final StatusModel? statuses;
  @override
  @JsonKey(name: 'end_date')
  final String? endDate;
  @override
  final String? description;
  @override
  @JsonKey(name: 'customer_row')
  final CustomerModel? customerName;
  final List<SupportReplyModel>? _replies;
  @override
  List<SupportReplyModel>? get replies {
    final value = _replies;
    if (value == null) return null;
    if (_replies is EqualUnmodifiableListView) return _replies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Map<String, dynamic>>? _attachments;
  @override
  List<Map<String, dynamic>>? get attachments {
    final value = _attachments;
    if (value == null) return null;
    if (_attachments is EqualUnmodifiableListView) return _attachments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'created_by')
  final int? createdBy;
  @override
  final String? category;
  final List<String>? _services;
  @override
  List<String>? get services {
    final value = _services;
    if (value == null) return null;
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'assign_user')
  final AssignedUserModel? assignUser;
  @override
  final String? location;
  @override
  final String? department;
  final List<String>? _supervisors;
  @override
  List<String>? get supervisors {
    final value = _supervisors;
    if (value == null) return null;
    if (_supervisors is EqualUnmodifiableListView) return _supervisors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SupportTicketModel(id: $id, subject: $subject, ticketCode: $ticketCode, priority: $priority, statuses: $statuses, endDate: $endDate, description: $description, customerName: $customerName, replies: $replies, attachments: $attachments, createdAt: $createdAt, createdBy: $createdBy, category: $category, services: $services, assignUser: $assignUser, location: $location, department: $department, supervisors: $supervisors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SupportTicketModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.subject, subject) || other.subject == subject) &&
            (identical(other.ticketCode, ticketCode) ||
                other.ticketCode == ticketCode) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.statuses, statuses) ||
                other.statuses == statuses) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            const DeepCollectionEquality().equals(other._replies, _replies) &&
            const DeepCollectionEquality().equals(
              other._attachments,
              _attachments,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.assignUser, assignUser) ||
                other.assignUser == assignUser) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.department, department) ||
                other.department == department) &&
            const DeepCollectionEquality().equals(
              other._supervisors,
              _supervisors,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    subject,
    ticketCode,
    priority,
    statuses,
    endDate,
    description,
    customerName,
    const DeepCollectionEquality().hash(_replies),
    const DeepCollectionEquality().hash(_attachments),
    createdAt,
    createdBy,
    category,
    const DeepCollectionEquality().hash(_services),
    assignUser,
    location,
    department,
    const DeepCollectionEquality().hash(_supervisors),
  );

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SupportTicketModelImplCopyWith<_$SupportTicketModelImpl> get copyWith =>
      __$$SupportTicketModelImplCopyWithImpl<_$SupportTicketModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SupportTicketModelImplToJson(this);
  }
}

abstract class _SupportTicketModel implements SupportTicketModel {
  const factory _SupportTicketModel({
    final int? id,
    final String? subject,
    @JsonKey(name: 'ticket_code') final String? ticketCode,
    final PriorityModel? priority,
    final StatusModel? statuses,
    @JsonKey(name: 'end_date') final String? endDate,
    final String? description,
    @JsonKey(name: 'customer_row') final CustomerModel? customerName,
    final List<SupportReplyModel>? replies,
    final List<Map<String, dynamic>>? attachments,
    @JsonKey(name: 'created_at') final String? createdAt,
    @JsonKey(name: 'created_by') final int? createdBy,
    final String? category,
    final List<String>? services,
    @JsonKey(name: 'assign_user') final AssignedUserModel? assignUser,
    final String? location,
    final String? department,
    final List<String>? supervisors,
  }) = _$SupportTicketModelImpl;

  factory _SupportTicketModel.fromJson(Map<String, dynamic> json) =
      _$SupportTicketModelImpl.fromJson;

  @override
  int? get id;
  @override
  String? get subject;
  @override
  @JsonKey(name: 'ticket_code')
  String? get ticketCode;
  @override
  PriorityModel? get priority;
  @override
  StatusModel? get statuses;
  @override
  @JsonKey(name: 'end_date')
  String? get endDate;
  @override
  String? get description;
  @override
  @JsonKey(name: 'customer_row')
  CustomerModel? get customerName;
  @override
  List<SupportReplyModel>? get replies;
  @override
  List<Map<String, dynamic>>? get attachments;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'created_by')
  int? get createdBy;
  @override
  String? get category;
  @override
  List<String>? get services;
  @override
  @JsonKey(name: 'assign_user')
  AssignedUserModel? get assignUser;
  @override
  String? get location;
  @override
  String? get department;
  @override
  List<String>? get supervisors;

  /// Create a copy of SupportTicketModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SupportTicketModelImplCopyWith<_$SupportTicketModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
