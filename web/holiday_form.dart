import 'package:polymer/polymer.dart';
import 'dart:html';
import 'models.dart';
import 'dart:convert';


@CustomTag('holiday-form')
class HolidayForm extends PolymerElement {

  @published List<Holiday> collection;

  @observable String title;
  @observable String type;
  @observable String startdate;
  @observable String enddate;
  @observable String description;

  bool get applyAuthorStyles => true;

  var request;

  String url = "http://127.0.0.1:4040/getcount";

  ButtonElement button;

  HolidayForm.created() : super.created(){
    print("Input form created");
   button = $['formular-button'];
  }

  void addHoliday(Event e, var detail, Element target) {
    e.preventDefault();

    button.disabled = true;
    request = new HttpRequest();

    request.onReadyStateChange.listen(onData);
    request.open('POST', url);
    Map map = new Map();
    map["firstDay"] = startdate;
    map["lastDay"] = enddate;

    request.send(JSON.encode(map));;

    //dispatchEvent(new CustomEvent('holiday-input-commit'));
  }



  void onData(ProgressEvent event) {

    if (request.readyState == HttpRequest.DONE &&
        request.status == 201) {
      // Data saved OK.
      var result = JSON.decode(request.responseText);

      Holiday holiday = new Holiday(title,type,DateTime.parse(startdate),DateTime.parse(enddate),description);
      holiday.duration = int.parse(result["takenWorkDays"]);
      collection.add(holiday);
      title = null;
      type = null;
      startdate = null;
      enddate = null;
      description = null;

     // print('Server Sez: ' + request.responseText);
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      // Status is 0...most likely the server isn't running.
      print('No server');
    }
    button.disabled = false;
  }


}