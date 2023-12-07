using {com.logali as logali} from '../db/schema';

// service CatalogService {
//     entity ProductsSrv as projection on logali.Products;
//     entity Supplier as projection on logali.Supplier;
//     entity Currency as projection on logali.Currencies;
//     entity DimensionUnit as projection on logali.DimensionUnits;
//     entity Category as projection on logali.Categories;
//     entity SalesData as projection on logali.SalesData;
//     entity Reviews as projection on logali.ProductReview;
//     entity UnitOfMeasure as projection on logali.UnitOfMeasures;
//     entity Months as projection on logali.Months;
//     entity Order as projection on logali.Orders;
//     entity OrderItem as projection on logali.OrderItems;
// }

define service CatalogService {
    entity Products          as
        select from logali.Products {
            // ID,
            // name          as ProductName @mandatory,
            // Description,
            // ImageUrl,
            // ReleaseDate,
            // DiscontinuedDate,
            // Price,
            // Height,
            // Width,
            // Depth,
            *,
            Quantity,
            UnitOfMeasure as ToUnitOfMeasure,
            Currency      as ToCurrency,
            Category      as ToCategory,
            Category.Name as Category,
            DimensionUnit as ToDimensionUnit,
            SalesData,
            Supplier,
            Reviews
        };

    @readonly
    entity Supplier          as
        select from logali.Supplier {
            ID,
            Name,
            Email,
            Phone,
            Fax,
            Product as ToProduct
        };

    entity Reviews           as
        select from logali.ProductReview {
            ID,
            Name,
            Rating,
            Comment,
            Product as ToProduct
        };

    @readonly
    entity SalesData         as
        select from logali.SalesData {
            ID,
            DeliveryDate,
            Revenue,
            Currency.ID               as CurrencyKey,
            DeliveryMonth.ID          as DeliveryMonthId,
            DeliveryMonth.Description as DeliveryMonthDescription,
            Product                   as ToProduct
        };

    @readonly
    entity StockAvailability as
        select from logali.StockAvailability {
            ID,
            Description,
            Product as ToProduct

        };

    @readonly
    entity VH_Categories     as
        select from logali.Categories {
            ID   as Code,
            Name as Text

        };

    @readonly
    entity VH_Currencies     as
        select from logali.Currencies {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_UnitOfMeasure  as
        select from logali.UnitOfMeasures {
            ID          as Code,
            Description as Text
        };

    @readonly
    entity VH_DimensionUnits as
        ID as Code,
        Description as Text
        select from logali.DimensionUnits;

}

define service MyService {
     entity SuppliersProduct as select from logali.Products[name = 'Milk'
     ]{
        *,
        Name,
        Description,
        Supplier.Address
     }
    where
        Supplier.Address.PostalCode = 98074;

    entity SuppliersToSales as
        select
            Supplier.Email,
            Category.Name,
            SalesData.Currency.ID,
            SalesData.Currency.Description
        from logali.Products;

    // entity EntityInfix as
    //     Supplier[Name = ]
    // select from logali.Products

    
}
