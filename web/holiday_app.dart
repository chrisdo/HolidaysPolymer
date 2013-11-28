library holiday;

import 'package:polymer/polymer.dart';
import 'models.dart';
import 'dart:async';
import 'dart:html';
import 'holiday_form.dart';
import 'holiday_item.dart';

@CustomTag('holiday-app')
class HolidayApp extends PolymerElement {

  final ObservableList<Holiday> holidayItems = toObservable([]);

  bool get applyAuthorStyles => true;
  @observable int remainingCount;
  @observable int maxDays = 30;
  @observable int usedDays = 0;


  HolidayForm addHolidayDialog;
  Element addholidaybutton;

  HolidayApp.created() : super.created() {
    // Need to check if the items list gets added to or has something removed.
    holidayItems.changes.listen((records) {
       print('Item added');
      usedDays = _usedDays;
    });

    new ListPathObserver(holidayItems, 'done')
    ..changes.listen((_) {
      remainingCount = _remainingCount;
    });



  }

  @override
  void enteredView(){
    super.enteredView();
    addHolidayDialog = $['holiday-formular'];
    addholidaybutton = document.querySelector('#addholidaybutton');
    addholidaybutton.onClick.listen(toggleDialog);
    print(addholidaybutton.id);

  }

  int get _remainingCount => holidayItems.where((i) => !i.done).length; //overwrite getter of remainingCount by using 'get' keyword

  int get _usedDays{
    int ctr = 0;
    for (Holiday item in holidayItems){
      ctr += item.duration;
    }
    return ctr;
  }

  /**
   * would be called on creation, load existing holidays from local storage (or remote or whatever)
   */
  _init(){

  }


  void removeItem(Event e, var detail, Element target){

  }

  void toggleDialog(MouseEvent event) {
    print('Clicked');
    addHolidayDialog.show();
  }
}