trigger AccountCreationDate on Account (before insert) {
    List<Account> acclist = Trigger.new;
    List<Account> acc = new List<Account>();
    for(Account a: acclist){
        a.Account_Creation_date__c  =System.today();
        acc.add(a);
    }
    
}