
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String FullName;
  final String Email;
  final String phoneNumber;
  final Timestamp lastSeen;
  final Timestamp createdAt;
  final String fcmToken;
  final List<String> blockedUsers;
  final bool isOnline;

  UserModel({
    required this.uid,
    required this.username,
    required this.FullName,
    required this.Email,
    this.isOnline = false,
    required this.phoneNumber,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    required this.fcmToken,
    this.blockedUsers = const [],
  })  : lastSeen = lastSeen ?? Timestamp.now(),
        createdAt = createdAt ?? Timestamp.now();

  UserModel copyWith({
    String? uid,
    String? username,
    String? FullName,
    String? Email,
    String? phoneNumber,
    Timestamp? lastSeen,
    Timestamp? createdAt,
    String? fcmToken,
    List<String>? blockedUsers,
    bool? isOnline,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      FullName: FullName ?? this.FullName,
      Email: Email ?? this.Email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      fcmToken: fcmToken ?? this.fcmToken,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      FullName: data['FullName'] ?? '',
      Email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      lastSeen: data['lastseen'] ?? Timestamp.now(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      fcmToken: data['fcmToken'] ?? '',
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      isOnline: data['isOnline'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': Email,
      'FullName': FullName,
      'phoneNumber': phoneNumber,
      'lastseen': lastSeen,
      'createdAt': createdAt,
      'fcmToken': fcmToken,
      'blockedUsers': blockedUsers,
      'isOnline': isOnline,
    };
  }
}
