//
//  TakeOrdersViewController.swift
//  Avadansh
//
//  Created by Admin on 26/06/19.
//  Copyright © 2019 Indian Smart Hub. All rights reserved.
//

import UIKit
import Blueprints
import SDWebImage
import DropDown


struct Food{
    var brandID, menuID, menuCatID, name: String
    var code, salesPrice, vegType: String
    var pic: String
    var incart : String
}


class TakeOrdersViewController: UIViewController{
    
    var holdedMenu = false
    var holdedFoods = [[String:String]]()
    var holdedOrderID = ""
    
    static var foods = [Food]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    private var rightButtonItem : UIBarButtonItem!
    
    private var selectedIndex = 0
    
    
    private struct Menu{
        var brandID, catID, catName: String
        var catImage: String
    }
    
    
    private var flag = false
    
    private var menus = [Menu]()
    
    private var filteredFoods = [Food]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //        searchBar.delegate = self
        //        self.searchBar.showsCancelButton = false
        
        getMenuData()
        
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: "Collection2TableViewCell", bundle: nil), forCellReuseIdentifier: "Collection2TableViewCell")
        
        self.tableView.register(UINib(nibName: "CollectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CollectionTableViewCell")
        
        //        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setNavBarIcon()
        
        if flag{
            
            selectedIndex = 0
            filteredFoods.removeAll()
            filteredFoods = TakeOrdersViewController.foods
            
            //            let cell0 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! Collection2TableViewCell
            let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CollectionTableViewCell
            
            self.tableView.beginUpdates()
            
            
            //            cell0.collectionView.reloadData()
            cell1.collectionView.reloadData()
            
            
            self.tableView.reloadData()
            self.tableView.endUpdates()
            //            self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: UITableView.RowAnimation.automatic)
        }
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
                    TakeOrdersViewController.foods = [Food]()
                    self.filteredFoods = [Food]()
                    
                    let food = try JSONDecoder().decode(FoodMenuRoot.self, from: data)
                    
                    if food.status == "1"{
                        for x in food.data{
                            
                            TakeOrdersViewController.foods.append(Food(brandID: x.brandID, menuID: x.menuID, menuCatID: x.menuCatID, name: x.name, code: x.code, salesPrice: x.salesPrice, vegType: x.vegType, pic: x.pic, incart: "0"))
                        }
                        
                        
                        if !self.holdedFoods.isEmpty{
                            for x in 0..<TakeOrdersViewController.foods.count{
                                for y in self.holdedFoods{
                                    if y["code"] == TakeOrdersViewController.foods[x].code{
                                        TakeOrdersViewController.foods[x].incart = y["qty"]!
                                        print(TakeOrdersViewController.foods[x])
                                    }
                                }
                            }
                            
                        }
                        
                    }else{
                        self.showErrorProgress(msg: food.message)
                    }
                    
                    self.filteredFoods = TakeOrdersViewController.foods
                    self.tableView.reloadData()
                    self.dismissProgress()
                }catch{
                    print(error)
                }
            }
        }
    }
    
    
}






extension TakeOrdersViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
            
        case 0 : let cell = tableView.dequeueReusableCell(withIdentifier: "Collection2TableViewCell", for: indexPath) as! Collection2TableViewCell
        
        cell.collectionView.collectionViewLayout = HorizontalBlueprintLayout(
            itemsPerRow: 3.0,
            itemsPerColumn: 1,
            height: 140,
            minimumInteritemSpacing: 5,
            minimumLineSpacing: 5,
            sectionInset: EdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
            stickyHeaders: true,
            stickyFooters: true
        )
        
        cell.collectionView.showsHorizontalScrollIndicator = false
        cell.collectionView.showsVerticalScrollIndicator = false
        
        cell.collectionView.register(UINib(nibName: "HomeMenusCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeMenusCollectionViewCell")
        cell.collectionView.tag = indexPath.section
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.isPagingEnabled = true
        cell.collectionView.backgroundColor = UIColor.clear
        
        
        
        
        
        return cell
            
        default : let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell
        
        cell.collectionView.collectionViewLayout = VerticalBlueprintLayout(
            itemsPerRow: 2.0,
            height: 280,
            minimumInteritemSpacing: 5,
            minimumLineSpacing: 5,
            sectionInset: EdgeInsets(top: 5, left: 5, bottom: 5, right: 5),
            stickyHeaders: true,
            stickyFooters: true
        )
        
        cell.collectionView.register(UINib(nibName: "HomeFoodCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeFoodCollectionViewCell")
        
        cell.collectionView.tag = indexPath.section
        cell.collectionView.isScrollEnabled = false
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.backgroundColor = UIColor.flatWhite()
        
        
        return cell
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0 : return 151
        default : if (filteredFoods.count % 2) == 0{
            return CGFloat((filteredFoods.count / 2) * 290)
        }else{
            return CGFloat(((filteredFoods.count+1) / 2) * 290)
            }
            
        }
    }
    
}

