//
//  CheckoutViewController.swift
//  Avadansh
//
//  Created by Admin on 01/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import SearchTextField
import DropDown


class CheckoutViewController: UIViewController {
    
    var popupType = ""
    var orderID = ""
    var finalorder = [Food]()
    
    private var customerID = ""
    private var tableID = ""
    private var finalOrderJSON = ""
    
    private var validDiscount = true
    
    @IBOutlet weak var personTF: UITextField!{
        didSet{
            if popupType == "T"{
                personTF.isHidden = true
            }
        }
    }
    @IBOutlet weak var discountTF: UITextField!
    @IBAction func discountTF(_ sender: UITextField) {
        
        if discountTF.text != ""{
            if Int(discountTF.text!)! <= 50{
                validDiscount = true
                discountTF.textColor = UIColor.flatGreen()
            }else{
                validDiscount = false
                discountTF.textColor = UIColor.flatRed()
            }
        }
        
        
    }
    
    
    @IBOutlet weak var deliveryTF: UITextField!{
        didSet{
            if popupType == "D"{
                deliveryTF.isHidden = true
            }
        }
    }
    
    
    private struct Table{
        
        let id, name, capacity, available: String
        
    }
    
    private struct Customer{
        let name, phone, id: String
    }
    
    private var tables = [Table]()
    private var cust = [Customer]()
    private var tab = [String]()
    private var custtomerPhone = [SearchTextFieldItem]()
    
    
    
    
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = UIColor.flatWhite()?.withAlphaComponent(0.5)
        }
    }
    
    @IBOutlet weak var popupView: UIView!{
        didSet{
            popupView.backgroundColor = UIColor.white.withAlphaComponent(1)
        }
    }
    
    @IBOutlet weak var checkoutStack: UIStackView!
    @IBOutlet weak var selectTableBtn: UIButton!
    
    @IBAction func holdBtn(_ sender: UIButton) {
        
        if customerID != ""{
            
            if popupType == "D"{
                placeOrder(ordertype: "0", status: "4")
            }else if popupType == "T"{
                placeOrder(ordertype: "1", status: "4")
            }
            
        }else{
            showErrorProgress(msg: "Please select a valid customer.")
        }
        
        
        
    }
    
    
    @IBAction func selectTableBtn(_ sender: UIButton) {
        
        
        let dropDown = DropDown()
        
        dropDown.anchorView = selectTableBtn
        dropDown.dataSource = tab
        dropDown.show()
        dropDown.direction = .bottom
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.selectTableBtn.setTitle(item, for: .normal)
            self.tableID = self.tables[index].id
            
        }
        
        
        
    }
    
    
    
    
    @IBOutlet weak var customerTF: SearchTextField!
    
    @IBAction func addCustomerBtn(_ sender: UIButton) {
        checkoutStack.isHidden = true
        addCustomerStack.isHidden = false
        clearTFData()
    }
    
    @IBAction func checkoutCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkoutDonBtn(_ sender: UIButton) {
        
        if customerID != ""{
            
            if popupType == "D"{
                placeOrder(ordertype: "0", status: "1")
            }else if popupType == "T"{
                placeOrder(ordertype: "1", status: "1")
            }
            
        }else{
            showErrorProgress(msg: "Customer ID can't be empty")
        }
    }
    
    
    
    @IBOutlet weak var addCustomerStack: UIStackView!
    
    @IBOutlet weak var customerNameTF: UITextField!
    @IBOutlet weak var customerPhoneTF: UITextField!
    @IBOutlet weak var customerEmailTF: UITextField!
    @IBOutlet weak var customerAddressTF: UITextField!
    
    @IBAction func customerCancelBtn(_ sender: UIButton) {
        
        clearTFData()
        checkoutStack.isHidden = false
        addCustomerStack.isHidden = true
        
    }
    
    @IBAction func customerAddBtn(_ sender: UIButton) {
        
        if customerNameTF.text != "" && customerAddressTF.text != "" && customerPhoneTF.text != "" && customerEmailTF.text != ""{
            
            self.addCustomer()
            
            
        }else{
            if customerNameTF.text == ""{
                showInfoProgress(msg: "Please enter name of the customer.")
            }else if customerAddressTF.text == ""{
                showInfoProgress(msg: "Please enter address of the customer.")
            }else if customerPhoneTF.text == ""{
                showInfoProgress(msg: "Please enter phone of the customer.")
            }else if customerEmailTF.text == ""{
                showInfoProgress(msg: "Please enter email of the customer.")
            }
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(popupType)
        
        if popupType == "T"{
            selectTableBtn.isHidden = true
        }
        
        getTableData()
        getCustomerData()
        getJSON()
        
        
        
    }
    
    
    
    
    
    private func getCustomerData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "customers.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.cust = [Customer]()
                    self.custtomerPhone.removeAll()
                    let cust = try JSONDecoder().decode(CustomersRoot.self, from: data)
                    
                    if cust.status == "1"{
                        
                        for x in cust.data{
                            self.cust.append(Customer(name: x.name, phone: x.phone
                                , id: x.id))
                            self.custtomerPhone.append(SearchTextFieldItem(title: x.phone, subtitle: x.name))
                        }
                        
                    }else{
                        self.showErrorProgress(msg: cust.message)
                    }
                    self.setCustomerTFEvent()
                }catch{
                    print(error)
                }
            }
        }
        
    }
    
    private func getTableData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "tables.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.tables = [Table]()
                    self.tab = [String]()
                    let table = try JSONDecoder().decode(TablesRoot.self, from: data)
                    
                    if table.status == "1"{
                        
                        for x in table.data{
                            self.tables.append(Table(id: x.id, name: x.name, capacity: x.capacity, available: x.available))
                            
                            self.tab.append(x.name)
                        }
                        
                        
                    }else{
                        self.showErrorProgress(msg: table.message)
                    }
                    
                }catch{
                    print(error)
                }
            }
        }
        
    }
    
    
    private func addCustomer(){
        showProgress()
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "add_customers.php", params: ["outlet_id":outlet,"name":customerNameTF.text!,"phone":customerPhoneTF.text!,"email":customerEmailTF.text!,"address":customerAddressTF.text!,"token":apiToken]){ (json, data) in
                
                if json["status"].stringValue == "1"{
                    self.clearTFData()
                    self.getCustomerData()
                    self.checkoutStack.isHidden = false
                    self.addCustomerStack.isHidden = true
                    self.dismissProgress()
                }else{
                    self.clearTFData()
                    self.showErrorProgress(msg: json["message"].stringValue)
                }
            }
        }
        
        
    }
    
    private func setCustomerTFEvent(){
        
        self.customerTF.filterItems(self.custtomerPhone)
        self.customerTF.maxNumberOfResults = 5
        // Start filtering after an specific number of characters - Default: 0
        self.customerTF.minCharactersNumberToStartFiltering = 5
        
        self.customerTF.itemSelectionHandler = {item, itemPosition in
            
            self.customerTF.text = "\(item[itemPosition].title)  (\(item[itemPosition].subtitle))"
            for x in self.cust{
                if x.phone == item[itemPosition].title{
                    self.customerID = x.id
                    print(x.id)
                }
            }
        }
    }
    
    
    private func clearTFData(){
        
        customerID = ""
        tableID = ""
        customerTF.text = ""
        customerNameTF.text = ""
        customerPhoneTF.text = ""
        customerEmailTF.text = ""
        customerAddressTF.text = ""
        
        
    }
    
    private func getJSON(){
        
        var final = [[String:String]]()
        
        for x in finalorder{
            final.append(["code":x.code,"quan":x.incart,"sales_price":x.salesPrice, "total": String(Int(x.incart)! * Int(x.salesPrice)!), "menu_cat_id": x.menuCatID ])
        }
        
        finalOrderJSON = getStringFromJSON(parameters: final)
        
    }
    
    
    private func placeOrder(ordertype: String, status : String){
        
        //orderType : 0 -> Dine In , 1 -> Take Away
        //status: 1 -> place order, 4 -> OnHold
        if validDiscount{
        self.showProgress()
        
        if let outlet = defaults.string(forKey: "outletID"){
            if let waiterID = defaults.string(forKey: "userID"){
                if let barvat = defaults.string(forKey: "barVAT"){
                   
                    alamofireRequest(url: "place_order.php", params: ["token":apiToken, "data":finalOrderJSON,"table_id":tableID, "capacities":"","person":personTF.text!, "outlet_id":outlet,"occupied":"","order_type":ordertype,"customer_id":customerID,"waiter_id":waiterID, "delivery_boy":"", "discount":discountTF.text!, "vat2":barvat, "delivery":deliveryTF.text!, "status":status, "order_id" : self.orderID]) { (json, data) in
                        
                        if json["status"].stringValue == "1"{
                            self.showSuccessProgress(msg: json["message"].stringValue)
                            self.goToPage(goto: "Home")
                        }else{
                            self.showErrorProgress(msg: json["message"].stringValue)
                        }
                        
                        
                        
                    }
                }
            }
        }
        
        }else{
            
            showErrorProgress(msg: "Please enter valid discount")
            
        }
        
        
        
        
        
    }
    
    
    
    
}
