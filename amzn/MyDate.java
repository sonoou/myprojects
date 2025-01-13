package date;

import java.util.Locale;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;

public class MyDate{

  public String doFormat(LocalDate date){
    String dayName = date.getDayOfWeek().getDisplayName(TextStyle.FULL,Locale.ENGLISH);
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM");
    String formattedDate = date.format(formatter);
    String finalDate = dayName+", "+formattedDate;
    return finalDate;
  }
  public String getCurrentDate(){
    LocalDate currentDate = LocalDate.now();
    String finalDate = doFormat(currentDate);
    return finalDate;
  }
  public String getFutureDate(int days){
    LocalDate currentDate = LocalDate.now();
    LocalDate futureDate = currentDate.plusDays(days);
    String finalDate = doFormat(futureDate);
    return finalDate;
  }
}