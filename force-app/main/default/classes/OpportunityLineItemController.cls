public class OpportunityLineItemController {

    private ApexPages.StandardController stdController;
    public Opportunity opportunity { get; private set; }

    public Decimal opportunityAmount { get; private set; }
    public Decimal opportunityQuantity { get; private set; }
    public Decimal averagePrice { get; private set; }

    public OpportunityLineItemController(ApexPages.StandardController controller) {
        this.stdController = controller;
        opportunity = (Opportunity)controller.getRecord();
        calculateSummary();
    }

    private void calculateSummary() {
        List<OpportunityLineItem> lineItems = [SELECT TotalPrice, Quantity, PricebookEntry.UnitPrice
                                               FROM OpportunityLineItem
                                               WHERE OpportunityId = :opportunity.Id];

        Decimal totalAmount = 0;
        Decimal totalQuantity = 0;
        for (OpportunityLineItem item : lineItems) {
            totalAmount += item.TotalPrice;
            totalQuantity += item.Quantity;
        }

        if (totalQuantity != 0) {
            averagePrice = totalAmount / totalQuantity;
        } else {
            averagePrice = 0;
        }

        opportunityAmount = totalAmount;
        opportunityQuantity = totalQuantity;
    }


}