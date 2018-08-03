//
//  ViewController.swift
//  ShoppingList
//
//  Created by Royce Reynolds on 5/1/18.
//  Copyright © 2018 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController, NSFetchedResultsControllerDelegate{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var fetchedResultsController: NSFetchedResultsController<List>!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFetchedResultsController()
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //fetchedResultsController = nil
    }

    private func setupFetchedResultsController(){
        let fetchRequest:NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Lists")
        
        fetchedResultsController.delegate = self
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            fatalError("Could not perform fetch")
        }
    }
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    func deleteGroceryList(at indexPath: IndexPath){
        let deletedGroceryList = fetchedResultsController.object(at: indexPath)
        appDelegate.persistentContainer.viewContext.delete(deletedGroceryList)
        appDelegate.saveContext()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if segue.identifier == "itemSegue"{
            if let item = segue.destination as? ItemViewController{
                if let indexPath = tableView.indexPathForSelectedRow{
                    print(indexPath.row)
                    item.groceryList = fetchedResultsController.object(at: indexPath)
                    fetchedResultsController = nil
                }
            }
        }else if segue.identifier == "nameList"{
            if let vc = segue.destination as? ItemNameViewController{
                vc.delegate = self
            }
        }
    }
    

}

extension ListViewController: AddItemDelegate{
    
    func addGroceryList(name: String) {
        
        print("made it to add grocerylist")
        let list = List(context: appDelegate.persistentContainer.viewContext)
        list.name = name
        appDelegate.saveContext()
        //tableView.reloadData()
        
    }
    
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell {
            //cell.listName.delegate = self
            let aGroceryList = fetchedResultsController.object(at: indexPath)
            //print(aGroceryList.name)
            cell.listName.text = aGroceryList.name
            print("List")
            //print(aGroceryList.creationDate)
            
            if let itemCount = aGroceryList.items?.count{
                cell.itemCount.text = "\(itemCount)"
            }
            return cell
        }else{
            return UITableViewCell()
        }
        //return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            
            print("Thanks")
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .delete
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle{
        case .delete:
            deleteGroceryList(at: indexPath)
        default: ()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        //addGroceryList()
    }
    
}


extension ListViewController{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .right)
            tableView.selectRow(at: newIndexPath!, animated: true, scrollPosition: .top)
            //performSegue(withIdentifier: "itemSegue", sender: self)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        default:
            break
        }
    }
}
