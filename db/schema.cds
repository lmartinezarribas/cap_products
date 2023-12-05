namespace com.logali;

using {
    cuid,
    managed
} from '@sap/cds/common';

type Address {
    Street     : String;
    City       : String;
    State      : String(2);
    PostalCode : String(5);
    Country    : String(3);

}

// entity Car {
//     key ID                 : UUID;
//         name               : String;
//         virtual discount_1 : Decimal;
//         @Core.Computed: false
//         virtual discount_2 : Decimal;

// }

// type Gender: String enum{
//     male;
//     female;
// };

// entity Order {
//     clientgender : Gender;
//     status: Integer enum{
//         submitted = 1;
//         fulfiller = 2;
//         shipped = 3;
//         cancel = -1;
//     };
//     priority: String @assert.range enum {
//         High;
//         Medium;
//         Low;
//     }
// }

// type EmailAddresses_01 : array of {
//     kind  : String;
//     email : String;
// };

// type EmailAddresses_02 {
//     kind  : String;
//     email : String;
// };

// entity Emails {
//     email_01 :      EmailAddresses_01;
//     email_02 : many EmailAddresses_02;
//     email_03 : many {
//         kind  : String;
//         email : String;
//     }
// }


entity Products : cuid, managed {
    //key ID               : UUID;
    name             : localized String default 'NoName';
    Description      : localized String not null;
    ImageUrl         : String;
    ReleaseDate      : DateTime default $now;
    CreationDate     : Date default CURRENT_DATE;
    DiscontinuedDate : DateTime;
    Price            : Decimal(16, 2);
    Height           : Decimal(16, 2);
    Width            : Decimal(16, 2);
    Depth            : Decimal(16, 2);
    Quantity         : Decimal(16, 2);
    Supplier         : Association to Supplier;
    UnitOfMeasure    : Association to UnitOfMeasures;
    Currency         : Association to Currencies;
    DimensionUnit    : Association to DimensionUnits;
    Category         : Association to Categories;
    SalesData      : Association to many SalesData
                           on SalesData.Product = $self;
    Reviews      : Association to many ProductReview
                           on Reviews.Product = $self;

};


entity Orders {
    key ID       : UUID;
        Date     : Date;
        Customer : String;
        Item     : Composition of many OrderItems;
};

entity OrderItems {
    key ID       : UUID;
        Order    : Association to Orders;
        Product  : Association to Products;
        Quantity : Integer;
};

entity Supplier {
    key ID      : UUID;
        Name    : String;
        Address : Address;
        Email   : String;
        Phone   : String;
        Fax     : String;
        Product : Association to many Products
                      on Product.Supplier = $self;
};


entity Categories {
    key ID   : String(1);
        Name : String;
};

entity StockAvailability {
    key ID          : Integer;
        Description : String;
        Product : Association to Products;

};

entity Currencies {
    key ID          : String(3);
        Description : String;

};

entity UnitOfMeasures {
    key ID          : String(2);
        Description : String;

};

entity DimensionUnits {
    key ID          : String(2);
        Description : String;

};

entity Months {
    key ID               : String(2);
        Description      : String;
        ShortDescription : String(3);

};

entity ProductReview {
    key ID      : UUID;
        Name    : String;
        Rating  : Integer;
        Comment : String;
        Product : Association to Products;
};

entity SalesData {
    key ID            : UUID;
        DeliveryDate  : DateTime;
        Revenue       : Decimal(16, 2);
        DeliveryMonth : Association to Months;
        Product       : Association to Products;
        Currency      : Association to Currencies;
};

entity SelProducts  as select from Products;

entity SelProducts1 as
    select from Products {
        *
    };

entity SelProducts2 as
    select from Products {
        name,
        Price,
        Quantity
    };

entity SelProducts3 as
    select from Products
    left join ProductReview
        on Products.name = ProductReview.Name
    {
        Rating,
        Products.name,
        sum(Price) as TotalPrice
    }
    group by
        Rating,
        Products.name
    order by
        Rating;

// entity ParamProducts(pName : String) as
//     select from Products {
//         name,
//         Price,
//         Quantity
//     }
//     where
//         name = : pName;

// entity ProjProducts3 as
//     projection on Products {
//         ReleaseDate,
//         name
//     }

extend Products with {
    PriceCondition     : String(2);
    PriceDetermination : String(3)
};
