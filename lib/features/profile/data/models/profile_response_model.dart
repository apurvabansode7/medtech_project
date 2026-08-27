class ProfileResponse {
  final bool success;
  final ProfileData data;

  ProfileResponse({
    required this.success,
    required this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      success: json['success'] ?? false,
      data: ProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class ProfileData {
  final String id;
  final String referenceId;
  final String type;
  final String businessName;
  final String ownerName;
  final String? profileImage;
  final String gstNumber;
  final String? regionId;
  final String? assignedMedicalRepresentativeId;

  final Region? region;
  final MedicalRepresentative? assignedMedicalRepresentative;

  final String email;
  final String phone;
  final String country;

  final bool isEmailVerified;
  final bool isPhoneVerified;

  final String status;
  final String approvalStatus;
  final String? approvalReason;

  final bool isBlocked;
  final bool mustChangePassword;
  final bool isOnboarded;

  final DateTime? lastLoginAt;

  final String? walletId;
  final num availableBalance;
  final num totalPointsEarned;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final List<Business> business;

  ProfileData({
    required this.id,
    required this.referenceId,
    required this.type,
    required this.businessName,
    required this.ownerName,
    this.profileImage,
    required this.gstNumber,
    this.regionId,
    this.assignedMedicalRepresentativeId,
    this.region,
    this.assignedMedicalRepresentative,
    required this.email,
    required this.phone,
    required this.country,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.status,
    required this.approvalStatus,
    this.approvalReason,
    required this.isBlocked,
    required this.mustChangePassword,
    required this.isOnboarded,
    this.lastLoginAt,
    this.walletId,
    required this.availableBalance,
    required this.totalPointsEarned,
    this.createdAt,
    this.updatedAt,
    required this.business,
  });

  // factory ProfileData.fromJson(Map<String, dynamic> json) {
  //   return ProfileData(
  //     id: json['id'] ?? '',
  //     referenceId: json['referenceId'] ?? '',
  //     type: json['type'] ?? '',
  //     businessName: json['businessName'] ?? '',
  //     ownerName: json['ownerName'] ?? '',
  //     profileImage: json['profileImage'],
  //     gstNumber: json['gstNumber'] ?? '',
  //     regionId: json['regionId'],
  //     assignedMedicalRepresentativeId:
  //         json['assignedMedicalRepresentativeId'],
  //     region:
  //         json['region'] != null
  //             ? Region.fromJson(json['region'])
  //             : null,
  //     assignedMedicalRepresentative:
  //         json['assignedMedicalRepresentative'] != null
  //             ? MedicalRepresentative.fromJson(
  //               json['assignedMedicalRepresentative'],
  //             )
  //             : null,
  //     email: json['email'] ?? '',
  //     phone: json['phone'] ?? '',
  //     country: json['country'] ?? '',
  //     isEmailVerified: json['isEmailVerified'] ?? false,
  //     isPhoneVerified: json['isPhoneVerified'] ?? false,
  //     status: json['status'] ?? '',
  //     approvalStatus: json['approvalStatus'] ?? '',
  //     approvalReason: json['approvalReason'],
  //     isBlocked: json['isBlocked'] ?? false,
  //     mustChangePassword: json['mustChangePassword'] ?? false,
  //     isOnboarded: json['isOnboarded'] ?? false,
  //     lastLoginAt:
  //         json['lastLoginAt'] != null
  //             ? DateTime.tryParse(json['lastLoginAt'])
  //             : null,
  //     walletId: json['walletId'],
  //     availableBalance: json['availableBalance'] ?? 0,
  //     totalPointsEarned: json['totalPointsEarned'] ?? 0,
  //     createdAt:
  //         json['createdAt'] != null
  //             ? DateTime.tryParse(json['createdAt'])
  //             : null,
  //     updatedAt:
  //         json['updatedAt'] != null
  //             ? DateTime.tryParse(json['updatedAt'])
  //             : null,
  //     business:
  //         (json['business'] as List<dynamic>?)
  //             ?.map((e) => Business.fromJson(e))
  //             .toList() ??
  //         [],
  //   );
  // }
  factory ProfileData.fromJson(Map<String, dynamic> json) {
  print('PROFILE JSON: $json');

  print('id: ${json['id']} -> ${json['id'].runtimeType}');
  print('referenceId: ${json['referenceId']} -> ${json['referenceId'].runtimeType}');
  print('businessName: ${json['businessName']} -> ${json['businessName'].runtimeType}');
  print('ownerName: ${json['ownerName']} -> ${json['ownerName'].runtimeType}');
  print('profileImage: ${json['profileImage']} -> ${json['profileImage'].runtimeType}');
  print('gstNumber: ${json['gstNumber']} -> ${json['gstNumber'].runtimeType}');
  print('region: ${json['region']} -> ${json['region'].runtimeType}');
  print(
    'assignedMedicalRepresentative: '
    '${json['assignedMedicalRepresentative']} -> '
    '${json['assignedMedicalRepresentative'].runtimeType}',
  );
  print('business: ${json['business']} -> ${json['business'].runtimeType}');

  return ProfileData(
    id: json['id']?.toString() ?? '',
    referenceId: json['referenceId']?.toString() ?? '',
    type: json['type']?.toString() ?? '',
    businessName: json['businessName']?.toString() ?? '',
    ownerName: json['ownerName']?.toString() ?? '',

    profileImage:
        json['profileImage'] is Map
            ? json['profileImage']['url']?.toString()
            : json['profileImage']?.toString(),

    gstNumber: json['gstNumber']?.toString() ?? '',

    regionId: json['regionId']?.toString(),

    assignedMedicalRepresentativeId:
        json['assignedMedicalRepresentativeId']?.toString(),

    region:
        json['region'] is Map<String, dynamic>
            ? Region.fromJson(json['region'])
            : null,

    assignedMedicalRepresentative:
        json['assignedMedicalRepresentative'] is Map<String, dynamic>
            ? MedicalRepresentative.fromJson(
              json['assignedMedicalRepresentative'],
            )
            : null,

    email: json['email']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    country: json['country']?.toString() ?? '',

    isEmailVerified: json['isEmailVerified'] == true,
    isPhoneVerified: json['isPhoneVerified'] == true,

    status: json['status']?.toString() ?? '',
    approvalStatus: json['approvalStatus']?.toString() ?? '',
    approvalReason: json['approvalReason']?.toString(),

    isBlocked: json['isBlocked'] == true,
    mustChangePassword: json['mustChangePassword'] == true,
    isOnboarded: json['isOnboarded'] == true,

    lastLoginAt:
        json['lastLoginAt'] != null
            ? DateTime.tryParse(json['lastLoginAt'].toString())
            : null,

    walletId: json['walletId']?.toString(),

    availableBalance:
        json['availableBalance'] is num
            ? json['availableBalance']
            : num.tryParse(json['availableBalance']?.toString() ?? '') ?? 0,

    totalPointsEarned:
        json['totalPointsEarned'] is num
            ? json['totalPointsEarned']
            : num.tryParse(json['totalPointsEarned']?.toString() ?? '') ?? 0,

    createdAt:
        json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,

    updatedAt:
        json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,

    business:
        json['business'] is List
            ? (json['business'] as List)
                .whereType<Map<String, dynamic>>()
                .map((e) => Business.fromJson(e))
                .toList()
            : [],
  );
}
}

class Region {
  final String id;
  final String code;
  final String name;
  final bool isActive;

  Region({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });

  factory Region.fromJson(Map<String, dynamic> json) {
    return Region(
      id: json['id'] ?? '',
      code: json['code'] ?? '',
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}class MedicalRepresentative {
  final String id;
  final String referenceId;
  final String employeeCode;
  final String email;
  final String country;
  final String phone;
  final String fullName;
  final String note;
  final String profileImageUrl;
  final String status;

  final int dealerCount;
  final int chemistCount;

  final bool isEmailVerified;
  final bool isPhoneVerified;
  final bool isBlocked;

  final String blockedReason;

  MedicalRepresentative({
    required this.id,
    required this.referenceId,
    required this.employeeCode,
    required this.email,
    required this.country,
    required this.phone,
    required this.fullName,
    required this.note,
    required this.profileImageUrl,
    required this.status,
    required this.dealerCount,
    required this.chemistCount,
    required this.isEmailVerified,
    required this.isPhoneVerified,
    required this.isBlocked,
    required this.blockedReason,
  });

  factory MedicalRepresentative.fromJson(
    Map<String, dynamic> json,
  ) {
    return MedicalRepresentative(
      id: json['id'] ?? '',
      referenceId: json['referenceId'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      email: json['email'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'] ?? '',
      fullName: json['fullName'] ?? '',
      note: json['note'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      status: json['status'] ?? '',
      dealerCount: json['dealerCount'] ?? 0,
      chemistCount: json['chemistCount'] ?? 0,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPhoneVerified: json['isPhoneVerified'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      blockedReason: json['blockedReason'] ?? '',
    );
  }
}class Business {
  final String id;
  final String partnerId;
  final String outletName;
  final String approvalStatus;
  final String userName;
  final String panNumber;
  final String drugLicenseNumber;
  final DateTime? drugLicenseExpiry;

  final String addressType;
  final String addressLine1;
  final String addressLine2;
  final String landmark;
  final String city;
  final String district;
  final String state;
  final String country;
  final String pincode;

  final double latitude;
  final double longitude;

  final double geoAccuracy;
  final double scanRadius;
  final double bufferRadius;

  final String? geoTagImage;
  final String? regionId;
  final String notes;

  final List<dynamic> documents;

  Business({
    required this.id,
    required this.partnerId,
    required this.outletName,
    required this.approvalStatus,
    required this.userName,
    required this.panNumber,
    required this.drugLicenseNumber,
    this.drugLicenseExpiry,
    required this.addressType,
    required this.addressLine1,
    required this.addressLine2,
    required this.landmark,
    required this.city,
    required this.district,
    required this.state,
    required this.country,
    required this.pincode,
    required this.latitude,
    required this.longitude,
    required this.geoAccuracy,
    required this.scanRadius,
    required this.bufferRadius,
    this.geoTagImage,
    this.regionId,
    required this.notes,
    required this.documents,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      partnerId: json['partnerId'] ?? '',
      outletName: json['outletName'] ?? '',
      approvalStatus: json['approvalStatus'] ?? '',
      userName: json['userName'] ?? '',
      panNumber: json['panNumber'] ?? '',
      drugLicenseNumber: json['drugLicenseNumber'] ?? '',
      drugLicenseExpiry:
          json['drugLicenseExpiry'] != null
              ? DateTime.tryParse(json['drugLicenseExpiry'])
              : null,
      addressType: json['addressType'] ?? '',
      addressLine1: json['addressLine1'] ?? '',
      addressLine2: json['addressLine2'] ?? '',
      landmark: json['landmark'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pincode: json['pincode'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      geoAccuracy: (json['geoAccuracy'] ?? 0).toDouble(),
      scanRadius: (json['scanRadius'] ?? 0).toDouble(),
      bufferRadius: (json['bufferRadius'] ?? 0).toDouble(),
      geoTagImage: json['geoTagImage'],
      regionId: json['regionId'],
      notes: json['notes'] ?? '',
      documents: json['documents'] ?? [],
    );
  }
}