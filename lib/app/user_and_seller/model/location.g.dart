// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location1 _$Location1FromJson(Map<String, dynamic> json) => Location1(
      street: json['street'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      coordinates:
          Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
      timezone: Timezone.fromJson(json['timezone'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$Location1ToJson(Location1 instance) => <String, dynamic>{
      'street': instance.street,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'coordinates': instance.coordinates,
      'timezone': instance.timezone,
    };
