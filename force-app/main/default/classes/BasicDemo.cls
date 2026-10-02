public class BasicDemo {
 public static void StringClass()
 {
     //String name= 'Irshad Ansari';
     //String newName='';
     
     String inputSentence = 'This is a sample sentence';

     List<String> words = inputSentence.split(' ');

     String concatenatedString = '';
    for (String word : words) {
    if (word.length() >= 3) {
                          concatenatedString += word.substring(0, 3);
                          }
    else {
          concatenatedString += word;
         }
}

System.debug(concatenatedString.toUpperCase());

     //System.debug('Name--->'+name);
    /* List <String> parts= new List<String>();
     if(name.containsWhitespace())
     {
         name.deleteWhitespace();
        parts =name.splitByCharacterTypeCamelCase();
     }
     System.debug('First Char--->'+name);
     System.debug('Parts-->'+parts); 
     System.debug('Parts Size-->'+parts.size());
   for(integer i=0;i<parts.size();i++)
    {
        if(parts[i]!='')
        {
            newName=newName+parts[i];
        }
            
    }
     System.debug('New Name-->'+newName);
     System.debug('New Name size'+newName.length());*/
 }
}