//
//  PurchaseListViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class PurchaseListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    private struct List{
        let refNo, pdate, name, gtotal: String
        let paid, due: String
    }
    
    private var list = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        
        
        
        tableView.register(UINib(nibName: "PurchaseListTableViewCell", bundle: nil), forCellReuseIdentifier: "PurchaseListTableViewCell")
        
        // Do any additional setup after loading the view.
    }
    

    private func getData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "purchase_list.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.list.removeAll()
                    let list = try JSONDecoder().decode(PurchaseListRoot.self, from: data)
                    
                    if list.status == "1"{
                        for x in list.data{
                            
                            self.list.append(List(refNo: x.refNo, pdate: x.pdate, name: x.name, gtotal: x.gtotal, paid: x.paid, due: x.due))
                            
                            
                        }
                    }else{
                        self.showErrorProgress(msg: list.message)
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
        return list.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseListTableViewCell", for: indexPath) as! PurchaseListTableViewCell
        
        cell.dateLbl.text = list[indexPath.row].pdate
        cell.dueLbl.text = list[indexPath.row].due
        cell.paidLbl.text = list[indexPath.row].paid
        cell.refNoLbl.text = list[indexPath.row].refNo
        cell.supplierLbl.text = list[indexPath.row].name
        cell.totalLbl.text = list[indexPath.row].gtotal
        
        return cell
    }
    
    
    
}
