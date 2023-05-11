public with sharing class Utils {
    public static Date addBussinessDays(Date startDate, Integer iDays){
        Integer businessDaysAdded = 0;
        Date currentDate = startDate;
        while (businessDaysAdded < iDays) {
            currentDate = currentDate.addDays(1);
            Datetime d = datetime.newInstance(currentDate.year(), currentDate.month(),currentDate.day());

            if (d.format('E') != 'Sat' && d.format('E') != 'Sun' && checkifItisWorkingDay(currentDate)) {
                // it's a business day, so add 1 to the counter that works towards the amount of days to add
                businessDaysAdded = businessDaysAdded + 1;
            } 
        }       
        return currentDate;
    }

    public static List<Holiday> holidays {
        get {
            if(holidays == null)
                holidays=[Select h.StartTimeInMinutes, h.Name, h.ActivityDate From Holiday h];
            return holidays;
        }
        private set;
    }

    public static boolean checkifItisWorkingDay(Date currentDate){
        Date weekStart  = currentDate.toStartofWeek();
        for(Holiday hDay:holidays){
            if(currentDate.daysBetween(hDay.ActivityDate) == 0){
                return false;
            }
        }
        if(weekStart.daysBetween(currentDate) ==0 || weekStart.daysBetween(currentDate) == 6){
            return false;
        } else 
            return true;
    } 
}