//
//  ItemViewController.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 5/3/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var itemCount: UILabel!
    
    var groceryList: List!
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentOffset = CGPoint(x: 0, y: searchBar.frame.size.height)

        // Do any additional setup after loading the view.
        
        tableView.allowsSelection = false
        tableView.allowsMultipleSelectionDuringEditing = true
        
        prepareNavigationBar(.delete)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = groceryList.name
        print("Item")
        print(groceryList.creationDate)
        setupFetchedResultsController()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetchedResultsController = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupFetchedResultsController(){
        let fetchRequest:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "list == %@", groceryList)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "dateAdded", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "\(groceryList.creationDate!)items")
        
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Could not perform fetch")
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        
        if let deleteCount = tableView.indexPathsForSelectedRows?.count{
            if deleteCount > 0 {
                print("Got some")
            }
        }
    }
    
    private func addItem(item name: String){
        let item = Item(context: appDelegate.persistentContainer.viewContext)
        item.name = name
        item.list = groceryList
        appDelegate.saveContext()
        clearAfterAddItem()
    }
    
    @objc private func deleteItems(){
        if let indexPaths = tableView.indexPathsForSelectedRows{
            for indexPath in indexPaths{
                let item = fetchedResultsController.object(at: indexPath)
                appDelegate.persistentContainer.viewContext.delete(item)
                appDelegate.saveContext()
            }
        }
        
        disableEditMode()
        
    }
    
    private func clearAfterAddItem(){
        DispatchQueue.main.async {
            self.searchBar.text?.removeAll()
            //self.tableView.contentOffset = CGPoint(x: 0, y: self.searchBar.frame.size.height)
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    @objc private func setTableViewIntoEdit(){
        tableView.setEditing(true, animated: true)
        prepareNavigationBar(.cancel)
    }
    
    @objc func disableEditMode(){
        tableView.setEditing(false, animated: true)
        prepareNavigationBar(.delete)
    }
    
    func prepareNavigationBar(_ type: NavigationEnum, items: Int = 0) {
        
        var barItem: UIBarButtonItem!
        
        switch type{
        case .cancel:
            barItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(disableEditMode))
        case .delete:
            barItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(setTableViewIntoEdit))
        case .item:
            if items > 0 {
                barItem = UIBarButtonItem(title: "\(items) Items", style: .plain, target: self, action: #selector(deleteItems))
            }else{
                barItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(disableEditMode))
            }
        }
        
        navigationItem.rightBarButtonItem = barItem
    }
    
    
}

// TableView Data Methods

extension ItemViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemCount.text = "\(fetchedResultsController.sections?[section].numberOfObjects ?? 0)"
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let itemCell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") {
            
            let anItem = fetchedResultsController.object(at: indexPath)
            
            itemCell.textLabel?.text = anItem.name
            
            return itemCell
        }else{
            return UITableViewCell()
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return fetchedResultsController.sections?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .none:
            print(indexPath.row)
        default:()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing{
            let itemsToDelete = tableView.indexPathsForSelectedRows ?? []
        
            if itemsToDelete.count > 0{
                prepareNavigationBar(.item, items: itemsToDelete.count)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing{
            
            let itemsToDelete = tableView.indexPathsForSelectedRows ?? []
            
                prepareNavigationBar(.item, items: itemsToDelete.count)
            
            if itemsToDelete.count == 0{
                
                prepareNavigationBar(.cancel)
            }
            
        }
    }
    
}

//Search Bar Methods

extension ItemViewController: UISearchBarDelegate{
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        let result: Bool = (searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
        print(result)
        return !(searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty)!
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            addItem(item: text)
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if tableView.isEditing{
            tableView.setEditing(false, animated: true)
        }
        
        return true
    }
    
}

// Core Data Methods

extension ItemViewController{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .right)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}


