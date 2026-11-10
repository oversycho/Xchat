import 'package:equatable/equatable.dart';

enum AttachmentKind { image, video, audio, voice, videoNote, document, sticker, gif }

/// Reference to an already-uploaded file in a private storage bucket.
final class Attachment extends Equatable {
  const Attachment({
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
  final AttachmentKind kind;
  final String storagePath;
  final String mimeType;
  final int sizeBytes;
  final int? width;
  final int? height;
  final int? durationMs;

  @override
  List<Object?> get props => [
    id,
    kind,
    storagePath,
    mimeType,
    sizeBytes,
    width,
    height,
    durationMs,
  ];
}
