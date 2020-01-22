//
//  WholeFoodMenuViewController.swift
//  Avadansh
//
//  Created by ASD Informatics on 15/07/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import Blueprints


class WholeFoodMenuViewController: UIViewController{
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.tableFooterView = UIView()
        }
    }
    
    
    private struct Menu{
        var brandID, catID, catName: String
        var catImage: String
    }
    
    private struct Food{
        var brandID, menuID, menuCatID, name: String
        var code, salesPrice, vegType: String
        var pic: String
        var incart : String
    }
    
    private struct FinalMenu{
        
        var menuID,menuName : String
        
        var foodItems : [Food]
        
    }
    
    
    private var foods = [Food]()
    private var menus = [Menu]()
    
    private var finalmenu = [FinalMenu]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getMenuData()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    
    private func getMenuData(){
        self.showProgress()
        if let brand = defaults.string(forKey: "brandID"){
            alamofireRequest(url: "menus.php", params: ["brand_id":brand,"token":apiToken]) { (json, data) in
                
                do{
                    self.menus = [Menu]()
                    
                    let menu = try JSONDecoder().decode(MenuRoot.self, from: data)
                    
                    if menu.status == "1"{
                        
                        for x in menu.data{
                            
                            self.menus.append(Menu(brandID: x.brandID, catID: x.catID, catName: x.catName, catImage: x.catImage))
                            
                        }
                        
                        
                        
                        
                        
                    }else{
                        self.showErrorProgress(msg: menu.message)
                    }
                    
                    self.getProducts()
                }catch{
                    print(error)
                }
            }
        }
        
        
        
        
    }
    
    
    private func getProducts(){
        self.showProgress()
        if let brand = defaults.string(forKey: "brandID"){
            //
            alamofireRequest(url: "food_items.php", params: ["brand_id":brand,"token":apiToken]) { (json, data) in
                do{
                    self.foods = [Food]()
                    
                    
                    let food = try JSONDecoder().decode(FoodMenuRoot.self, from: data)
                    
                    if food.status == "1"{
                        for x in food.data{
                            
                            self.foods.append(Food(brandID: x.brandID, menuID: x.menuID, menuCatID: x.menuCatID, name: x.name, code: x.code, salesPrice: x.salesPrice, vegType: x.vegType, pic: x.pic, incart: "0"))
                        }
                        
                        
                    }else{
                        self.showErrorProgress(msg: food.message)
                    }
                    
                    self.getData()
                    //                    self.tableView.reloadData()
                    
                }catch{
                    print(error)
                }
            }
        }
    }
    
    
    
    private func getData(){
        
        self.showProgress()
        
        finalmenu.removeAll()
        
        for x in menus{
            
            if x.catID != "All"{
                
            
            var foo = [Food]()
            
            for y in foods{
                
                    if x.catID == y.menuCatID{
                        foo.append(y)
                    }
                }
            
            self.finalmenu.append(FinalMenu(menuID: x.catID, menuName: x.catName, foodItems: foo))
            }
            
        }
        
        print(finalmenu)
        dismissProgress()
        self.tableView.reloadData()
        
    }
    
    
}

extension WholeFoodMenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return finalmenu.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
        
        let blueprintLayout = VerticalBlueprintLayout(
            itemsPerRow: 3.0,
            height: 180,
            minimumInteritemSpacing: 10,
            minimumLineSpacing: 10,
            sectionInset: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
            stickyHeaders: true,
            stickyFooters: false
        )
        
        
        let collectionView = UICollectionView(frame: cell.bounds, collectionViewLayout: blueprintLayout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.isScrollEnabled = false
        collectionView.tag = indexPath.section
        collectionView.register(UINib(nibName: "FoodCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCategoryCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cell.addSubview(collectionView)
        collectionView.reloadData()
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return finalmenu[section].menuName
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (finalmenu[indexPath.section].foodItems.count % 2) == 0{
            return CGFloat((finalmenu[indexPath.section].foodItems.count / 2) * 200)
        }else{
            return CGFloat(((finalmenu[indexPath.section].foodItems.count+1) / 2) * 200)
        }
    }
    
    
}


extension WholeFoodMenuViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return finalmenu[collectionView.tag].foodItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoryCollectionViewCell", for: indexPath) as! FoodCategoryCollectionViewCell
        
//        print(finalmenu[collectionView.tag].foodItems[indexPath.row])
        
        cell.imgView.sd_setImage(with: URL(string: finalmenu[collectionView.tag].foodItems[indexPath.row].pic.replacingOccurrences(of: " ", with: "%20")), completed: nil)
        
        cell.label.text = finalmenu[collectionView.tag].foodItems[indexPath.row].name
        
        return cell
    }
    
    
    
    
    
    
    
}
