global with sharing class InvoiceLineSplit {

    Webservice static String Invoicesplitschdle() {

        String error;
        String sch;

        ScheduledInvoicelineSplit BCBS = new ScheduledInvoicelineSplit();

        list < ChikPeaO2B__O2B_Setting__c > O2BsetList = [SELECT id, ChikPeaO2B__Billing_Type__c, ChikPeaO2B__Billing_Day__c, ChikPeaO2B__Schedule_Time__c from ChikPeaO2B__O2B_Setting__c limit 1];
        if (O2BsetList != null && O2BsetList.size() > 0) {
            if (O2BsetList[0].ChikPeaO2B__Schedule_Time__c != null && O2BsetList[0].ChikPeaO2B__Schedule_Time__c != '') {
                List < String > scheduletime = O2BsetList[0].ChikPeaO2B__Schedule_Time__c.split(':');

                system.debug('ScheduleTime' + scheduletime);

                if (O2BsetList[0].ChikPeaO2B__Billing_Type__c == 'Anniversary Subscription') {
                    if (scheduletime[1] == '59') {

                        scheduletime[1] = '00';

                        string s1 = scheduletime[1];

                        system.debug('s1 = ' + s1);
                        If(integer.valueof(scheduletime[0]) == 23) {

                            scheduletime[0] = '00';
                            string s2 = scheduletime[0]; //1-24 but 00
                            system.debug('s1 = ' + s1);
                            system.debug('s2 = ' + s2);
                            sch = '0 ' + s1.trim() + ' ' + s2.trim() + ' * * ?';

                        } else {

                            string s2 = String.valueof(integer.valueof(scheduletime[0]) + 1);
                            system.debug('s2 = ' + s2);
                            sch = '0 ' + s1.trim() + ' ' + s2.trim() + ' * * ?';

                        }
                    } else {
                        string s1 = String.valueof(integer.valueof(scheduletime[1]) + 1);
                        system.debug('s1' + s1);

                        sch = '0 ' + s1.trim() + ' ' + ScheduleTime[0].trim() + ' * * ?';
                    }
                }
            }
            try {
                //sch='0 69 06 * * ?';
                system.schedule('Batch for Invoice line Split', sch, BCBS);
                error = 'success';
            } catch (Exception e) {
                error = e.getMessage();
            ErrorLogger.log(e, 'InvoiceLineSplit');            
                //throw new BatchException('Some error occured in BatchCreateBillRunScheduler Class.',e);
            }
        }
        return error;
    }

    Public static void InvoiceId() {
        List < Account > Acc = New List < Account > ();
        set < id > InvId = New set < id > ();

        set < id > OrdId = New set < id > ();
        List < ChikPeaO2B__Order_Line__c > ordl = new list < ChikPeaO2B__Order_Line__c > ();
        List < ChikPeaO2B__Subscription__c > Sub = new list < ChikPeaO2B__Subscription__c > ();
        List < ChikPeaO2B__Subscription__c > resetsub = new list < ChikPeaO2B__Subscription__c > ();


        try {
            Acc = [Select id, (Select id from ChikPeaO2B__Orders__r where ChikPeaO2B__Status__c = 'In Process'
                and Services_Billing__c = true) from Account where ChikPeaO2B__Active__c = 'Yes'];


            for (Account acnt: Acc) {
                for (ChikPeaO2B__Order__c ord: acnt.ChikPeaO2B__Orders__r) {
                    OrdId.add(ord.id);
                }
            }
            System.debug('Orders =' + OrdId);


            ordl = [select id, ChikPeaO2B__Item_Type__c, Project__c from ChikPeaO2B__Order_Line__c where ChikPeaO2B__Order__c =: OrdId and(ChikPeaO2B__Item_Type__c = 'Post-Paid Usage'
                OR ChikPeaO2B__Item_Type__c = 'Recurring')];

            System.debug('Order lines =' + ordl);


            Sub = [select id, ChikPeaO2B__Invoice__c, ChikPeaO2B__Recurring_Charge__c from ChikPeaO2B__Subscription__c where ChikPeaO2B__Order_Line__c =: ordl and LastModifiedDate = Today and ChikPeaO2B__Invoice__c != null];

            for (ChikPeaO2B__Subscription__c sub1: Sub) {
                for (ChikPeaO2B__Order_Line__c ol: ordl) {
                    //need to reset the subscbion recuring charge to zero
                    if (sub1.ChikPeaO2B__Recurring_Charge__c > 0 && ol.ChikPeaO2B__Item_Type__c == 'Post-Paid Usage' && ol.Project__c <> null) {
                        if (Schema.sObjectType.ChikPeaO2B__Subscription__c.fields.ChikPeaO2B__Recurring_Charge__c.isUpDateable()) {
                            sub1.ChikPeaO2B__Recurring_Charge__c = 0.00;
                            resetsub.add(sub1);
                        }
                    }
                }
                InvId.add(sub1.ChikPeaO2B__Invoice__c);
            }
            System.debug('InvId =' + InvId);

            for (id ids: InvId) {
                system.debug('Invoice id =' + ids);
                //Method need to be called
                InvoiceSplit(ids);
            }
            update resetsub;

        } catch (Exception e) {
            System.debug('Exception =' + e);
            ErrorLogger.log(e, 'InvoiceLineSplit');            
        }
    }

    //This method is to create seperate for each invoice line   

    public static void InvoiceSplit(id Inv) {
        if (Schema.sObjectType.ChikPeaO2B__Invoice__c.fields.ChikPeaO2B__Account__c.isCreateable() &&
            Schema.sObjectType.ChikPeaO2B__Invoice__c.fields.ChikPeaO2B__Billing_Contact__c.isCreateable() &&
            Schema.sObjectType.ChikPeaO2B__Invoice__c.fields.ChikPeaO2B__Accounting_Period__c.isCreateable() &&
            Schema.sObjectType.ChikPeaO2B__Invoice__c.fields.ChikPeaO2B__Bill_Date__c.isCreateable()) {
            list < id > Invln = new List < id > ();
            List < ChikPeaO2B__Invoice__c > Invs = new List < ChikPeaO2B__Invoice__c > ();
            Set < ChikPeaO2B__Invoice__c > Invinfo = new Set < ChikPeaO2B__Invoice__c > ();
            List < id > sublist = new List < id > ();

            List < ChikPeaO2B__Invoice__c > InsrtInv = new List < ChikPeaO2B__Invoice__c > ();
            List < ChikPeaO2B__Invoice_Line__c > Updinvlnlst = new List < ChikPeaO2B__Invoice_Line__c > ();
            List < ChikPeaO2B__Subscription__c > updsub = new List < ChikPeaO2B__Subscription__c > ();

            List < id > PaymttrmInvId = new List < ID > ();

            try {
                //geting Inv id for the payment term operation
                PaymttrmInvId.add(Inv);


                Invs = [select id, ChikPeaO2B__Account__c, ChikPeaO2B__Billing_Contact__c, ChikPeaO2B__Invoice_Status__c,
                    ChikPeaO2B__Accounting_Period__c, ChikPeaO2B__Bill_Date__c,
                    (select id, ChikPeaO2B__Invoice__c, ChikPeaO2B__Subscription__c from ChikPeaO2B__Invoice_Lines__r) from ChikPeaO2B__Invoice__c where id =: Inv and ChikPeaO2B__Invoice_Status__c = 'Open'
                ];


                for (ChikPeaO2B__Invoice__c l1: Invs) {
                    for (ChikPeaO2B__Invoice_Line__c invline: l1.ChikPeaO2B__Invoice_Lines__r) {
                        Invln.add(invline.id);
                        sublist.add(invline.ChikPeaO2B__Subscription__c);
                    }
                    system.debug('Invln =' + Invln);
                    system.debug('sublist =' + sublist);
                    for (integer count = 1; count < Invln.size(); count++) {
                        system.debug('count =' + count);

                        //Inserting new invoice
                        ChikPeaO2B__Invoice__c NewInv = new ChikPeaO2B__Invoice__c();
                        NewInv.ChikPeaO2B__Account__c = l1.ChikPeaO2B__Account__c;
                        NewInv.ChikPeaO2B__Billing_Contact__c = l1.ChikPeaO2B__Billing_Contact__c;
                        NewInv.ChikPeaO2B__Accounting_Period__c = l1.ChikPeaO2B__Accounting_Period__c;
                        NewInv.ChikPeaO2B__Bill_Date__c = l1.ChikPeaO2B__Bill_Date__c;

                        insert NewInv;
                        system.debug('NewInv =' + NewInv);

                        //geting Inv id for the payment term operation
                        PaymttrmInvId.add(NewInv.Id);


                        ChikPeaO2B__Invoice_Line__c Updinvln = new ChikPeaO2B__Invoice_Line__c();
                        if (Schema.sObjectType.ChikPeaO2B__Invoice_Line__c.fields.Id.isUpDateable()) {
                            Updinvln.id = Invln[count];
                        }
                        if (Schema.sObjectType.ChikPeaO2B__Invoice_Line__c.fields.ChikPeaO2B__Invoice__c.isUpDateable()) {
                            Updinvln.ChikPeaO2B__Invoice__c = NewInv.id;
                        }

                        Updinvlnlst.add(Updinvln);
                        ChikPeaO2B__Subscription__c sub = new ChikPeaO2B__Subscription__c();
                        sub.id = sublist[count];
                        if (Schema.sObjectType.ChikPeaO2B__Subscription__c.fields.ChikPeaO2B__Invoice__c.isUpDateable()){
                            sub.ChikPeaO2B__Invoice__c = NewInv.id;
                            updsub.add(sub);
                        }    

                    }

                }
                system.debug('Updinvlnlst =' + Updinvlnlst);
                system.debug('updsub =' + updsub);

                update Updinvlnlst;
                update updsub;

                //Calling the Payment term class and Passing the Inv id related ot Subscription
                for (ID SubInv: PaymttrmInvId) {
                    PaymentTerm.Subscrption(SubInv);
                }

            } catch (Exception e) {
                System.debug('Exception =' + e);
                ErrorLogger.log(e, 'InvoiceLineSplit');            
        }
        }
    }
}