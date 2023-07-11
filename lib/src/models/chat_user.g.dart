// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      id: json['id'] as String,
      name: json['name'] as String,
      profilePhoto: json['profilePhoto'] as String?,
      email: json['email'] as String?,
      domain: json['domain'] as String?,
      statut: $enumDecodeNullable(_$StatutEnumMap, json['statut']),
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profilePhoto': instance.profilePhoto,
      'email': instance.email,
      'domain': instance.domain,
      'statut': _$StatutEnumMap[instance.statut],
    };

const _$StatutEnumMap = {
  Statut.ARCHIVED: 'ARCHIVED',
  Statut.DELETED: 'DELETED',
  Statut.BLOCKED: 'BLOCKED',
};
