import 'package:polymer/polymer.dart';
import 'models.dart';
import 'package:intl/intl.dart';

@CustomTag('holiday-item')
class HolidayItemElement extends PolymerElement {
 
  var formatter = new DateFormat('yyyy-MM-dd');
  
  
  @observable Holiday item;
  @observable String datestart;
  @observable String dateend;
  bool get applyAuthorStyles => true;

  HolidayItemElement.created():super.created(){
    print("Holiday Element created ");
    
  }
  
  @override
  void enteredView(){
    super.enteredView();
    datestart = formatter.format(item.startdate);
    dateend = formatter.format(item.enddate);
  }


}