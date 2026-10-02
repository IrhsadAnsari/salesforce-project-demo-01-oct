/**
* @File Name : ProductLookupController.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : August 18, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | August 18, 2024 |   | Initial Version
**/

public class ProductLookupController {
	 @AuraEnabled(cacheable=true)
    public static List<Product2> searchProducts(String searchKey) {
		List<Product2> productlist = new List<Product2>();
		if( searchKey !='')
		{
           String searchPattern = '%' + searchKey + '%';
         productlist =[
            SELECT Id, Name
            FROM Product2
            WHERE Name LIKE :searchPattern
            LIMIT 10
        ];
		}
        return productlist;
    }
}