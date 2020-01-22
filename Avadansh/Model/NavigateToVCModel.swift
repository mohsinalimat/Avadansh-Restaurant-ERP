//
//  NavigateToVCModel.swift
//  Avadansh
//
//  Created by Admin on 25/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    func goToPage(goto : String){
        
        
        switch goto{
        case "Home":
            presentVC( storyboard: "Main", goTo: goto)
        case "OO":
            segue(storyboard: "Main", goTo: goto)
        case "KO":
            presentVC( storyboard: "Kitchen", goTo: goto)
        case "OH":
            presentVC(storyboard: "Outlet", goTo: goto)
        case "ShowInvoice":
            segue(storyboard: "Outlet", goTo: goto)
        case "AH" :
            presentVC(storyboard: "Admin", goTo: goto)
            
        default:
            self.showInfoProgress(msg: "Sorry, This feature isn't available yet.")
            
        }
    }
    
    
    private func segue(storyboard: String, goTo:String){
        // Safe Push VC
        let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: goTo+"VC")
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
        
    }
    
    private func presentVC(storyboard: String, goTo:String){
         let viewController = UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: goTo+"VC")
        self.present(viewController, animated: true, completion: nil)
    }
}
