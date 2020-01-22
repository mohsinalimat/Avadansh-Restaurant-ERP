//
//  OrderListDetailsViewController.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OrderListDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    
    private struct Detail{
        let menu, price, qty, code: String
        let total: String
    }
    
    private var details = [Detail]()
    
    //for orders on hold
    private var listForEditOrder = [[String:String]]()
    
    
    
    var orderID = ""
    var onHoldOrder = false
    
    
    @IBOutlet weak var deleteOrderBtn: UIButton!
    @IBOutlet weak var printInvoiceBtn: UIButton!
    @IBOutlet weak var kotBtn: UIButton!
    @IBOutlet weak var editOrderBtn: UIButton!
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var subtotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var serviceChargeLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    
    @IBAction func deleteOrderBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func printInvoiceBtn(_ sender: UIButton) {
    }
    
    @IBAction func kotBtn(_ sender: UIButton) {
        
        // Safe Push VC
        let viewController = UIStoryboard(name: "Outlet", bundle: nil).instantiateViewController(withIdentifier: "ShowInvoiceVC") as! SalesInvoiceViewController
        if let navigator = navigationController {
            viewController.orderID = orderID
            viewController.url = baseURLForKOT+orderID
            navigator.pushViewController(viewController, animated: true)
        }
        
        
        
    }
    
    @IBAction func editOrderBtn(_ sender: UIButton) {
        
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TOVC") as! TakeOrdersViewController
        if let navigator = navigationController {
            viewController.holdedMenu = true
            viewController.holdedFoods = listForEditOrder
            viewController.holdedOrderID = self.orderID
            navigator.pushViewController(viewController, animated: true)
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetails()
        showProgress()
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: "OrderListDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderListDetailsTableViewCell")
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = orderID
        
        
        if onHoldOrder{
            printInvoiceBtn.isHidden = true
            kotBtn.isHidden = true
        }else{
            deleteOrderBtn.isHidden = true
            editOrderBtn.isHidden = true
        }
    }
    

    private func getDetails(){
        if let outletID = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "orders_detail.php", params:["outlet_id":outletID,"token":apiToken,"order_id":orderID]) { (json, data) in
                
                do{
                    let detail = try JSONDecoder().decode(OrderListDetailsRoot.self, from: data)
                    
                    if detail.status == "1"{
                        for x in detail.data{
                            self.details.append(Detail( menu: x.menu, price: x.price, qty: x.qty, code: x.code, total: x.total))
                            
                            self.listForEditOrder.append(["code":x.code, "qty" : x.qty])
                        }
                    }else{
                        self.showErrorProgress(msg: detail.message)
                    }
                    self.dismissProgress()
                    self.tableView.reloadData()
                    self.subtotalLbl.text = detail.subtotal
                    self.discountLbl.text = detail.discount
                    self.gstLbl.text = detail.vatCharges
                    self.serviceChargeLbl.text = detail.delCharges
                    self.totalLbl.text = detail.grandTotal
                }catch{
                    print(error)
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListDetailsTableViewCell", for: indexPath) as! OrderListDetailsTableViewCell
        
        cell.itemLbl.text = details[indexPath.row].menu
        cell.priceLbl.text = details[indexPath.row].price
        cell.qtyLbl.text = details[indexPath.row].qty
        cell.totalLbl.text = details[indexPath.row].total
        
        return cell
    }
    
}
