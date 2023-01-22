//
//  ViewController.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENT
//
//  Created by Faiaz Rahman on 8/1/23.
//

import UIKit
import CoreData




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBarX: UISearchBar!
    @IBOutlet weak var tableViewX: UITableView!
    @IBOutlet weak var switchOutlet: UISwitch!
    
    @IBOutlet weak var topView: UIView!
  //  @IBOutlet weak var cellView: UIView!
    
    let defaults = UserDefaults.standard
    let context = CoreDataManager.shared.context
    var bandArray = [Bands]()
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "bandX.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBarX.delegate = self
        let mode = defaults.bool(forKey: "modeA")
         print(type(of: mode))
         print(defaults.bool(forKey: "modeA"))
         switchOutlet.isOn = mode
         changeBG(isOn: mode)
        
         print(switchOutlet.isOn)
        
        loadItems()

        tableViewX.dataSource = self
        tableViewX.delegate = self
        
        
    }
    
   func loadItems(){
       
       bandArray = CoreDataManager.shared.loadItemsFirstView()!
       DispatchQueue.main.async { [weak self] in
           guard let self = self else { return }
           self.tableViewX.reloadData()
       }

    }
    
    func saveItems(){

        CoreDataManager.shared.saveItemsFirstView()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableViewX.reloadData()
        }
    }
    
    func deleteItem(index : Int){
        context.delete(bandArray[index])
        bandArray.remove(at: index)
        saveItems()
    }
    
    func updateItem(index: Int){
        
        let temp = bandArray[index] // this is how new object need to create
        
        var nameTextField = UITextField()
        var albumTextField = UITextField()
     
        let alertAction = UIAlertController(title: "Want to Change?", message: "Edit Below", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Save Change", style: .default) { [self] (action) in
         
            if nameTextField.text != ""{
                temp.name = nameTextField.text
            }
            
            if albumTextField.text != ""{
                temp.album = albumTextField.text
            }

            saveItems()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = temp.name
            nameTextField = alertTextField
        }

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = temp.album
            albumTextField = alertTextField
        }
        
        alertAction.addAction(action)
        alertAction.addAction(cancel)
        
        present(alertAction, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bandArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewX.dequeueReusableCell(withIdentifier: "cellA", for: indexPath) as! cellA
        cell.name.text = bandArray[indexPath.row].name
        cell.album.text = bandArray[indexPath.row].album
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "way2", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ThirdVC

        if let indexPath = tableViewX.indexPathForSelectedRow {
            destinationVC.selectedBand = bandArray[indexPath.row]
        }
    }

    
    
    // Trailing Action Setup
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
            
            let deleteAction = UIContextualAction(style: .destructive, title: nil) {[weak self] _, _, completion in
                
                guard let self = self else {return}
                
                self.deleteItem(index: indexPath.row)
                completion(true)
            }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActions.performsFirstActionWithFullSwipe = true
            return swipeActions
            
        
        }
    
    
    // Leading Acton Setup
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let editAction = UIContextualAction(style: .normal, title: nil) {[weak self] _, _, completion in
            
            guard let self = self else {return}
            
            self.updateItem(index: indexPath.row)
            completion(true)
        }
        editAction.image = UIImage(systemName: "pencil.circle")
        editAction.backgroundColor = .blue
  
        let leadingSwipeActions = UISwipeActionsConfiguration(actions: [editAction])
        leadingSwipeActions.performsFirstActionWithFullSwipe = true
        return leadingSwipeActions
    }
    
    

    @IBAction func addItem(_ sender: Any) {
        //var textField = UITextField()
        var nameTextField = UITextField()
        var albumTextField = UITextField()
        
        let alertAction = UIAlertController(title: "Add New Album", message: "Musics are cool", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Album", style: .default) { [self] (action) in
            
            let temp = Bands(context: self.context) // this is how new object need to create
            temp.name = nameTextField.text!
            temp.album = albumTextField.text!
            
            
            self.bandArray.append(temp)
            
            //saveItems(temp : temp)
            saveItems() //no need to pass anything, already in context
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "Band Name"
            nameTextField = alertTextField
        }

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "Album Name"
            albumTextField = alertTextField
        }
        
        alertAction.addAction(action)
        alertAction.addAction(cancel)
        
        present(alertAction, animated: true, completion: nil)
        
    }
    
    func changeBG(isOn : Bool){
 
        
        
        if isOn {
            
            print("saved true")
            defaults.set(true, forKey: "modeA")
            defaults.synchronize()
            print(defaults.bool(forKey: "modeA"))
            topView.backgroundColor = #colorLiteral(red: 0, green: 0.3514339328, blue: 0.3315758109, alpha: 1)
            tableViewX.backgroundColor = #colorLiteral(red: 0.483435154, green: 0.6456826925, blue: 0.6149882674, alpha: 1)
        }
        else{
            
            defaults.set(false, forKey: "modeA")
            defaults.synchronize()
            print(defaults.bool(forKey: "modeA"))
            topView.backgroundColor = #colorLiteral(red: 0.3784818649, green: 0.02239910513, blue: 0.05380792171, alpha: 1)
            tableViewX.backgroundColor = #colorLiteral(red: 0.6351264119, green: 0.3076619506, blue: 0.3756330013, alpha: 1)

            print("saved false")
        }
        //tableViewX.reloadData()
    }
    
    @IBAction func switchAction(_ sender: Any) {
        if switchOutlet.isOn {
            changeBG(isOn: true)
        }
        else {
            changeBG(isOn: false)
        }
    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        
//        let request : NSFetchRequest<Bands> = Bands.fetchRequest()
//        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//        
//        do{
//          bandArray = try context.fetch(request)
//            DispatchQueue.main.async { [weak self] in
//                guard let self = self else { return }
//                self.tableViewX.reloadData()
//            }
//        }catch {
//            print("Error\(error)")
//        }
//        
//        tableViewX.reloadData()
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let request : NSFetchRequest<Bands> = Bands.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do{
          bandArray = try context.fetch(request)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableViewX.reloadData()
            }
        }catch {
            print("Error\(error)")
        }
        
        tableViewX.reloadData()
        
        if searchBarX.text!.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                self.searchBarX.resignFirstResponder()
            }
        }
    }
    
}

