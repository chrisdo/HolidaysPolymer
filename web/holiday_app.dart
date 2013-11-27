library holiday;

import 'package:polymer/polymer.dart';
import 'models.dart';
import 'dart:async';
import 'dart:html';

@CustomTag('holiday-app')
class HolidayApp extends PolymerElement {

  final ObservableList<Holiday> holidayItems = toObservable([new Holiday('a title', 'a type', new DateTime.now(), new DateTime.now(), 'some description')]);

  bool get applyAuthorStyles => true;
  @observable int remainingCount;


  HolidayApp.created() : super.created() {
    // Need to check if the items list gets added to or has something removed.
    holidayItems.changes.listen((records) {
       print('Item added');
    });

    new ListPathObserver(holidayItems, 'done')
    ..changes.listen((_) {
      remainingCount = _remainingCount;
    });
    
  }

  int get _remainingCount => holidayItems.where((i) => !i.done).length; //overwrite getter of remainingCount by using 'get' keyword
  
  /**
   * would be called on creation, load existing holidays from local storage (or remote or whatever)
   */
  _init(){
    
  }
  
  
  void test(Event e, var detail, Element target){
    print('item clicked');
  }
}