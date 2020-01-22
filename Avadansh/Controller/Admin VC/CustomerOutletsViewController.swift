//
//  CustomerOutletsViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 15/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class CustomerOutletsCell : UITableViewCell{
    
    @IBOutlet weak var outletLbl: UILabel!
    
    
}


class CustomerOutletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private var selectedCustID = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    {
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    private struct Outlets{
        
        let id, name, username, phone, address: String
        
    }
    
    private var outlets = [Outlets]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showProgress()
        getData()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

    private func getData(){
        
        if let brand = defaults.string(forKey: "brandID"){
            alamofireRequest(url: "outlet_list.php", params: ["brand_id":brand,"token":apiToken]) { (json, data) in
                
                do{
                    self.outlets.removeAll()
                    
                    let out = try JSONDecoder().decode(OutletListRoot.self, from: data)
                    
                    
                    if out.status == "1"{
                        for x in out.data{
                            self.outlets.append(Outlets(id: x.id, name:x.name, username: x.username, phone: x.phone, address: x.address))
                        }
                        
                    }else{
                        self.showErrorProgress(msg: out.message)
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
        return outlets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "oCell", for: indexPath) as! CustomerOutletsCell
        
        cell.outletLbl.text = outlets[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCustID = outlets[indexPath.row].id
        performSegue(withIdentifier: "goToCustList", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCustList"{
            let vc = segue.destination as! CustomersViewController
            vc.outletID = selectedCustID
            
        }
    }
    
}
