//
//  ThirdVC.swift
//  faiaz_rahman_30024_LOCAL_PERSISTENT
//
//  Created by Faiaz Rahman on 9/1/23.
//

import UIKit
import CoreData

class ThirdVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var tableViewY: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var songArray = [Songs]()
    
    var selectedBand : Bands? {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewY.dataSource = self
        tableViewY.delegate = self
        
        loadItems()

        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewY.dequeueReusableCell(withIdentifier: "cellB", for: indexPath) as! cellB
        cell.songName.text = songArray[indexPath.row].trackName
        
        return cell

    }
    
    func loadItems(){
        
        songArray = CoreDataManager.shared.loadItemsThirdVC(albumName: selectedBand!.name!)!

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableViewY.reloadData()
        }
     }
     
     func saveItems(){

         CoreDataManager.shared.saveItemsThirdVC()
         
         DispatchQueue.main.async { [weak self] in
             guard let self = self else { return }
             self.tableViewY.reloadData()
         }
         
     }
    
    @IBAction func addSong(_ sender: Any) {
        var trackTextField = UITextField()
        
        
        let alertAction = UIAlertController(title: "Add New Song", message: "Musics are cool", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add track", style: .default) { [self] (action) in
            
            let temp = Songs(context: self.context) // this is how new object need to create
            temp.trackName = trackTextField.text!
            temp.parent = self.selectedBand
            self.songArray.append(temp)
            
            //saveItems(temp : temp)
            saveItems() //no need to pass anything, already in context
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alertAction.addTextField { (alertTextField) in
            alertTextField.placeholder = "Song Name"
            trackTextField = alertTextField
        }

        alertAction.addAction(action)
        alertAction.addAction(cancel)
        
        present(alertAction, animated: true, completion: nil)
    }
}

