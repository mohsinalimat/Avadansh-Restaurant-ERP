//
//  InventoryViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    private struct Inventory{
        let ingredient, catName, qty, alertQty: String
    }
    
    
    private var inventory = [Inventory]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView() 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showProgress()
        getData()
        
        self.tableView.register(UINib(nibName: "InventoryTableViewCell", bundle: nil), forCellReuseIdentifier: "InventoryTableViewCell")
        // Do any additional setup after loading the view.
    }
    

    private func getData(){
        
        if let outlet = defaults.string(forKey: "outletID"){
            alamofireRequest(url: "inventory.php", params: ["outlet_id":outlet,"token":apiToken]) { (json, data) in
                
                do{
                    self.inventory.removeAll()
                    
                    let inven = try JSONDecoder().decode(InventoryRoot.self, from: data)
                    
                    if inven.status == "1"{
                        for x in inven.data{
                            self.inventory.append(Inventory(ingredient: x.ingredient, catName: x.catName, qty: x.qty, alertQty: x.alertQty))
                        }
                        
                    }else{
                        self.showErrorProgress(msg: inven.message)
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
        return inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryTableViewCell", for: indexPath) as!InventoryTableViewCell
        
        if let alert = inventory[indexPath.row].alertQty.split(separator: " ").first{
            if let alertQty = Int(alert){
                 if let quant = inventory[indexPath.row].qty.split(separator: " ").first{
                    if let qty = Int(quant){
                        
                        if qty < 0{
                            cell.stockQtyLbl.textColor = UIColor.flatRed()
                        }else{
                            if qty < alertQty{
                                cell.stockQtyLbl.textColor = UIColor.flatOrange()
                            }else{
                                cell.stockQtyLbl.textColor = UIColor.black
                            }
                        }
                        
                    }
                }
            }
            
        }
        
        
        
        cell.alertQtyLbl.text = inventory[indexPath.row].alertQty
        cell.categoryLbl.text = inventory[indexPath.row].catName
        
        
        cell.ingredientLbl.text = inventory[indexPath.row].ingredient
        cell.stockQtyLbl.text = inventory[indexPath.row].qty
        
        
        return cell
    }
    
    
    

}
