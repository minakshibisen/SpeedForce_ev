
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/sevice/image_picker_service.dart';
import 'kyc_event.dart';
import 'kyc_state.dart';
import '../repository/kyc_repository.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final ImagePickerService imagePickerService;
  final KycRepository kycRepository;

  KycBloc({
    required this.imagePickerService,
    required this.kycRepository,
  }) : super(const KycState()) {
    on<PickImageFromCamera>(_onPickImageFromCamera);
    on<PickImageFromGallery>(_onPickImageFromGallery);
    on<PickImageFromFiles>(_onPickImageFromFiles);
    on<RemoveImage>(_onRemoveImage);
    on<SubmitKyc>(_onSubmitKyc);
    on<SkipKyc>(_onSkipKyc);
  }

  Future<void> _onPickImageFromCamera(
      PickImageFromCamera event,
      Emitter<KycState> emit,
      ) async {
    try {
      emit(state.copyWith(status: KycStatus.loading));

      final image = await imagePickerService.pickImageFromCamera();

      if (image != null) {
        emit(state.copyWith(
          status: KycStatus.imageSelected,
          selectedImage: image,
        ));
      } else {
        emit(state.copyWith(status: KycStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPickImageFromGallery(
      PickImageFromGallery event,
      Emitter<KycState> emit,
      ) async {
    try {
      emit(state.copyWith(status: KycStatus.loading));

      final image = await imagePickerService.pickImageFromGallery();

      if (image != null) {
        emit(state.copyWith(
          status: KycStatus.imageSelected,
          selectedImage: image,
        ));
      } else {
        emit(state.copyWith(status: KycStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onPickImageFromFiles(
      PickImageFromFiles event,
      Emitter<KycState> emit,
      ) async {
    try {
      emit(state.copyWith(status: KycStatus.loading));

      final image = await imagePickerService.pickImageFromFiles();

      if (image != null) {
        emit(state.copyWith(
          status: KycStatus.imageSelected,
          selectedImage: image,
        ));
      } else {
        emit(state.copyWith(status: KycStatus.initial));
      }
    } catch (e) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onRemoveImage(
      RemoveImage event,
      Emitter<KycState> emit,
      ) {
    emit(state.copyWith(
      status: KycStatus.initial,
      selectedImage: null,
    ));
  }

  Future<void> _onSubmitKyc(
      SubmitKyc event,
      Emitter<KycState> emit,
      ) async {
    if (state.selectedImage == null) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: 'Please select an image first',
      ));
      return;
    }

    try {
      emit(state.copyWith(status: KycStatus.uploading));

      final success = await kycRepository.uploadKycDocument(state.selectedImage!);

      if (success) {
        emit(state.copyWith(status: KycStatus.success));
      } else {
        emit(state.copyWith(
          status: KycStatus.error,
          errorMessage: 'Upload failed',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSkipKyc(
      SkipKyc event,
      Emitter<KycState> emit,
      ) async {
    try {
      await kycRepository.skipKyc();
      emit(state.copyWith(status: KycStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: KycStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}



