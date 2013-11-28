import 'dart:io';
import 'package:http_server/http_server.dart';
import 'dart:convert';
import 'holiday_item.dart';

List<DateTime> holidays = [];


void replyWithNumberOfHolidays(HttpRequest req) {

  HttpBodyHandler.processRequest(req).then((HttpBody body ){
    req.response.headers.add('Access-Control-Allow-Origin', '*');
    req.response.headers.add('Contet-Type', 'text/plain');
 print(body.type);
    print(body.body.toString());
    Map data = JSON.decode(body.body );
    if(data["firstDay"] == null || data["lastDay"] == null){
      req.response.statusCode = 400;
      req.response.close();
    }
    else{
    int days = calculateTakenWorkDays(data["firstDay"],data["lastDay"]);
    print(days);

    req.response.statusCode = 201;
    String jsonData = '{"takenWorkDays":"${days}"}';
    req.response.write(jsonData);
    req.response.close();
    }
  });

}

int calculateTakenWorkDays(String startDay, String endDay){
  DateTime start = DateTime.parse(startDay);
  DateTime end = DateTime.parse(endDay);
  int counter = 0;

  DateTime step = start;

  while(!step.isAfter(end)){
   //print(step.weekday);
    if(!holidays.contains(step) && step.weekday != DateTime.SUNDAY && step.weekday != DateTime.SATURDAY){
      counter +=1;
    }
    step = step.add(new Duration(days:1));
  }
  return counter;
}

readIcsFile(){
var polandIcsFile = new File('PolishHolidays.ics');


  polandIcsFile.readAsLines().then((List<String> lines){
    List<String> event = new List();
  bool insideEvent = false;
    for(String line in lines){
      if(!insideEvent){
        event.clear();
      }
      else{
          event.add(line);

      }
      if(line.startsWith("BEGIN:VEVENT")){
        insideEvent = true;
        event.add(line);
      }
      if(line.startsWith("END:VEVENT")){
        event.add(line);
        readIcsEvent(event);
        insideEvent = false;
        event.clear();

     }


      //if(line.startsWith("DTSTART;VALUE")){
      //  DateTime t = DateTime.parse(line.substring(line.length-8));
      //  print(t);
      //  holidays.add(t);
      //}
    }
    print('The entire file has ${lines.length} elements');
    print('Holidays has ${holidays.length} entries');
  });
}

readIcsEvent(List<String> lines){
  bool yearly = false;
DateTime t = null;
String summary = '';
  for (String line in lines){
    if (line.contains("YEARLY")){
      yearly = true;
    }
    if(line.startsWith("DTSTART;VALUE")){
     t = DateTime.parse(line.substring(line.length-8));
      print(t);

      //holidays.add(t);
    }
    if(line.startsWith("SUMMARY")){
      summary = line.substring(9);
    }


  }
  if(t != null){
    print("Is Yearly ${yearly}");
    int year = 2010;
   while (year <= 2025){
     holidays.add(new DateTime(year, t.month, t.day));
     year++;

   }


  }

}

main(){
  readIcsFile();

  HttpServer.bind('0.0.0.0', 4040).then((HttpServer server){
    print('Server is running');
    server.listen((HttpRequest req){
      if (req.uri.path == '/submit' && req.method == 'POST'){
        //echo(req);
      }
      else if (req.uri.path == '/getcount' && req.method == 'POST'){
        print('received Request ${req.uri.path.toString()}');
        replyWithNumberOfHolidays(req);
      }
    });
  });
}