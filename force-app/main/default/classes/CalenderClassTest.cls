@isTest
public class CalenderClassTest {
    static testmethod void testMtd(){
        Account testAccount1 = new Account(Name = 'TaskMeetingCompleteUnitTest');
		insert testAccount1;
        Event event = new Event( subject = 'Meeting',WhatId = testAccount1.id);
        
        Test.startTest();
        CalenderClass.getAllEvents();
        CalenderClass.updateEvent(String.valueOf(event.Id), String.valueOf(system.now()));
        Test.stopTest();
}
}