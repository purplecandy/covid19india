import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
export 'package:rxdart/transformers.dart';

class Event<S, T> {
  final S state;
  final T object;
  Event(this.state, this.object);
}

abstract class BlocBase<S, A, T> {
  BehaviorSubject<Event<S, T>> _controller;

  BlocBase({S state, T object}) {
    _controller =
        BehaviorSubject<Event<S, T>>.seeded(initialState(state, object));
  }

  BehaviorSubject<Event<S, T>> get controller => _controller;
  Stream<Event<S, T>> get stream => _controller.stream;
  Event<S, T> get event => _controller.value;

  void updateState(S state, T data) {
    _controller.add(Event<S, T>(state, data));
  }

  Event<S, T> initialState(S state, T object) => Event<S, T>(state, object);

  void dispose() {
    _controller.close();
  }

  void dispatch(A actionState, [Map<String, dynamic> data]);
}

typedef Widget SnapshopBuilder<A, K>(BuildContext context, Event<A, K> event);
typedef Widget ErrorBuilder(BuildContext context, Exception error);

class BlocBuilder<A, K, T extends BlocBase> extends StatelessWidget {
  final SnapshopBuilder<A, K> onSuccess;
  final ErrorBuilder onError;
  final T bloc;
  const BlocBuilder({Key key, this.onSuccess, this.onError, this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Event<A, K>>(
      stream: bloc.stream,
      initialData: bloc.event,
      builder: (context, snap) => snap.hasError
          ? onError(context, snap.error)
          : onSuccess(context, snap.data),
    );
  }
}
