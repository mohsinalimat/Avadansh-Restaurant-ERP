//
//  KitchenOrderDetailsViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 08/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import DatePickerDialog
import SwiftyJSON



class KitchenOrderDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var orderID = ""
    var timer = true
    
    private var selecteditems = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    private struct Detail{
        let items, name, qty, status: String
    }
    
    private var details = [Detail]()
    
    @IBOutlet weak var btnStack: UIStackView!
    
    @IBOutlet weak var cookBtn: UIButton!
    @IBAction func cookBtn(_ sender: UIButton) {
        
        setData(status: "1")
        
        
    }
    
    @IBAction func doneBtn(_ sender: UIButton) {
        
        setData(status: "2")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDetails()
        
        self.tableView.register(UINib(nibName: "KitchenOrderDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "KitchenOrderDetailsTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if !timer{
            let rightButtonItem = UIBarButtonItem(image: UIImage.init(named: "timer-icon"), style:.plain, target: self, action: #selector(self.rightButtonTapped))
            rightButtonItem.tintColor = UIColor.white
            self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButtonItem
            
        }
        self.navigationController?.navigationBar.topItem?.title = orderID
    }
    
    func getDetails(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "ord_det-kitchen.php", params: ["outlet_id":outlet,"token":apiToken,"order_id":orderID]) { (json, data) in
                do{
                    
                    self.details.removeAll()
                    let detail = try JSONDecoder().decode(KitchenOrdersDetailsRoot.self, from: data)
                    
                    if detail.status == "1"{
                        for x in detail.data{
                            for y in x.orderData{
                                self.details.append(Detail(items: y.items, name: y.name, qty: y.qty, status: y.status))
                            }
                        }
                    }else{
                        self.showErrorProgress(msg: detail.message)
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
        return details.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KitchenOrderDetailsTableViewCell", for: indexPath) as! KitchenOrderDetailsTableViewCell
        cell.codeLbl.text = details[indexPath.row].items
        cell.nameLbl.text = details[indexPath.row].name
        cell.qtyLbl.text = details[indexPath.row].qty
        
        if details[indexPath.row].status == "1"{
            cell.statusLbl.text = "Cooked"
            cell.statusLbl.textColor = UIColor.flatOrange()
        }else if details[indexPath.row].status == "2"{
            cell.statusLbl.text = "Item Ready"
            cell.statusLbl.textColor = UIColor.flatGreen()
        }else{
            cell.statusLbl.text = "Ready to Cook"
            cell.statusLbl.textColor = UIColor.flatRed()
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if details[indexPath.row].status != "1" && details[indexPath.row].status != "2"{
            selecteditems += 1
            hideStack()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if details[indexPath.row].status != "1" && details[indexPath.row].status != "2"{
            selecteditems -= 1
            hideStack()
        }
    }
    
    private func hideStack(){
        
        if selecteditems > 0{
            cookBtn.isHidden = false
        }else if selecteditems == 0{
            cookBtn.isHidden = true
        }
        
    }
    
    
    
    @objc private func rightButtonTapped(){
        let vc = TimerViewController()
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.orderID = self.orderID
        self.present(vc, animated: true, completion: nil)
    }
    
    
    private func setData(status : String){
        
        var menu = [String]()
        
        if status == "1"{
            if let selectedIndexPath = tableView.indexPathsForSelectedRows{
                
                for x in selectedIndexPath{
                    menu.append(details[x.row].items)
                }
                
            }
        }else if status == "2"{
            
            for x in details{
                menu.append(x.items)
            }
            
            
        }
        
        
        if let outlet = defaults.string(forKey: "outletID"){
            
            alamofireRequest(url: "set_kitchen_status.php", params: ["outlet_id":outlet,"token":apiToken,"order_id":orderID,"status":status,"menus": JSON(menu).rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.sortedKeys)!]) { (json, data) in
                
                if json["status"].stringValue == "1"{
                    self.showSuccessProgress(msg: json["message"].stringValue)
                    if status == "1"{
                        self.selecteditems = 0
                        self.hideStack()
                        self.getDetails()
                        self.showProgress()
                    }else if status == "2"{
                        self.goToPage(goto: "KO")
                    }
                }else{
                    self.showErrorProgress(msg: json["message"].stringValue)
                }
                
                
            }
        }
    }
    
}
