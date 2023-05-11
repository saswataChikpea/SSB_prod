public class TemplateCls {
  @AuraEnabled
  public static Map<String, String> getOppDetails(String opportunityID) {
    System.debug('getOppDetails opportunityID :' + opportunityID);
    Map<String, String> oppMap = new Map<String, String>();
    if (opportunityID != null) {
      Opportunity opp = [
        SELECT id, name, Pricebook2Id, Account.id, Account.name
        FROM Opportunity
        WHERE id = :opportunityID
      ];
      oppMap.put('opp_name', opp.name);
      oppMap.put('account_name', opp.Account.name);
      oppMap.put('account_id', opp.Account.id);
      oppMap.put('Opp_id', opp.id);
      oppMap.put('Opp_pb', opp.Pricebook2Id);
    }
    return oppMap;
  }

  @AuraEnabled
  public static List<ChikPeaSSB__Chikpea_Project__c> getProjects() {
    List<String> pickListValuesList = new List<String>();
    Schema.DescribeFieldResult fieldResult = ChikPeaSSB__Chikpea_Project__c.ChikPeaSSB__Category__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry pickListVal : ple) {
      pickListValuesList.add(pickListVal.getLabel());
    }

    system.debug('pickListValuesList = ' + pickListValuesList);

    //List of 6 color used in the chikpea logo

    List<String> Colorlist = new List<String>();
    Colorlist.add('lightGreen');
    Colorlist.add('DarkGreen');
    Colorlist.add('lightBlue');
    Colorlist.add('DarkBlue');
    Colorlist.add('Orange');
    Colorlist.add('DarkOrange');
    system.debug('Colorlist = ' + Colorlist);

    String ColorCode = '';
    List<ChikPeaSSB__Chikpea_Project__c> PrjList = new List<ChikPeaSSB__Chikpea_Project__c>();

    for (ChikPeaSSB__Chikpea_Project__c prj : [
      SELECT
        Id,
        Name,
        ChikPeaSSB__Template_Description__c,
        ChikPeaSSB__Template_Name__c,
        ChikPeaSSB__Category__c,
        ChikPeaSSB__Template_Color__c,
        (SELECT Id, Name FROM ChikPeaSSB__Project_Phases__r)
      FROM ChikPeaSSB__Chikpea_Project__c
      WHERE ChikPeaSSB__Templatize__c = TRUE
      ORDER BY ChikPeaSSB__Category__c ASC
    ]) {
      /*    Integer array_size = 0;
                                           for(Integer i=0;i<pickListValuesList.size();i++){
                                              if(pickListValuesList[i] == prj.ChikPeaSSB__Category__c){
                                                  system.debug('array_size = '+array_size);
                                                  system.debug('Colorlist.size() = '+Colorlist.size());
                                                  if(array_size == Colorlist.size()){
                                                      array_size = 0;
                                                  }
                                                  prj.ChikPeaSSB__Template_Color__c = Colorlist[array_size];
                                                  
                                                  }
                                               array_size++;
                                                  
                                              }*/
      for (Integer i = 0; i < pickListValuesList.size(); i++) {
        if (pickListValuesList[i] == prj.ChikPeaSSB__Category__c) {
          if (i < 6) {
            prj.ChikPeaSSB__Template_Color__c = Colorlist[i];
          } else {
            integer siz = i;
            Integer Rem = Math.MOD(siz, 6);
            system.debug('Rem = ' + Rem);
            if (Rem != 0) {
              prj.ChikPeaSSB__Template_Color__c = Colorlist[Rem];
            } else {
              prj.ChikPeaSSB__Template_Color__c = Colorlist[0];
            }
          }
        }
      }
      PrjList.add(prj);
    }
    return PrjList;
  }

  @AuraEnabled
  public static List<ChikPeaSSB__Project_Phase__c> getPhase(Id recordId) {
    List<ChikPeaSSB__Project_Phase__c> PhsList = new List<ChikPeaSSB__Project_Phase__c>();

    for (ChikPeaSSB__Project_Phase__c prj : [
      SELECT Id, Name, (SELECT id, Name FROM ChikPeaSSB__Resources__r)
      FROM ChikPeaSSB__Project_Phase__c
      WHERE ChikPeaSSB__Project__c = :recordId
    ]) {
      PhsList.add(prj);
    }
    return PhsList;
  }

  @AuraEnabled
  public static List<ChikPeaSSB__Chikpea_Project__c> NewProjectApx(
    Id recordId,
    String Pname,
    Id Accid,
    Id pricebookId
  ) {
    // String pricebookId

    List<ChikPeaSSB__Project_Phase__c> Phase = [
      SELECT
        Id,
        Name,
        ChikPeaSSB__Project__r.Name,
        ChikPeaSSB__Descriptions__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Project_Description__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Project_Goals__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Project_Specifications__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Account__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Project_Contact__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Price_Book__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Upfront_Payment_Percentage__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Is_Audit__c,
        ChikPeaSSB__Project__r.ChikPeaSSB__Billing_Frequency__c,
        ChikPeaSSB__Is_Blended_Rate__c,
        ChikPeaSSB__Blended_Rate__c,
        ChikPeaSSB__Status__c,
        ChikPeaSSB__Dependencies__c,
        ChikPeaSSB__Weeks__c,
        (
          SELECT
            Id,
            Name,
            ChikPeaSSB__Item__c,
            ChikPeaSSB__Rate_Plan__c,
            ChikPeaSSB__Cost_Plan__c,
            ChikPeaSSB__Estimated_Hours__c,
            ChikPeaSSB__Estimated_Efforts__c,
            ChikPeaSSB__Staff_Rate__c
          FROM ChikPeaSSB__Resources__r
        )
      FROM ChikPeaSSB__Project_Phase__c
      WHERE ChikPeaSSB__Project__c = :recordId
    ];

    System.debug('Old Phase = ' + Phase);
    String PrjName = Pname;
    System.debug('PrjName = ' + PrjName);
    System.debug('pricebookId==>' + pricebookId);

    List<Pricebook2> sFpriceBk = new List<Pricebook2>();
    sFpriceBk = [
      SELECT Id, Name, ChikPeaSSB__O2b_Price_Book__c
      FROM Pricebook2
      WHERE id = :pricebookId
    ];

    List<ChikPeaSSB__Project_Phase__c> NewPhase = new List<ChikPeaSSB__Project_Phase__c>();
    List<ChikPeaSSB__Resource__c> NewRes = new List<ChikPeaSSB__Resource__c>();
    List<ChikPeaSSB__Chikpea_Project__c> Newprj = new List<ChikPeaSSB__Chikpea_Project__c>();

    try {
      if (Phase.size() > 0) {
        ChikPeaSSB__Chikpea_Project__c prj = new ChikPeaSSB__Chikpea_Project__c();
        prj.Name = PrjName;
        prj.ChikPeaSSB__Account__c = Accid;
        //   prj.ChikPeaSSB__Project_Contact__c = Phase[0].ChikPeaSSB__Project__r.ChikPeaSSB__Project_Contact__c;
        prj.ChikPeaSSB__Price_Book__c = sFpriceBk[0]
          .ChikPeaSSB__O2b_Price_Book__c;
        prj.ChikPeaSSB__Billing_Frequency__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Billing_Frequency__c;
        prj.ChikPeaSSB__Upfront_Payment_Percentage__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Upfront_Payment_Percentage__c;
        prj.ChikPeaSSB__Is_Audit__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Is_Audit__c;
        prj.ChikPeaSSB__Est_Start_Date__c = system.today() + 1;
        prj.ChikPeaSSB__Project_Description__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Project_Description__c;
        prj.ChikPeaSSB__Project_Specifications__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Project_Specifications__c;
        prj.ChikPeaSSB__Project_Goals__c = Phase[0]
          .ChikPeaSSB__Project__r.ChikPeaSSB__Project_Goals__c;
        insert prj;
        Newprj.add(prj);
        id returnid = prj.Id;

        System.debug('Newprj = ' + Newprj);
        Integer counter = 0;

        for (ChikPeaSSB__Project_Phase__c Ph : Phase) {
          ChikPeaSSB__Project_Phase__c phs = new ChikPeaSSB__Project_Phase__c();
          phs.Name = Ph.Name;
          phs.ChikPeaSSB__Descriptions__c = Ph.ChikPeaSSB__Descriptions__c;
          phs.ChikPeaSSB__Project__c = prj.Id;
          phs.ChikPeaSSB__Is_Blended_Rate__c = Ph.ChikPeaSSB__Is_Blended_Rate__c;
          phs.ChikPeaSSB__Blended_Rate__c = Ph.ChikPeaSSB__Blended_Rate__c;
          phs.ChikPeaSSB__Status__c = 'Open';
          phs.ChikPeaSSB__Dependencies__c = Ph.ChikPeaSSB__Dependencies__c;
          phs.ChikPeaSSB__Weeks__c = Ph.ChikPeaSSB__Weeks__c;

          if (counter == 0) {
            phs.ChikPeaSSB__Dependencies__c = 'Independent';
            phs.ChikPeaSSB__Est_Start_date__c = prj.ChikPeaSSB__Est_Start_Date__c;
          }
          if(phs.ChikPeaSSB__Dependencies__c == '' || phs.ChikPeaSSB__Dependencies__c == null ){
            phs.ChikPeaSSB__Dependencies__c = 'Independent';
          }
          counter = counter + 1;
          insert phs;
          NewPhase.add(phs);

          System.debug('NewPhase = ' + NewPhase);

          for (ChikPeaSSB__Resource__c Res : Ph.ChikPeaSSB__Resources__r) {
            ChikPeaSSB__Resource__c Nres = new ChikPeaSSB__Resource__c();
            Nres.ChikPeaSSB__Phase__c = phs.id;
            Nres.ChikPeaSSB__Item__c = Res.ChikPeaSSB__Item__c;
            Nres.ChikPeaSSB__Rate_Plan__c = Res.ChikPeaSSB__Rate_Plan__c;
            Nres.ChikPeaSSB__Cost_Plan__c = Res.ChikPeaSSB__Cost_Plan__c;
            Nres.ChikPeaSSB__Staff_Rate__c = Res.ChikPeaSSB__Staff_Rate__c;
            Nres.ChikPeaSSB__Estimated_Hours__c = Res.ChikPeaSSB__Estimated_Hours__c;
            Nres.ChikPeaSSB__Estimated_Efforts__c = Res.ChikPeaSSB__Estimated_Efforts__c;
            insert Nres;
            NewRes.add(Nres);
            System.debug('NewRes = ' + NewRes);
          }
        }
        return Newprj;
      }
    } catch (Exception e) {
      System.debug('Exception = ' + e);
      ErrorLogger.log(e, 'TemplateCls');
      String errorMsg = e.getMessage();
            throw new AuraHandledException(ErrorMsg);
    }

    return Newprj;
  }

  @AuraEnabled
  public static void RemoveTemplate(Id Tempid) {
    List<ChikPeaSSB__Chikpea_Project__c> Prjlist = [
      SELECT Id, ChikPeaSSB__Templatize__c
      FROM ChikPeaSSB__Chikpea_Project__c
      WHERE id = :Tempid
    ];

    if (Prjlist[0].ChikPeaSSB__Templatize__c && Prjlist.size() > 0) {
      Prjlist[0].ChikPeaSSB__Templatize__c = false;

      update Prjlist;
    }
  }

  @AuraEnabled
  public static List<String> getPickListValuesIntoList() {
    List<String> pickListValuesList = new List<String>();
    Schema.DescribeFieldResult fieldResult = ChikPeaSSB__Chikpea_Project__c.ChikPeaSSB__Category__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for (Schema.PicklistEntry pickListVal : ple) {
      pickListValuesList.add(pickListVal.getLabel());
    }
    system.debug('pickListValuesList = ' + pickListValuesList);
    return pickListValuesList;
  }
}