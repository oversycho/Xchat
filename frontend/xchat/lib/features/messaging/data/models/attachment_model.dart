final class AttachmentModel {
  const AttachmentModel({
    required this.id,
    required this.kind,
    required this.storagePath,
    required this.mimeType,
    required this.sizeBytes,
    this.width,
    this.height,
    this.durationMs,
  });

  final String id;
  final String kind;
  final String storagePath;
  final String mimeType;
  final int sizeBytes;
  final int? width;
  final int? height;
  final int? durationMs;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) => AttachmentModel(
    id: json['id'] as String,
    kind: json['kind'] as String,
    storagePath: json['storage_path'] as String,
    mimeType: json['mime_type'] as String,
    sizeBytes: (json['size_bytes'] as num).toInt(),
    width: (json['width'] as num?)?.toInt(),
    height: (json['height'] as num?)?.toInt(),
    durationMs: (json['duration_ms'] as num?)?.toInt(),
  );

  Map<String, dynamic> toJson({String? messageId}) => {
    'id': id,
    if (messageId != null) 'message_id': messageId,
    'kind': kind,
    'storage_path': storagePath,
    'mime_type': mimeType,
    'size_bytes': sizeBytes,
    'width': width,
    'height': height,
    'duration_ms': durationMs,
  };
}
