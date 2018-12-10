import 'package:flutter/material.dart';
import 'package:observable/observable.dart';

class ListHelper {
  static AnimatedList createAnimatedObserverList<I>(
      ObservableList<I> list, Widget itemBuilder(I item)) {
    final GlobalKey<AnimatedListState> key = GlobalKey();

    list.listChanges.listen((List<ListChangeRecord<I>> changes) {
      changes.forEach((change) {
        int index = change.index + change.removed.length - 1;
        for (var removed in change.removed.reversed) {
          //key.currentState.
          key.currentState.removeItem(index--,
              (BuildContext context, Animation<double> animation) {
            return FadeTransition(
              opacity:
                  CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
              child: SizeTransition(
                  sizeFactor:
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  axisAlignment: 0.0,
                  child: itemBuilder(removed)),
            );
          }, duration: Duration(milliseconds: 200));
        }
        for (var i = change.index; i < change.index + change.addedCount; i++)
          key.currentState.insertItem(i, duration: Duration(milliseconds: 200));
      });
    });

    return AnimatedList(
        key: key,
        initialItemCount: list.length,
        itemBuilder: (BuildContext context, int index, Animation animation) {
          var item = list[index];
          return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
              child: SizeTransition(
                  sizeFactor:
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                  child: itemBuilder(item)));
        });
  }
}
