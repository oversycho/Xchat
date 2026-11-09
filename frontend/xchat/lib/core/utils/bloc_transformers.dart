import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

/// Waits for [duration] of silence, then handles only the latest event.
EventTransformer<E> debounced<E>(Duration duration) =>
    (events, mapper) => events.debounce(duration).switchMap(mapper);
