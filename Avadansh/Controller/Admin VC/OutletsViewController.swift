//
//  OutletsViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 12/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit

class OutletsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    private struct Outlets{
        
        let id, name, username, phone, address: String
        
    }
    
    private var outlets = [Outlets]()
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showProgress()
        
        getData()
        
        self.tableView.register(UINib(nibName: "OutletsListTableViewCell", bundle: nil), forCellReuseIdentifier: "OutletsListTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutletsListTableViewCell", for: indexPath) as! OutletsListTableViewCell
        
        cell.address.text = outlets[indexPath.row].address
        cell.name.text = outlets[indexPath.row].name
        cell.phone.text = outlets[indexPath.row].phone
        cell.username.text = outlets[indexPath.row].username
        
        return cell
    }
    
}
