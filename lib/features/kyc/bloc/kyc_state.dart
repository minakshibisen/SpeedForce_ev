import 'package:equatable/equatable.dart';
import 'dart:io';

enum KycStatus { initial, loading, imageSelected, uploading, success, error }

class KycState extends Equatable {
  final KycStatus status;
  final File? selectedImage;
  final String? errorMessage;
  final double uploadProgress;

  const KycState({
    this.status = KycStatus.initial,
    this.selectedImage,
    this.errorMessage,
    this.uploadProgress = 0.0,
  });

  KycState copyWith({
    KycStatus? status,
    File? selectedImage,
    String? errorMessage,
    double? uploadProgress,
  }) {
    return KycState(
      status: status ?? this.status,
      selectedImage: selectedImage,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [status, selectedImage, errorMessage, uploadProgress];
}