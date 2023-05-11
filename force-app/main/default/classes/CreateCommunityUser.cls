public class CreateCommunityUser {
    @InvocableMethod(label='Create Community User')
	public static List<Id> createAccount(List<Id> ids){

        Id profileId = [Select Id From Profile Where Name = 'Community Login Profile' LIMIT 1].Id;

        Account act = new Account(); 
        // act.FirstName='';
        // act.LastName='';
        Database.insert(act);

        // User communityUser = new User();
        // communityUser.LanguageLocaleKey = 'en_US';
        // communityUser.LocaleSidKey = 'en_US';
        // communityUser.Username = userDetail.get('Username');
        // communityUser.Email = userDetail.get('Email');
        // communityUser.FirstName = userDetail.get('FirstName');
        // communityUser.LastName = userDetail.get('LastName');
        // communityUser.CommunityNickname = userDetail.get('FirstName')+string.valueOf(math.random()).substring(0,6);
		// communityUser.ProfileId = profileId;
        // userName = userDetail.get('Username');
		
        // insert communityUser;
        return ids;

    }
}