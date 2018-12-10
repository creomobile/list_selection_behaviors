import 'dart:async';
import 'package:observable/observable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sample_app/models.dart';

class SampleListBloc {
  final _addingBehavior = BehaviorSubject<bool>(seedValue: true);

  Stream<bool> get isAdding => _addingBehavior.stream;
  StreamSink<bool> get adding => _addingBehavior.sink;
  get currentIsAdding => _addingBehavior.value;

  final items = ObservableList.from(_createInitial());
  static Iterable<User> _createInitial() =>
      Iterable.generate(5).map((_) => User.create());

  void insertUser() => items.insert(items.length, User.create());
  void insertCompany() => items.insert(items.length, Company.create());
  void insertSeparator() => items.insert(items.length, Separator());

  void remove(Object item) => items.remove(item);

  void clear() => items.clear();
  void refresh() {
    clear();
    items.addAll(_createInitial());
  }

  void dispose() => _addingBehavior.close();
}
