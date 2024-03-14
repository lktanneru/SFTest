@IsTest
public class LookUpTest {
    
     @IsTest
     static void GetResultsTest () {
        // Create test records
        
        Account testAccount1 = new Account(Name='Test Account 1');
        
        Account testAccount2 = new Account(Name='Test Account 2');
        
        insert new List<Account>{testAccount1, testAccount2};
        
        // Call the method being tested
        
        List<String> selectedRecId = new List<String>();
        
        List<Lookup.SObjectResult> results = Lookup.getResults('Account', 'Name', 'Test', selectedRecId); 

         // Verify the results
        
        System.assertEquals(2, results.size());
        
        System.assertEquals('Test Account 1', results[0].recName);
        
        System.assertEquals(testAccount1.Id, results[0].recId);
        
        System.assertEquals('Test Account 2', results[1].recName);
        
        System.assertEquals(testAccount2.Id, results[1].recId);
     }
}