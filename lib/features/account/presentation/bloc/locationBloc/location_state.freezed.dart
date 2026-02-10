// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MyLocationState {
  List<LocationModel> get locations => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;
  Map<String, dynamic> get editLocation => throw _privateConstructorUsedError;
  Map<String, dynamic> get addLocations => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MyLocationStateCopyWith<MyLocationState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MyLocationStateCopyWith<$Res> {
  factory $MyLocationStateCopyWith(
          MyLocationState value, $Res Function(MyLocationState) then) =
      _$MyLocationStateCopyWithImpl<$Res, MyLocationState>;
  @useResult
  $Res call(
      {List<LocationModel> locations,
      Status status,
      Map<String, dynamic> editLocation,
      Map<String, dynamic> addLocations,
      String? errorMessage});
}

/// @nodoc
class _$MyLocationStateCopyWithImpl<$Res, $Val extends MyLocationState>
    implements $MyLocationStateCopyWith<$Res> {
  _$MyLocationStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = null,
    Object? status = null,
    Object? editLocation = null,
    Object? addLocations = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      locations: null == locations
          ? _value.locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      editLocation: null == editLocation
          ? _value.editLocation
          : editLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      addLocations: null == addLocations
          ? _value.addLocations
          : addLocations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MyLocationStateImplCopyWith<$Res>
    implements $MyLocationStateCopyWith<$Res> {
  factory _$$MyLocationStateImplCopyWith(_$MyLocationStateImpl value,
          $Res Function(_$MyLocationStateImpl) then) =
      __$$MyLocationStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<LocationModel> locations,
      Status status,
      Map<String, dynamic> editLocation,
      Map<String, dynamic> addLocations,
      String? errorMessage});
}

/// @nodoc
class __$$MyLocationStateImplCopyWithImpl<$Res>
    extends _$MyLocationStateCopyWithImpl<$Res, _$MyLocationStateImpl>
    implements _$$MyLocationStateImplCopyWith<$Res> {
  __$$MyLocationStateImplCopyWithImpl(
      _$MyLocationStateImpl _value, $Res Function(_$MyLocationStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locations = null,
    Object? status = null,
    Object? editLocation = null,
    Object? addLocations = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$MyLocationStateImpl(
      locations: null == locations
          ? _value._locations
          : locations // ignore: cast_nullable_to_non_nullable
              as List<LocationModel>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
      editLocation: null == editLocation
          ? _value._editLocation
          : editLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      addLocations: null == addLocations
          ? _value._addLocations
          : addLocations // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$MyLocationStateImpl implements _MyLocationState {
  const _$MyLocationStateImpl(
      {required final List<LocationModel> locations,
      required this.status,
      required final Map<String, dynamic> editLocation,
      required final Map<String, dynamic> addLocations,
      this.errorMessage})
      : _locations = locations,
        _editLocation = editLocation,
        _addLocations = addLocations;

  final List<LocationModel> _locations;
  @override
  List<LocationModel> get locations {
    if (_locations is EqualUnmodifiableListView) return _locations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_locations);
  }

  @override
  final Status status;
  final Map<String, dynamic> _editLocation;
  @override
  Map<String, dynamic> get editLocation {
    if (_editLocation is EqualUnmodifiableMapView) return _editLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_editLocation);
  }

  final Map<String, dynamic> _addLocations;
  @override
  Map<String, dynamic> get addLocations {
    if (_addLocations is EqualUnmodifiableMapView) return _addLocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_addLocations);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'MyLocationState(locations: $locations, status: $status, editLocation: $editLocation, addLocations: $addLocations, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MyLocationStateImpl &&
            const DeepCollectionEquality()
                .equals(other._locations, _locations) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality()
                .equals(other._editLocation, _editLocation) &&
            const DeepCollectionEquality()
                .equals(other._addLocations, _addLocations) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_locations),
      status,
      const DeepCollectionEquality().hash(_editLocation),
      const DeepCollectionEquality().hash(_addLocations),
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MyLocationStateImplCopyWith<_$MyLocationStateImpl> get copyWith =>
      __$$MyLocationStateImplCopyWithImpl<_$MyLocationStateImpl>(
          this, _$identity);
}

abstract class _MyLocationState implements MyLocationState {
  const factory _MyLocationState(
      {required final List<LocationModel> locations,
      required final Status status,
      required final Map<String, dynamic> editLocation,
      required final Map<String, dynamic> addLocations,
      final String? errorMessage}) = _$MyLocationStateImpl;

  @override
  List<LocationModel> get locations;
  @override
  Status get status;
  @override
  Map<String, dynamic> get editLocation;
  @override
  Map<String, dynamic> get addLocations;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$MyLocationStateImplCopyWith<_$MyLocationStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
