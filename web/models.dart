library models;

import 'package:polymer/polymer.dart';

/// The Item class represents an item in the Todo list.
class Holiday extends Object with Observable {
  @observable String title = '';
  @observable String type = '';
  @observable DateTime startdate;
  @observable DateTime enddate;
  @observable String description = '';

  @observable int duration = 0;

  @observable bool done = false; //this will be true if current date is past enddate
 
  
  
  Holiday(this.title, this.type, this.startdate, this.enddate, this.description, {this.duration: 1});

  int getDuration() => duration;
}