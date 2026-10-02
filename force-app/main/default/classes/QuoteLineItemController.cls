public class QuoteLineItemController {
    public Quote_Line_Item__c newQuoteLineItem { get; set; }
    private Id quoteId;

    public QuoteLineItemController(ApexPages.StandardController controller) {
        this.quoteId = controller.getId();
        this.newQuoteLineItem = new Quote_Line_Item__c(Quote_Id__c = quoteId);
    }

    public PageReference saveLineItem() {
        try {
            insert newQuoteLineItem;
            return new PageReference('/' + quoteId);
        } catch (DmlException ex) {
            ApexPages.addMessages(ex);
            return null;
        }
    }


}