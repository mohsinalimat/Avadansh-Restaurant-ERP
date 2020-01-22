//
//  OrderListViewController.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.


import UIKit
import DropDown


class OrderListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var typeBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func typeBtn(_ sender: UIButton) {
        let dropDown = DropDown()
        
        dropDown.anchorView = typeBtn
        dropDown.dataSource = ["All Orders", "Dine In", "Take Away"]
        dropDown.show()
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
        
            self.typeBtn.setTitle(item, for: .normal)
            if index == 0{
                self.getList(type: "")
            }else if index == 1{
                self.getList(type: "D")
            }else if index == 2{
                self.getList(type: "T")
            }
            
        }
        
        
    }
    
    
    private struct OrderList{
        
        let orderID: String
        let table: String
        let orderType: String
        let time: String
        
        
    }
    
    
    private var orders = [OrderList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "OrdersListTableViewCell", bundle: nil), forCellReuseIdentifier: "OrdersListTableViewCell")
        
        getList(type : "")
        self.showProgress()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Order List"
    }
    
    
    private func getList(type : String){
        
        if let outletID = defaults.string(forKey: "outletID"){
            self.showProgress()
            alamofireRequest(url: "running_orders.php", params: ["outlet_id":outletID,"token":apiToken]) { (json, data) in
                do{
                    self.orders = [OrderList]()
                    let order = try JSONDecoder().decode(OrderListRoot.self, from: data)
                    
                    if order.status == "1"{
                        for x in order.data{
                            if type == ""{
                                self.orders.append(OrderList(orderID: x.orderID ?? "", table: x.table ?? "N/A", orderType: x.orderType ?? "", time: x.time ?? ""))
                            }else{
                                if x.orderType == type{
                                   self.orders.append(OrderList(orderID: x.orderID ?? "", table: x.table ?? "N/A", orderType: x.orderType ?? "", time: x.time ?? ""))
                                }
                            }
                            
                        }
                    }else{
                        self.showErrorProgress(msg: order.message)
                    }
                    self.dismissProgress()
                    self.tableView.reloadData()
                }catch{
                    print(error)
                }
            }
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersListTableViewCell", for: indexPath) as! OrdersListTableViewCell
        
        cell.expectedTimeLbl.text = orders[indexPath.row].time
        cell.orderIDLbl.text = orders[indexPath.row].orderID
        cell.tableNoLbl.text = orders[indexPath.row].table
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OLDVC") as! OrderListDetailsViewController
        if let navigator = navigationController {
            viewController.orderID = orders[indexPath.row].orderID
            navigator.pushViewController(viewController, animated: true)
        }
    }
    
    
}
