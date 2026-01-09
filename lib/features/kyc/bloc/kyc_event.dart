
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class KycEvent extends Equatable {
  const KycEvent();

  @override
  List<Object?> get props => [];
}

class PickImageFromCamera extends KycEvent {
  const PickImageFromCamera();
}

class PickImageFromGallery extends KycEvent {
  const PickImageFromGallery();
}

class PickImageFromFiles extends KycEvent {
  const PickImageFromFiles();
}

class RemoveImage extends KycEvent {
  const RemoveImage();
}

class SubmitKyc extends KycEvent {
  const SubmitKyc();
}

class SkipKyc extends KycEvent {
  const SkipKyc();
}
