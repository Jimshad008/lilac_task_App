import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/usecase/fetch_video.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchVideo _fetchVideo;
  HomeBloc({required FetchVideo fetchVideo}):_fetchVideo=fetchVideo,super(HomeInitial()) {
    on<HomeFetchVideo>((event, emit) async {
      emit(HomeLoading());
      final res=await _fetchVideo.homeRepository.fetchVideo();
      res.fold(
              (l) => emit(HomeFailure( l.message)),
      (uid) => emit(HomeSuccess( uid)));
    });
  }
}
