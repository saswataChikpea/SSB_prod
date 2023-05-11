public class PaymentTerm {

    Public static void Subscrption(id Invc) {
        if (Schema.sObjectType.ChikPeaO2B__Invoice__c.fields.ChikPeaO2B__Payment_Term__c.isUpDateable()) {
            list <ChikPeaO2B__Invoice__c> updinvlp = new list <ChikPeaO2B__Invoice__c> ();


            for (ChikPeaO2B__Invoice__c inv : [select id, ChikPeaO2B__Payment_Term__c from ChikPeaO2B__Invoice__c where id = : Invc]) {
                system.debug('inv = ' + inv.id);
                for (ChikPeaO2B__Invoice_Line__c invl : [select id, ChikPeaO2B__Subscription__c from ChikPeaO2B__Invoice_Line__c where ChikPeaO2B__Invoice__c =: inv.id]) {
                    system.debug('invl = ' + invl.id);

                    for(ChikPeaO2B__Subscription__c sub : [select id, ChikPeaO2B__Order_Line__c from ChikPeaO2B__Subscription__c where id = : invl.ChikPeaO2B__Subscription__c]){
                        system.debug('sub = ' + sub.id);

                        for (ChikPeaO2B__Order_Line__c ordl : [select id, ChikPeaO2B__Order__c, Project__c, ChikPeaO2B__Rate_Plan__r.ChikPeaO2B__Bill_Cycle__c from ChikPeaO2B__Order_Line__c where id = : sub.ChikPeaO2B__Order_Line__c]) {
                            system.debug('ordl = ' + ordl.id);

                            for (ChikPeaO2B__Order__c ord : [Select id, ChikPeaO2B__Quote__c from ChikPeaO2B__Order__c where id = : ordl.ChikPeaO2B__Order__c]) {
                                system.debug('ord = ' + ord.id);
                                for (ChikPeaO2B__Quote__c qt : [select id, New_Payment_Term__c, ChikPeaO2B__Payment_Term__c from ChikPeaO2B__Quote__c where id = : ord.ChikPeaO2B__Quote__c]) {
                                    system.debug('qt = ' + qt.id);
                                    If(ordl.Project__c == null && inv.ChikPeaO2B__Payment_Term__c != qt.ChikPeaO2B__Payment_Term__c){

                                        inv.ChikPeaO2B__Payment_Term__c = qt.ChikPeaO2B__Payment_Term__c;
                                        updinvlp.add(inv);
                                    }else if (ordl.Project__c != null && inv.ChikPeaO2B__Payment_Term__c != qt.New_Payment_Term__c) {

                                        inv.ChikPeaO2B__Payment_Term__c = qt.New_Payment_Term__c;
                                        updinvlp.add(inv);

                                    }
                                }
                            }
                        }
                    }
                }
            }

            System.debug('updinvlp =' + updinvlp);

            Update updinvlp;


        }
    }
}