/// Result of validating a package ID + client ID + license key, as returned
/// by the Android Label SDK.
class LicenseResult {
  const LicenseResult({
    required this.isValid,
    this.reason,
    this.clientName,
    this.clientId,
    this.expiresAt,
  });

  /// Builds a result from the map sent over the MethodChannel.
  factory LicenseResult.fromMap(Map<Object?, Object?> map) {
    final expires = map['expiresAt'] as String?;
    return LicenseResult(
      isValid: map['isValid'] == true,
      reason: map['reason'] as String?,
      clientName: map['clientName'] as String?,
      clientId: map['clientId'] as String?,
      expiresAt: expires == null ? null : DateTime.tryParse(expires),
    );
  }

  /// `true` when the backend accepted the package ID, client ID and key.
  final bool isValid;

  /// Why validation failed, when [isValid] is `false`. One of
  /// `invalid_credentials`, `revoked`, `expired`, `app_not_allowed`,
  /// `not_configured`, `network_error`, `server_error`.
  final String? reason;

  /// The client name registered for this license.
  final String? clientName;

  /// The client ID this license belongs to.
  final String? clientId;

  /// When the license expires, or `null` if it never does.
  final DateTime? expiresAt;

  @override
  String toString() => isValid
      ? 'LicenseResult(valid, client: $clientName ($clientId), expiresAt: $expiresAt)'
      : 'LicenseResult(invalid, reason: $reason)';
}

/// Thrown by [LabelFlutterPlugin.getLabel] when the license has not been
/// initialized or is not valid.
class LabelLicenseException implements Exception {
  const LabelLicenseException(this.reason);

  /// `not_initialized`, or the [LicenseResult.reason] of the failed check.
  final String reason;

  @override
  String toString() => 'LabelLicenseException: $reason';
}
