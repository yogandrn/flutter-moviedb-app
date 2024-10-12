part of 'tv_bloc.dart';

sealed class TvState extends Equatable {
  const TvState();

  @override
  List<Object> get props => [];
}

final class TvInitializing extends TvState {
  const TvInitializing();
}
