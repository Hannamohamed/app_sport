import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'pass_state.dart';

class PassCubit extends Cubit<PassState> {
  PassCubit() : super(PasswordHidden());

  void toggleVisibility() {
    if (state is PasswordVisible) {
      emit(PasswordHidden());
    } else {
      emit(PasswordVisible());
    }
  }
}
