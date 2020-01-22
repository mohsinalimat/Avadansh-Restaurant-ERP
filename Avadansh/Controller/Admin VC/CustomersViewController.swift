//
//  CustomersViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 12/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class CustomersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var outletID = ""
    
    
    private struct Customer{
        
        let name, phone, email: String
        
    }
    
    private var customers = [Customer]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgress()
        
        getData()
        
        
        self.tableView.register(UINib(nibName: "RegisteredCustomersTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisteredCustomersTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    
    private func getData(){
        
            alamofireRequest(url: "outlet_customers.php", params: ["outlet_id":outletID,"token":apiToken]) { (json, data) in
                
                do{
                    
                    self.customers.removeAll()
                   let cust = try JSONDecoder().decode(CustomerRoot.self, from: data)
                    
                    if cust.status == "1"{
                        for x in cust.data{
                            self.customers.append(Customer(name: x.name, phone: x.phone, email: x.email))
                        }
                    }else{
                        self.showErrorProgress(msg: cust.message)
                    }
                    self.dismissProgress()
                    self.tableView.reloadData()
                }catch{
                    print(error)
                    
                }
            }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisteredCustomersTableViewCell", for: indexPath) as! RegisteredCustomersTableViewCell
        
        cell.name.text = customers[indexPath.row].name
        cell.phone.text = customers[indexPath.row].phone
        cell.email.text = customers[indexPath.row].email
        
        return cell
    }
    
    
}