extension TakeOrdersViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
            
        case 0 : return menus.count
        default : return filteredFoods.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag{
            
        case 0 : let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMenusCollectionViewCell", for: indexPath) as! HomeMenusCollectionViewCell
        
        cell.imgview.sd_setImage(with: URL(string: menus[indexPath.row].catImage), completed: nil)
        
        cell.titleLbl.text = menus[indexPath.row].catName
        return cell
            
        default : let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeFoodCollectionViewCell", for: indexPath) as! HomeFoodCollectionViewCell
        
        if filteredFoods[indexPath.row].vegType == "N"{
            cell.foodTypeView.backgroundColor = UIColor.flatRed()
        }else if filteredFoods[indexPath.row].vegType == "V"{
            cell.foodTypeView.backgroundColor = UIColor.flatGreen()
        }
        
        cell.imgView.sd_setImage(with: URL(string: filteredFoods[indexPath.row].pic.replacingOccurrences(of: " ", with: "%20")), completed: nil)
        
        cell.nameLbl.text = "\(filteredFoods[indexPath.row].name) \n₹\(filteredFoods[indexPath.row].salesPrice)/-"
        
        cell.addBtn.tag = indexPath.row
        cell.addBtn.addTarget(self, action: #selector(self.addBtnPressed(_:)), for: .touchUpInside)
        
        cell.qtyBtn.tag = indexPath.row
        cell.qtyBtn.addTarget(self, action: #selector(self.qtyBtnPressed(_:)), for: .touchUpInside)
        cell.qtyBtn.setTitle(filteredFoods[indexPath.row].incart+" ▼", for: .normal)
        
        
        if filteredFoods[indexPath.row].incart != "0" {
            cell.addBtn.isHidden = true
            cell.qtyBtn.isHidden = false
        }else{
            cell.addBtn.isHidden = false
            cell.qtyBtn.isHidden = true
        }
        return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row{
            selectedIndex = indexPath.row
            
            if collectionView.tag == 0{
               
                print(menus[indexPath.row].catID)
                
                if menus[indexPath.row].catID == "All"{
                    filteredFoods.removeAll()
                    filteredFoods = TakeOrdersViewController.foods
                    reloadTableSections()
                }else{
                    
                    filteredFoods.removeAll()
                    
                    for x in TakeOrdersViewController.foods{
                        if x.menuCatID == menus[indexPath.row].catID{
                            
                            filteredFoods.append(x)
                        }
                        
                        
                    }
                    
                    reloadTableSections()
                }
                
                print(filteredFoods)
            }
        }
    }
    
}



extension TakeOrdersViewController{
    
    @objc private func addBtnPressed(_ sender: UIButton){
        
        print(sender.tag)
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CollectionTableViewCell
        
        self.filteredFoods[sender.tag].incart = "1"
        for x in 0...TakeOrdersViewController.foods.count-1{
            if TakeOrdersViewController.foods[x].menuID == self.filteredFoods[sender.tag].menuID{
                TakeOrdersViewController.foods[x].incart = "1"
            }
        }
        
        cell.collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
        //                reloadTableSections()
        
        
    }
    
    
    @objc private func qtyBtnPressed(_ sender: UIButton){
        let dropDown = DropDown()
        
        dropDown.anchorView = sender
        dropDown.dataSource = ["0","1","2","3","4","5","6","7","8","9","10"]
        dropDown.show()
        dropDown.direction = .any
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CollectionTableViewCell
            
            self.filteredFoods[sender.tag].incart = item
            
            for x in 0...TakeOrdersViewController.foods.count-1{
                if TakeOrdersViewController.foods[x].menuID == self.filteredFoods[sender.tag].menuID{
                    TakeOrdersViewController.foods[x].incart = item
                }
            }
            
            cell.collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
            
        }
        
    }
    
    
    private func reloadTableSections(){
        //        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! CollectionTableViewCell
        
        cell.collectionView.reloadData()
        
        
        self.tableView.reloadData()
        self.tableView.endUpdates()
    }
    
    
    
    
    
}


extension TakeOrdersViewController :  UISearchBarDelegate{
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0{
            selectedIndex = 0
            
            filteredFoods = TakeOrdersViewController.foods
            print(filteredFoods)
            reloadTableSections()
        }
        
        self.dismissKeyboard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredFoods.removeAll()
        
        
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        
        selectedIndex = 0
        
        filteredFoods = TakeOrdersViewController.foods
        print(filteredFoods)
        reloadTableSections()
    }
    //
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        print(searchText.count)
        
        filteredFoods.removeAll()
        
        for x in TakeOrdersViewController.foods{
            if x.name.contains(searchText) {
                filteredFoods.append(x)
            }
        }
        reloadTableSections()
    }
    
    
    
}


extension TakeOrdersViewController{
    
    
    private func setNavBarIcon(){
        
        
        rightButtonItem = UIBarButtonItem(image: UIImage.init(named: "meal-icon"), style:.plain, target: self, action: #selector(self.rightButtonTapped))
        rightButtonItem.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = rightButtonItem
        //    self.navigationController?.navigationItem.rightBarButtonItem = rightButtonItem
        
        
        
        
    }
    
    
    
    @objc func rightButtonTapped(){
        
        // Safe Push VC
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OOVC") as! OrderOverviewViewController
        if let navigator = navigationController {
            viewController.holdedOrderID = self.holdedOrderID
            navigator.pushViewController(viewController, animated: true)
        }
        self.flag = true
    }
    
    
}


