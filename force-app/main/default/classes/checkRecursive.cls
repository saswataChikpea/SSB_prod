/*
public class EsrBudgetCls {

    public static Boolean avoidUpdate = true;
    
}*/

public Class checkRecursive{
    private static boolean run = true;
    private static boolean run2 = true;
    public static boolean runOnce(){
    if(run){
	 run=false;
	 return true;
    }else{
        return run;
    }
    }
    public static boolean runOnce2(){
    if(run2){
	 run2=false;
	 return true;
    }else{
        return run2;
    }
    }
}