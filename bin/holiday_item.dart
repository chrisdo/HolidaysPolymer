class HolidayItem{
  
  String name;
  int month;
  int day;
  int year;
  
  bool yearly = false; //if yearly event, then year does not matter.
  
  HolidayItem(String name, int month, int day, int year){
    if (year == -1){
      yearly = true;
    }
    this.name = name;
    this.day = day;
    this.month = month;
  }
}