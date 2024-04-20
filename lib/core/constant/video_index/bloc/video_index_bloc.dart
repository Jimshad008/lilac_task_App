import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'video_index_event.dart';
part 'video_index_state.dart';

class VideoIndexBloc extends Bloc<VideoIndexEvent, int> {
  VideoIndexBloc() : super(0) {
    on<ChangeIndex>((event, emit) {
      emit(event.index);
    });
  }
}
