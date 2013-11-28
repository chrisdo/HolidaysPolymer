import 'package:polymer/polymer.dart';
import 'dart:html';
import 'models.dart';
import 'dart:convert';


@CustomTag('holiday-form')
class HolidayForm extends PolymerElement {

  Element background;
  Element content;

  @published List<Holiday> collection;

  @observable int selected = 1; // Make sure this is not null.

  @observable String title;
  @observable String type = 'relaxation';
  @observable String startdate;
  @observable String enddate;
  @observable String description;

  bool get applyAuthorStyles => true;

  var request;

  String url = "http://127.0.0.1:4040/getcount";

  ButtonElement button;

  List<String> types = ['doctor','relaxation','holiday', 'kids', 'lazyness'];

  HolidayForm.created() : super.created(){
    print("Input form created");
   button = $['formular-button'];
  }

  void cancel(Event e, var detail, Element target){
    e.preventDefault();
    hide();
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
    hide();
  }

  @override
  void enteredView(){
    super.enteredView();
    background = $["dialogbackground"];
    content = $["dialogcontent"];
    hide();
  }

  void show() {
    background.style.display = 'block';
    content.style.display = 'block';
  }


  void hide() {
    background.style.display = 'none';
    content.style.display = 'none';
  }



}