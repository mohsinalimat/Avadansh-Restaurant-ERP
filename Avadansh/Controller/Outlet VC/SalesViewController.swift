//
//  SalesViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit


class SalesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    private struct Sale{
        
        let orderID, orderType, ordDate: String
        let name: String
        let grandTotal: String
        let payMeth: String
        
    }
    
    private var sales = [Sale]()
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgress()
        getData()
        self.tableView.register(UINib(nibName: "SalesTableViewCell", bundle: nil), forCellReuseIdentifier: "SalesTableViewCell")
        // Do any additional setup after loading the view.
    }
    
    private func getData(){
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "sales.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.sales = [Sale]()
                    
                    let saleData = try JSONDecoder().decode(SalesRoot.self, from: data)
                    
                    if saleData.status == "1"{
                        print("hdfjkalksfj")
                        
                        for x in saleData.data{
                            self.sales.append(Sale(orderID: x.orderID, orderType: x.orderType, ordDate: x.ordDate, name: x.name ?? "N/A", grandTotal: x.grandTotal, payMeth: x.payMeth ?? "N/A"))
                        }
                        
                    }else{
                        self.showErrorProgress(msg: saleData.message)
                    }
                    self.dismissProgress()
                    self.tableView.reloadData()
//                    print(self.sales)
                }catch{
                    print(error)
                    
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesTableViewCell", for: indexPath) as! SalesTableViewCell
        
        cell.customerLbl.text = sales[indexPath.row].name
        cell.orderNoLbl.text = sales[indexPath.row].orderID
        cell.dateLbl.text = sales[indexPath.row].ordDate
        cell.totalAmountLbl.text = sales[indexPath.row].grandTotal
        cell.paymentMethod.text = sales[indexPath.row].payMeth
        cell.invoiceBtn.tag = indexPath.row
        cell.invoiceBtn.addTarget(self, action: #selector(self.invoiceBtnPressed(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func invoiceBtnPressed(_ sender: UIButton){
    
        // Safe Push VC
        let viewController = UIStoryboard(name: "Outlet", bundle: nil).instantiateViewController(withIdentifier: "ShowInvoiceVC") as! SalesInvoiceViewController
        if let navigator = navigationController {
            viewController.orderID = sales[sender.tag].orderID
            viewController.url = baseURLForInvoice+sales[sender.tag].orderID
            navigator.pushViewController(viewController, animated: true)
        }
        
    
    }
    

}



