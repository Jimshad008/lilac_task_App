part of 'video_index_bloc.dart';

@immutable
sealed class VideoIndexEvent {}
final class ChangeIndex extends VideoIndexEvent{
  final int index;
  ChangeIndex({required this.index});

}