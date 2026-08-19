import 'package:flutter_bloc/flutter_bloc.dart';
import 'ai_state.dart';

class AICubit extends Cubit<AIState> {
  AICubit({
    String personName = 'Ayush',
    String relationshipType = 'Professional',
  }) : super(AIState(relationshipName: personName, category: relationshipType));

  void selectControl(int index) {
    if (state.activeControlIndex != index) {
      emit(state.copyWith(activeControlIndex: index));
    }
  }
}
