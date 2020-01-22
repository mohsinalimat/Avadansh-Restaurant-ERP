//
//  Last10OrdersViewController.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class Last10OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private struct Order{
        let orderID, name, subtotal, discount: String
        let vatCharges, delCharges, grandTotal, ordDate: String
    }
    
    private var orders = [Order]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.showProgress()
        getData()
        
        self.tableView.register(UINib(nibName: "Last10OrdersTableViewCell", bundle: nil), forCellReuseIdentifier: "Last10OrdersTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = "Last 10 Orders"
    }
    
    private func getData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "last_ten_sales.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.orders = [Order]()
                    let last = try JSONDecoder().decode(Last10OrderRoot.self, from: data)
                    
                    if last.status == "1"{
                        for x in last.data{
                            self.orders.append(Order(orderID: x.orderID, name: x.name, subtotal: x.subtotal, discount: x.discount, vatCharges: x.vatCharges, delCharges: x.delCharges, grandTotal: x.grandTotal, ordDate: x.ordDate))
                        }
                    }else{
                        self.showErrorProgress(msg: last.message)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Last10OrdersTableViewCell", for: indexPath) as! Last10OrdersTableViewCell
        
        cell.orderIDLbl.text = orders[indexPath.row].orderID
        cell.custLbl.text = orders[indexPath.row].name
        cell.subTotalLbl.text = orders[indexPath.row].subtotal
        cell.discLbl.text = orders[indexPath.row].discount
        cell.vatLbl.text = orders[indexPath.row].vatCharges
        cell.deliveryLbl.text = orders[indexPath.row].delCharges
        cell.grandTotalLbl.text = orders[indexPath.row].grandTotal
        cell.dateLbl.text = orders[indexPath.row].ordDate
        
        
        return cell
    }
    
    
}
