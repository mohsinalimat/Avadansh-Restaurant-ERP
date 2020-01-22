//
//  StructureModel.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import Foundation


// MARK: - Menus
//*****************************************************************//
struct MenuRoot: Codable {
    let status, message: String
    let data: [MenuData]
}

struct MenuData: Codable {
    let brandID, catID, catName: String
    let catImage: String
    
    enum CodingKeys: String, CodingKey {
        case brandID = "brand_id"
        case catID = "cat_id"
        case catName = "cat_name"
        case catImage = "cat_image"
    }
}


// MARK: - Food in the Menu
//*****************************************************************//
struct FoodMenuRoot: Codable {
    let status, message: String
    let data: [FoodMenuData]
}

// MARK: - Datum
struct FoodMenuData: Codable {
    let brandID, menuID, menuCatID, name: String
    let code, salesPrice, vegType: String
    let pic: String
    
    enum CodingKeys: String, CodingKey {
        case brandID = "brand_id"
        case menuID = "menu_id"
        case menuCatID = "menu_cat_id"
        case name, code
        case salesPrice = "sales_price"
        case vegType = "veg_type"
        case pic
    }
}


// MARK: - Order List
//*****************************************************************//
struct OrderListRoot: Codable {
    let status, message: String
    let data: [OrderListData]
}

struct OrderListData: Codable {
    let orderID: String?
    let table: String?
    let orderType: String?
    let time: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case table = "table"
        case orderType = "order_type"
        case time = "time"
    }
}

// MARK: - Order List Details Root
//*****************************************************************//
struct OrderListDetailsRoot: Codable {
    let status, message, address, waiter: String
    let customer, subtotal, discount: String
    let table : String?
    let vatCharges, delCharges, grandTotal, orderType: String
    let orderID, timeRemaining: String
    let data: [OrderListDetailsData]
    
    enum CodingKeys: String, CodingKey {
        case status, message, address, waiter, customer, table, subtotal, discount
        case vatCharges = "vat_charges"
        case delCharges = "del_charges"
        case grandTotal = "grand_total"
        case orderType = "order_type"
        case orderID = "order_id"
        case timeRemaining = "time_remaining"
        case data
    }
}


struct OrderListDetailsData: Codable {
    let menu, price, code, qty: String
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case menu, price, qty, total, code
    }
}


// MARK: - Last 10 Orders
//*****************************************************************//
struct Last10OrderRoot: Codable {
    let status, message: String
    let data: [Last10OrderData]
}


struct Last10OrderData: Codable {
    let orderID, name, subtotal, discount: String
    let vatCharges, delCharges, grandTotal, ordDate: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case name, subtotal, discount
        case vatCharges = "vat_charges"
        case delCharges = "del_charges"
        case grandTotal = "grand_total"
        case ordDate = "ord_date"
    }
}


// MARK: - Available Tables
//*****************************************************************//
struct TablesRoot: Codable {
    let status, message: String
    let data: [TablesData]
}

struct TablesData: Codable {
    let id, name, capacity, available: String
}



// MARK: - Customers
//*****************************************************************//
struct CustomersRoot: Codable {
    let status, message: String
    let data: [CustomersData]
}

struct CustomersData: Codable {
    let name, phone, id: String
}


// MARK: - On Hold List
//*****************************************************************//
struct OnHoldListRoot: Codable {
    let status, message: String
    let data: [OnHoldListData]
}


struct OnHoldListData: Codable {
    let orderID, name: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case name
    }
}


// MARK: - Kitchen Orders
//*****************************************************************//

struct KitchenOrdersRoot: Codable {
    let status, message: String
    let data: [KitchenOrdersData]
}

struct KitchenOrdersData: Codable {
    let orderID, orderType, table, expectedTime: String
    let remainingTime: String
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderType = "order_type"
        case table
        case expectedTime = "expected_time"
        case remainingTime = "remaining_time"
    }
}


// MARK: - Kitchen Orders Details
//*****************************************************************//

struct KitchenOrdersDetailsRoot: Codable {
    let status, message: String
    let data: [KitchenOrdersDetailsData]
}


struct KitchenOrdersDetailsData: Codable {
    let orderID: String
    let orderData: [KOrderDetailsData]
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderData = "order_data"
    }
}


struct KOrderDetailsData: Codable {
    let items, name, qty, status: String
}


// MARK: - Purchase List Details
//*****************************************************************//
struct PurchaseListRoot: Codable {
    let status, message: String
    let data: [PurchaseListData]
}

struct PurchaseListData: Codable {
    let refNo, pdate, name, gtotal: String
    let paid, due: String
    
    enum CodingKeys: String, CodingKey {
        case refNo = "ref_no"
        case pdate, name, gtotal, paid, due
    }
}



// MARK: - Sales Details
//*****************************************************************//
struct SalesRoot : Codable {
    let status, message: String
    let data: [SalesData]
}

struct SalesData : Codable {
    let orderID, orderType, ordDate: String
    let name: String?
    let grandTotal: String
    let payMeth: String?
    
    enum CodingKeys: String, CodingKey {
        case orderID = "order_id"
        case orderType = "order_type"
        case ordDate = "ord_date"
        case name
        case grandTotal = "grand_total"
        case payMeth = "pay_meth"
    }
}


// MARK: - Inventory Details
//*****************************************************************//
struct InventoryRoot: Codable {
    let status, message: String
    let data: [InventoryData]
}

struct InventoryData: Codable {
    let ingredient, catName, qty, alertQty: String
    
    enum CodingKeys: String, CodingKey {
        case ingredient
        case catName = "cat_name"
        case qty
        case alertQty = "alert_qty"
    }
}


// MARK: - Inventory Details
//*****************************************************************//
struct OutletListRoot: Codable {
    let status, message: String
    let data: [OutletListData]
}

struct OutletListData: Codable {
    let id, name, username, phone, address: String
    
    enum CodingKeys: String, CodingKey {
        case id = "outlet_id"
        case name = "outlet_name"
        case username = "username"
        case phone = "phone"
        case address = "address"
        
    }
}


// MARK: - Customer Details
//*****************************************************************//
struct CustomerRoot: Codable {
    let status, message: String
    let data: [CustomerData]
}

struct CustomerData : Codable {
    let name, phone, email: String
}


// MARK: - Account Details
//*****************************************************************//

struct AccountRoot: Codable {
    let status, message: String
    let data: AccountData
}

struct AccountData: Codable {
    let currentDay, currentMonth, total: AccountOverallData
    
    enum CodingKeys: String, CodingKey {
        case currentDay = "current_day"
        case currentMonth = "current_month"
        case total
    }
}

struct AccountOverallData: Codable {
    let sales, expenses, purchases, totalAccount: String
    
    enum CodingKeys: String, CodingKey {
        case sales, expenses, purchases
        case totalAccount = "total_account"
    }
}
