import 'package:flutter_bloc/flutter_bloc.dart';
import 'ai_state.dart';

class AICubit extends Cubit<AIState> {
  AICubit() : super(const AIState());

  void selectControl(int index) {
    if (state.activeControlIndex != index) {
      emit(state.copyWith(activeControlIndex: index));
    }
  }
}
