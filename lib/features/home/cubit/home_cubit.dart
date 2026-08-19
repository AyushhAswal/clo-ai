import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void selectTab(int index) {
    if (state.selectedNavIndex != index) {
      emit(state.copyWith(selectedNavIndex: index));
    }
  }
}
