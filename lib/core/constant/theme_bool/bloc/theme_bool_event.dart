part of 'theme_bool_bloc.dart';

@immutable
sealed class ThemeBoolEvent {}
final class ThemeBoolChange extends ThemeBoolEvent{
  final bool theme;
  ThemeBoolChange({required this.theme  });
}
