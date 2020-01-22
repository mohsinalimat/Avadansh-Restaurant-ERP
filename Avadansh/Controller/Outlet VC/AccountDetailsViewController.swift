//
//  AccountDetailsViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 17/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class AccountDetailsViewController: UIViewController, TwicketSegmentedControlDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    private var account : AccountRoot!
    
    private var details = "0"

    @IBOutlet weak var segmentControl: TwicketSegmentedControl!{
        didSet{
            let titles = ["Daily", "Monthly", "Total"]
            segmentControl.setSegmentItems(titles)
            segmentControl.sliderBackgroundColor = UIColor.init(hexString: "9EBFDC")
            
        }
    }
    @IBOutlet weak var totalSalesLbl: UILabel!
    @IBOutlet weak var totalExpenseLbl: UILabel!
    @IBOutlet weak var totalPurchaseLbl: UILabel!
    @IBOutlet weak var totalAccountLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgress()
        segmentControl.delegate = self
        getData()
        
        tableView.register(UINib(nibName: "AccountInformationTableViewCell", bundle: nil), forCellReuseIdentifier: "AccountInformationTableViewCell")
    }
    

    func didSelect(_ segmentIndex: Int) {
        details = String(segmentIndex)
        setData()
        
    }
    
    
    private func getData(){
        
        let outlet = defaults.string(forKey: "outletID") ?? ""
        
            alamofireRequest(url: "accounts.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.account = try JSONDecoder().decode(AccountRoot.self, from:data)
                    
                    if self.account.status == "1"{
                        
                        self.setData()
                        
                    }else{
                        
                        self.showErrorProgress(msg: self.account.message)
                    }
                    
                    self.dismissProgress()
                    
                    
                }catch{
                    print(error)
                    
                }
            }
        }
        
        
    private func setData(){
        
        if details == "0"{
            totalSalesLbl.text = account.data.currentDay.sales
            totalExpenseLbl.text = account.data.currentDay.expenses
            totalPurchaseLbl.text = account.data.currentDay.purchases
            totalAccountLbl.text = account.data.currentDay.totalAccount
        }else if details == "1"{
            totalSalesLbl.text = account.data.currentMonth.sales
            totalExpenseLbl.text = account.data.currentMonth.expenses
            totalPurchaseLbl.text = account.data.currentMonth.purchases
            totalAccountLbl.text = account.data.currentMonth.totalAccount
        }else if details == "2"{
            totalSalesLbl.text = account.data.total.sales
            totalExpenseLbl.text = account.data.total.expenses
            totalPurchaseLbl.text = account.data.total.purchases
            totalAccountLbl.text = account.data.total.totalAccount
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.reloadData()
        
    }
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountInformationTableViewCell", for: indexPath) as! AccountInformationTableViewCell
        
        if details == "0"{
            cell.sales.text = account.data.currentDay.sales
            cell.expense.text = account.data.currentDay.expenses
            cell.total.text = account.data.currentDay.purchases
            cell.sno.text = String(indexPath.row + 1)
        }else if details == "1"{
            cell.sales.text = account.data.currentMonth.sales
            cell.expense.text = account.data.currentMonth.expenses
            cell.total.text = account.data.currentMonth.purchases
            cell.sno.text = String(indexPath.row + 1)
        }else if details == "2"{
            cell.sales.text = account.data.total.sales
            cell.expense.text = account.data.total.expenses
            cell.total.text = account.data.total.purchases
            cell.sno.text = String(indexPath.row + 1)
        }
        
        return cell
    }
    
    
    
}
