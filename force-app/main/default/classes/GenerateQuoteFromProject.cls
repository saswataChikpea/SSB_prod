public class GenerateQuoteFromProject {
    
     @AuraEnabled
    public static List<ChikPeaSSB__Chikpea_Project__c> CheckPrjStatus(Id Recid){
        
    List<ChikPeaSSB__Chikpea_Project__c> prjlist = [Select id,Name,ChikPeaSSB__Status__c,ChikPeaSSB__Estimated_Rate__c from ChikPeaSSB__Chikpea_Project__c where id =: Recid];

        String Status = prjlist[0].ChikPeaSSB__Status__c;
        system.debug('Status = '+Status);
        
        return prjlist;
        
        
    }
    
     @AuraEnabled
    public static Map<String, Object> GetQuote(list<id> prjid){
        Map<String, Object> response = new Map<String, Object>();
         List<ChikPeaO2B__Quote__c> Qtlist = New List<ChikPeaO2B__Quote__c>();
        
        List<ChikPeaSSB__Chikpea_Project__c> prjlist = [Select id,Name,ChikPeaSSB__Account__c,ChikPeaSSB__Project_Contact__c,ChikPeaSSB__Price_Book__c,ChikPeaSSB__Billing_Frequency__c,ChikPeaSSB__Status__c,ChikPeaSSB__Upfront_Payment_Percentage__c,ChikPeaSSB__Upfront_Amount__c from ChikPeaSSB__Chikpea_Project__c where id =: prjid and ChikPeaSSB__Status__c ='New'];
        
        
        system.debug('prjlist = '+prjlist);
        
        List<ChikPeaSSB__Resource__c> Reslist = [Select id, name,ChikPeaSSB__Phase__c,ChikPeaSSB__Item__c,ChikPeaSSB__Rate_Plan__c,ChikPeaSSB__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c,ChikPeaSSB__Phase__r.ChikPeaSSB__Project__c,ChikPeaSSB__Estimated_Hours__c,ChikPeaSSB__Phase__r.ChikPeaSSB__Is_Blended_Rate__c,ChikPeaSSB__Phase__r.ChikPeaSSB__Blended_Rate__c,ChikPeaSSB__Staff_Rate__c from ChikPeaSSB__Resource__c where ChikPeaSSB__Phase__r.ChikPeaSSB__Project__c =: prjid];
        
        system.debug('Reslist = '+Reslist);
        
        try{
        
        if(prjlist.size() > 0){
            For(Chikpea_Project__c prj : prjlist){
                
                ChikPeaO2B__Quote__c quote = New ChikPeaO2B__Quote__c();
                quote.ChikPeaO2B__Account__c = prj.ChikPeaSSB__Account__c;
                quote.ChikPeaO2B__Contact__c = prj.ChikPeaSSB__Project_Contact__c;
                quote.ChikPeaO2B__Price_Book__c = prj.ChikPeaSSB__Price_Book__c;
                quote.ChikPeaO2B__Status__c = 'Open';
                quote.ChikPeaSSB__Billing_Type__c = prj.ChikPeaSSB__Billing_Frequency__c;
                quote.ChikPeaSSB__Services_Billing__c = true;
                quote.ChikPeaSSB__Project__c = prj.Id;
                
                if(prj.ChikPeaSSB__Upfront_Payment_Percentage__c > 1 && prj.ChikPeaSSB__Upfront_Amount__c > 0){
                    quote.ChikPeaSSB__Upfront__c = true;  
                    quote.ChikPeaSSB__Upfront_Percent__c = prj.ChikPeaSSB__Upfront_Payment_Percentage__c;
                    quote.ChikPeaSSB__Upfront_Amount__c =  prj.ChikPeaSSB__Upfront_Amount__c;
                    
                    
                    
                }
               
                
                quote.ChikPeaO2B__Payment_Term__c = 'Net10';
                
                if(prj.ChikPeaSSB__Billing_Frequency__c == 'Weekly'){
                     quote.ChikPeaSSB__New_Payment_Term__c = 'Pay on Receipt';
                }
                if(prj.ChikPeaSSB__Billing_Frequency__c == 'Monthly'){
                     quote.ChikPeaSSB__New_Payment_Term__c = 'Net10';
                }
                if(prj.ChikPeaSSB__Billing_Frequency__c == 'Milestone'){
                     quote.ChikPeaSSB__New_Payment_Term__c = 'Net30';
                }
                
                insert quote; 
                
                 if(prj.ChikPeaSSB__Upfront_Payment_Percentage__c > 0){
         for(ChikPeaO2B__Rate_Plan__c rp : [Select id,ChikPeaO2B__Item__c from ChikPeaO2B__Rate_Plan__c where ChikPeaO2B__Price_Book__c =: prj.Price_Book__c And ChikPeaO2B__Item__r.Name = 'Upfront Payment']){
            
             ChikPeaO2B__Quote_Line__c Qtline = New ChikPeaO2B__Quote_Line__c();
             
             Qtline.ChikPeaO2B__Quote__c = quote.id;
             Qtline.ChikPeaO2B__Usage_Rate__c = quote.ChikPeaSSB__Upfront_Amount__c ;
             Qtline.ChikPeaO2B__Item__c = rp.ChikPeaO2B__Item__c;
             Qtline.ChikPeaO2B__Rate_Plan__c = rp.id;
             Qtline.ChikPeaO2B__Item_Type__c	= 'One-Off';
             Qtline.ChikPeaO2B__Unit_Price__c =  quote.ChikPeaSSB__Upfront_Amount__c;
             
             Insert Qtline;
                 }
                 }
                    
                
                Qtlist.add(quote);
                
                
                system.debug('Qtlist = '+Qtlist);
                if(Reslist.size() > 0){
                    For(Resource__c Res : Reslist){
                        
                        ChikPeaO2B__Quote_Line__c Qtline= New ChikPeaO2B__Quote_Line__c();
                        Qtline.ChikPeaO2B__Quote__c = quote.id;
                        Qtline.ChikPeaO2B__Item__c = Res.ChikPeaSSB__Item__c;
                        Qtline.ChikPeaO2B__Rate_Plan__c = Res.ChikPeaSSB__Rate_Plan__c;
                        Qtline.ChikPeaSSB__Phase__c = Res.ChikPeaSSB__Phase__c;
                        Qtline.ChikPeaSSB__Project_Name__c = Res.ChikPeaSSB__Phase__r.ChikPeaSSB__Project__c;
                        Qtline.ChikPeaSSB__Estimated_Hours__c = Res.ChikPeaSSB__Estimated_Hours__c;
                        Qtline.ChikPeaO2B__Item_Type__c	= 'Post-Paid Usage';
                        
                        if(Res.Phase__r.ChikPeaSSB__Is_Blended_Rate__c && Res.ChikPeaSSB__Staff_Rate__c == false){
                             Qtline.ChikPeaO2B__Usage_Rate__c = Res.ChikPeaSSB__Phase__r.ChikPeaSSB__Blended_Rate__c ;
                        }else if(Res.Phase__r.ChikPeaSSB__Is_Blended_Rate__c && Res.ChikPeaSSB__Staff_Rate__c){
                             Qtline.ChikPeaO2B__Usage_Rate__c = Res.ChikPeaSSB__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c ;
                        }
                        
                       
                        
                        Qtline.ChikPeaSSB__Resource__c = Res.Id;
                        
                        Insert Qtline;
                        
                        system.debug('Qtline = '+Qtline);
                        
                    }
                }
                
                  if(Qtlist.size() > 0){
            prjlist[0].ChikPeaSSB__Status__c = 'Quoted';
            prjlist[0].ChikPeaSSB__Quote__c = Qtlist[0].id;
            update prjlist;
            }
                
            }
          
            
        }
        }catch(Exception e){
            response.put('Error', true);
            response.put('ErrorMsg', e.getMessage());
            response.put('LineNumber', e.getLineNumber());
            system.debug('Exception ='+ e);
            ErrorLogger.log(e, 'GenerateQuoteFromProject');            
        }
        response.put('Qtlist', Qtlist);
        return response;
    }  
}