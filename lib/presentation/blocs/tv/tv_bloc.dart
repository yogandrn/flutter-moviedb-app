import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_event.dart';
part 'tv_state.dart';

class TvBloc extends Bloc<TvEvent, TvState> {
  TvBloc() : super(const TvInitializing()) {
    on<TvEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
