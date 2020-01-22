//
//  SalesInvoiceViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 11/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import WebKit

class SalesInvoiceViewController: UIViewController{
   
   
    var orderID = ""
    var url = ""
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(orderID)
        
        guard let outlet = defaults.string(forKey: "outletID") else { return showErrorProgress(msg: "No oulet info found")}
        
        if url != ""{
            webView.load(URLRequest(url: URL(string: url+"&outlet_id=\(outlet)")!))
        }else{
            self.showErrorProgress(msg: "No Data Found")
        }
        
        // Do any additional setup after loading the view.
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.topItem?.title = orderID
    }
    

}
