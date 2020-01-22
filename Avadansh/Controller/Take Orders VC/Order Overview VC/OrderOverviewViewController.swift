//
//  OrderOverviewViewController.swift
//  Avadansh
//
//  Created by Admin on 29/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import DropDown

class OrderOverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var holdedOrderID = ""
    
    
    
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    private var overview = [Food]()
    
    @IBAction func dineInBtn(_ sender: UIButton) {
        
        
        self.showPopUp(type: "D")
    }
    
    @IBAction func takeAwayBtn(_ sender: UIButton) {
        
        self.showPopUp(type: "T")
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.tableFooterView = UIView()
        getRefreshedData()
        
        self.tableView.register(UINib(nibName: "OrderOverviewTableViewCell", bundle: nil), forCellReuseIdentifier: "OrderOverviewTableViewCell")
        
    }
    
    
    
    
    private func getRefreshedData(){
        overview = [Food]()
        
        var total = 0
        for x in TakeOrdersViewController.foods{
            if x.incart != "0"{
                total += (Int(x.salesPrice)! * Int(x.incart)!)
                overview.append(x)
            }
        }
        
       
        self.totalLbl.text = "Total : \(total)"
       self.tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return overview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderOverviewTableViewCell", for: indexPath) as! OrderOverviewTableViewCell
        
        cell.nameLbl.text = overview[indexPath.row].name
        cell.imgView.sd_setImage(with: URL(string: overview[indexPath.row].pic), completed: nil)
        
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(self.deleteBtnPressed(_:)), for: .touchUpInside)
        
        cell.qtyBtn.tag = indexPath.row
        cell.qtyBtn.addTarget(self, action: #selector(self.qtyBtnPressed(_:)), for: .touchUpInside)
        cell.qtyBtn.setTitle(overview[indexPath.row].incart+" ▼", for: .normal)
        
        return cell
    }
    
    
    @objc private func deleteBtnPressed(_ sender: UIButton){
        
        for x in 0...TakeOrdersViewController.foods.count-1{
            if TakeOrdersViewController.foods[x].menuID == self.overview[sender.tag].menuID{
                TakeOrdersViewController.foods[x].incart = "0"
            }
        }
        getRefreshedData()
    }
    
    
    @objc private func qtyBtnPressed(_ sender: UIButton){
        
        let dropDown = DropDown()
        
        dropDown.anchorView = sender
        dropDown.dataSource = ["1","2","3","4","5","6","7","8","9","10"]
        dropDown.show()
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            
            self.overview[sender.tag].incart = item
            
            for x in 0...TakeOrdersViewController.foods.count-1{
                if TakeOrdersViewController.foods[x].menuID == self.overview[sender.tag].menuID{
                    TakeOrdersViewController.foods[x].incart = item
                }
            }
            
            self.tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: UITableView.RowAnimation.automatic)
            
        }
    }
    
    
    
    private func showPopUp(type : String){
        
        let vc = CheckoutViewController()
        
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.popupType = type
        vc.finalorder = self.overview
        vc.orderID = self.holdedOrderID
        self.present(vc, animated: true, completion: nil)
        
        
        
        
    }
    
}
