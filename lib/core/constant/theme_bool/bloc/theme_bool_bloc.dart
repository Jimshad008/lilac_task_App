import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'theme_bool_event.dart';
part 'theme_bool_state.dart';

class ThemeBoolBloc extends Bloc<ThemeBoolEvent, bool> {
  ThemeBoolBloc() : super(false) {
    on<ThemeBoolChange>((event, emit) {
     emit(event.theme);
    });
  }
}
