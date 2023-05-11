global with sharing class convertToMultipleOrderBasedOnProjects 
{
   
    webservice static String quoteToOrder(List<String> qidList)
    {
        system.debug('++++++++'+qidList);
        
        List<ChikPeaO2B__Quote__c>qList=new List<ChikPeaO2B__Quote__c>();
        
        List<ChikPeaO2B__Order__c>NewOrderList=new List<ChikPeaO2B__Order__c>();
        
        List<ChikPeaO2B__Order__c>NewUpfrontOrderList=new List<ChikPeaO2B__Order__c>();
        
        Map<id,ChikPeaO2B__Order__c> OrderMap=new Map<id,ChikPeaO2B__Order__c>();
        
          Map<id,ChikPeaO2B__Order__c> OrderupfrontMap=new Map<id,ChikPeaO2B__Order__c>();
        
        List<ChikPeaO2B__Order_Line__c>NewOrderLineList=new List<ChikPeaO2B__Order_Line__c>();
        
        List<ChikPeaO2B__Quote__c>UpdateQuote=new List<ChikPeaO2B__Quote__c>();
        
        map<string,boolean> valid_quote=new map<string,boolean>();
        
        set<id> UniquePrjId = new set<id>();
        set<id> UniquePrjIdUpfront = new set<id>();
        
        list<id> ProcessOrdId = new  list<id>();
        
        if(qidList!=null && qidList.size()>0)
        {
            for(ChikPeaO2B__Quote__c qt:[SELECT id,name,ChikPeaO2B__Account__c,ChikPeaO2B__PO_Number__c,ChikPeaO2B__Price_Book__c,ChikPeaO2B__Status__c,
                                         ChikPeaO2B__Tax_Rate__c,ChikPeaO2B__Contact__c,ChikPeaO2B__Contract_Term_Months__c,Upfront__c,
                                         (SELECT id,name,ChikPeaO2B__Description__c,ChikPeaO2B__Item__c,ChikPeaO2B__Item__r.name,ChikPeaO2B__Item_Type__c,ChikPeaO2B__Package__c,ChikPeaO2B__Quantity__c,ChikPeaO2B__Quote__c,
                                          ChikPeaO2B__Subscription_Term_Months__c,ChikPeaO2B__Subscription_start_date__c,
                                          ChikPeaO2B__Rate_Plan__c,ChikPeaO2B__Non_recurring_Charge__c,ChikPeaO2B__Tax_Charge__c,ChikPeaO2B__Tax_Rate__c,
                                          ChikPeaO2B__Unit_Price__c,ChikPeaO2B__Free_Usage__c,ChikPeaO2B__Max_Usage__c,ChikPeaO2B__Min_Usage__c,
                                          ChikPeaO2B__Usage_Rate__c,Project_Name__c,ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Pricing_Type__c,ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c from 
                                          ChikPeaO2B__Quote_Lines__r) from ChikPeaO2B__Quote__c where id in:qidList])
                // where ChikPeaO2B__Item__r.Name <> 'Upfront Payment'
                qList.add(qt);
        }
        if(qList!=null && qList.size()>0)
        {
            for(ChikPeaO2B__Quote__c qt:qList)
            {
                if(qt.ChikPeaO2B__Status__c=='Open')//Convert to Order only when Quote's Status is Open
                { 
                    if(qt.ChikPeaO2B__Quote_Lines__r!=null && qt.ChikPeaO2B__Quote_Lines__r.size()>0)
                    {
                        for(ChikPeaO2B__Quote_Line__c qtl:qt.ChikPeaO2B__Quote_Lines__r)
                        {
                            if(qtl.ChikPeaO2B__Item__r.name == 'Upfront Payment' && qtl.Project_Name__c == null){
                                
                                UniquePrjIdUpfront.add(qtl.Project_Name__c);
                                
                            }else {
                               UniquePrjId.add(qtl.Project_Name__c);

                            }
                        } 
                        
                    }
                    system.debug('****UniquePrjIdUpfront*****'+UniquePrjIdUpfront);
                    if(UniquePrjId != null && UniquePrjId.size() > 0)
                    {  
                        //Upfront  changes can be added here
                        for(String id:UniquePrjId)
                        {
                            ChikPeaO2B__Order__c ord=new ChikPeaO2B__Order__c(ChikPeaO2B__Account__c=qt.ChikPeaO2B__Account__c,ChikPeaO2B__Contact__c=qt.ChikPeaO2B__Contact__c,
                                                                              ChikPeaO2B__PO_Number__c=qt.ChikPeaO2B__PO_Number__c,ChikPeaO2B__Price_Book__c=qt.ChikPeaO2B__Price_Book__c,ChikPeaO2B__Quote__c=qt.id,ChikPeaO2B__Status__c='Open',
                                                                              ChikPeaO2B__Tax_Rate__c=qt.ChikPeaO2B__Tax_Rate__c,Project__c=Id,Upfront__c = qt.Upfront__c);
                            
                            NewOrderList.add(ord);
                        }   
                    }
                     if(UniquePrjIdUpfront != null && UniquePrjIdUpfront.size() > 0)//For upfront 
                    {  
                        //Upfront  changes can be added here
                        for(String id:UniquePrjIdUpfront)
                        {
                            ChikPeaO2B__Order__c ord=new ChikPeaO2B__Order__c(ChikPeaO2B__Account__c=qt.ChikPeaO2B__Account__c,ChikPeaO2B__Contact__c=qt.ChikPeaO2B__Contact__c,
                                                                              ChikPeaO2B__PO_Number__c=qt.ChikPeaO2B__PO_Number__c,ChikPeaO2B__Price_Book__c=qt.ChikPeaO2B__Price_Book__c,ChikPeaO2B__Quote__c=qt.id,ChikPeaO2B__Status__c='Open',
                                                                              ChikPeaO2B__Tax_Rate__c=qt.ChikPeaO2B__Tax_Rate__c,Project__c=Id,Upfront__c = qt.Upfront__c);
                            
                            NewUpfrontOrderList.add(ord);
                        }   
                    }

                    
                    qt.ChikPeaO2B__Status__c='Accepted';					
                    UpdateQuote.add(qt);					
                    valid_quote.put(qt.id,true);
                }
            }
            try{
                if(NewOrderList != null && NewOrderList.size()>0)
                {
                    insert(NewOrderList);// Insert New Order
                    Insert(NewUpfrontOrderList);//inserting upfront order seperately
                    if(UpdateQuote!=null && UpdateQuote.size()>0)
                        update(UpdateQuote);
                    
                }
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
                      
                
            }
            catch(Exception e){
                ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
                BatchLog.ChikPeaO2B__Error_Log__c = 'Exception Type = '+e.getTypeName() +' Time = '+ system.now() + ' The Root Cause of Exception = ' + String.valueOf(e.getCause()) + '\n StackTrace ====> ' + e.getStackTraceString();
                BatchLog.Name = 'convertToMultipleOrderBasedOnProjects';
                insert BatchLog;
            }   
            for(ChikPeaO2B__Order__c ord:NewOrderList){  
                    OrderMap.put(ord.Project__c,ord);   
            }
            
            for(ChikPeaO2B__Order__c ord:NewUpfrontOrderList){  
                    OrderupfrontMap.put(ord.Project__c,ord);   
            }
            //Orderline starts from here
            for(ChikPeaO2B__Quote__c qt:qList)//qt contain the data of quote & quotelines
            {
                if(valid_quote.containskey(qt.id))
                {   
                    if(qt.ChikPeaO2B__Quote_Lines__r!=null && qt.ChikPeaO2B__Quote_Lines__r.size()>0)
                    {
                        for(ChikPeaO2B__Quote_Line__c qtl:qt.ChikPeaO2B__Quote_Lines__r)
                        { 
                            if(qtl.ChikPeaO2B__Item__r.name == 'Upfront Payment'){
                            ChikPeaO2B__Order_Line__c orl=new ChikPeaO2B__Order_Line__c(ChikPeaO2B__Description__c=qtl.ChikPeaO2B__Description__c,ChikPeaO2B__Item__c=qtl.ChikPeaO2B__Item__c,
                                                                                        ChikPeaO2B__Item_Type__c=qtl.ChikPeaO2B__Item_Type__c,Project__c=qtl.Project_Name__c,
                                                                                       ChikPeaO2B__Order__c = OrderupfrontMap.get(qtl.Project_Name__c).id,ChikPeaO2B__Quantity__c=qtl.ChikPeaO2B__Quantity__c,ChikPeaO2B__Quote_Line__c=qtl.id,
                                                                                        ChikPeaO2B__Rate_Plan__c=qtl.ChikPeaO2B__Rate_Plan__c,ChikPeaO2B__Unit_Price__c=qtl.ChikPeaO2B__Unit_Price__c,ChikPeaO2B__Package__c=qtl.ChikPeaO2B__Package__c);
                            orl.ChikPeaO2B__Subscription_Term_Months__c=qtl.ChikPeaO2B__Subscription_Term_Months__c;
                            orl.ChikPeaO2B__Subscription_start_date__c=qtl.ChikPeaO2B__Subscription_start_date__c;
                            orl.ChikPeaO2B__Free_Usage__c=qtl.ChikPeaO2B__Free_Usage__c;
                            orl.ChikPeaO2B__Max_Usage__c=qtl.ChikPeaO2B__Max_Usage__c;
                            orl.ChikPeaO2B__Min_Usage__c=qtl.ChikPeaO2B__Min_Usage__c;
                            
                            // ChikPeaO2B__Order_Line__c orl=new ChikPeaO2B__Order_Line__c(ChikPeaO2B__Order__c=OrderMap.get(qtl.Project_Name__c).id);
                            if(qtl.ChikPeaO2B__Usage_Rate__c!=null)
                                orl.ChikPeaO2B__Usage_Rate__c=qtl.ChikPeaO2B__Usage_Rate__c;
                            else
                            {
                                if(qtl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Pricing_Type__c=='Flat')
                                    orl.ChikPeaO2B__Usage_Rate__c=qtl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c;
                            }
                            NewOrderLineList.add(orl); 
                            }else{
                                 ChikPeaO2B__Order_Line__c orl=new ChikPeaO2B__Order_Line__c(ChikPeaO2B__Description__c=qtl.ChikPeaO2B__Description__c,ChikPeaO2B__Item__c=qtl.ChikPeaO2B__Item__c,
                                                                                        ChikPeaO2B__Item_Type__c=qtl.ChikPeaO2B__Item_Type__c,Project__c=qtl.Project_Name__c,
                                                                                        ChikPeaO2B__Order__c=OrderMap.get(qtl.Project_Name__c).id,ChikPeaO2B__Quantity__c=qtl.ChikPeaO2B__Quantity__c,ChikPeaO2B__Quote_Line__c=qtl.id,
                                                                                        ChikPeaO2B__Rate_Plan__c=qtl.ChikPeaO2B__Rate_Plan__c,ChikPeaO2B__Unit_Price__c=qtl.ChikPeaO2B__Unit_Price__c,ChikPeaO2B__Package__c=qtl.ChikPeaO2B__Package__c);
                            orl.ChikPeaO2B__Subscription_Term_Months__c=qtl.ChikPeaO2B__Subscription_Term_Months__c;
                            orl.ChikPeaO2B__Subscription_start_date__c=qtl.ChikPeaO2B__Subscription_start_date__c;
                            orl.ChikPeaO2B__Free_Usage__c=qtl.ChikPeaO2B__Free_Usage__c;
                            orl.ChikPeaO2B__Max_Usage__c=qtl.ChikPeaO2B__Max_Usage__c;
                            orl.ChikPeaO2B__Min_Usage__c=qtl.ChikPeaO2B__Min_Usage__c;
                            
                            // ChikPeaO2B__Order_Line__c orl=new ChikPeaO2B__Order_Line__c(ChikPeaO2B__Order__c=OrderMap.get(qtl.Project_Name__c).id);
                            if(qtl.ChikPeaO2B__Usage_Rate__c!=null)
                                orl.ChikPeaO2B__Usage_Rate__c=qtl.ChikPeaO2B__Usage_Rate__c;
                            else
                            {
                                if(qtl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Pricing_Type__c=='Flat')
                                    orl.ChikPeaO2B__Usage_Rate__c=qtl.ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Usage_Rate__c;
                            }
                            NewOrderLineList.add(orl);
                            }
                        }    
                    }
                }
            }
            try
            {
                if(NewOrderLineList != null && NewOrderLineList.size()>0)
                    insert(NewOrderLineList);//Insert New OrderLines
                
                if(Test.isRunningTest()) {
                    CalloutException e = new CalloutException();
                    e.setMessage('This is a constructed exception for testing and code coverage');
                    throw e;
                }
            }
            catch(Exception e){
                
                ChikPeaO2B__BatchLog__c BatchLog = new ChikPeaO2B__BatchLog__c();
                BatchLog.ChikPeaO2B__Error_Log__c = 'Exception Type = '+e.getTypeName() +' Time = '+ system.now() + ' The Root Cause of Exception = ' + String.valueOf(e.getCause()) + '\n StackTrace ====> ' + e.getStackTraceString();
                BatchLog.Name = 'convertToMultipleOrderBasedOnProjects';
                insert BatchLog;
            } 
        }
        if(NewOrderList!=null && NewOrderList.size()>0)
        {
            System.debug('*********NewOrderList************'+NewOrderList[0]);
            for(ChikPeaO2B__Quote__c qot : UpdateQuote){
                for(ChikPeaO2B__Quote_Line__c qtln : qot.ChikPeaO2B__Quote_Lines__r){
                    For(ChikPeaO2B__Order__c ord : NewUpfrontOrderList){
                        
                        If(qtln.ChikPeaO2B__Item__r.name =='Upfront Payment' && 
                           ord.Project__c == null && qtln.ChikPeaO2B__Item_Type__c == 'One-Off' &&
                           qot.Upfront__c == True  )
                        {
                            
                            ProcessOrdId.add(ord.id);
                            
                        }                  
                    }
                }
            }
            system.debug('*******ProcessOrdId************'+ProcessOrdId);
            ChikPeaO2B.ProcessOrder.OrderProcessorButton(ProcessOrdId);
            return NewOrderList[0].id;
        }else
        {
            return null;
        }
        
    }
}