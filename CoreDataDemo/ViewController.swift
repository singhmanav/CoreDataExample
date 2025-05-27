//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Manav on 22/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var model = Model()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model.names = Database.DBinstance.fetchNames() // model.names is now [Person]
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return model.names.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = model.names[indexPath.row] // model.names is [Person]
        cell.textLabel?.text = person.name ?? "" // Access name property
        return cell
    }
}


extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removeAction = UITableViewRowAction(style: .destructive, title: "") { action, indexPath in
            do {
                try Database.DBinstance.deleteNames(withRow: indexPath.row)
                tableView.performBatchUpdates({
                    self.model.names.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .middle)
                }, completion: nil)
            } catch {
                print("Error deleting name: \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
                let alert = UIAlertController(title: "Error", message: "Failed to delete name. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let img: UIImage = UIImage(named: "remove")!
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContext(imgSize)
        img.draw(in: CGRect(x: 20, y: 7.5, width: 30, height: 30))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        removeAction.backgroundColor = UIColor(patternImage: newImage)
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            // NOTE: This assumes self.model.names is an array of Person objects.
            // This will be addressed when Model.swift and Database.swift fetch actual Person objects.
            // For now, to make it compile and to prepare for the actual object, we'd need to fetch the specific Person.
            // This part will require adjustment once the model provides Person objects.
            // For this step, we'll proceed with the assumption from the subtask.
            
            // To make this work with current model.names being [String], we would need to fetch the Person object differently.
            // However, following the subtask's temporary assumption for this step:
            // let person = self.model.names[indexPath.row] // This line would be Person if model.names was [Person]
            
            // Correct approach: Fetch the actual Person object from the database.
            // We need the actual Person objects to pass to SecondViewController.
            // This means `viewWillAppear` and `model.names` should be updated to hold `[Person]`.
            // For this specific step, we'll fetch it directly.
            // let allPersons = Database.DBinstance.fetchNames() // No longer needed, model.names is [Person]
            guard self.model.names.indices.contains(indexPath.row) else {
                print("Error: indexPath.row \(indexPath.row) is out of bounds for model.names with count \(self.model.names.count).")
                let alert = UIAlertController(title: "Error", message: "Could not find the item to edit.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            let personToEdit = self.model.names[indexPath.row] // Get Person from the model
                
            if let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController {
                    secondVC.personToEdit = personToEdit
                    self.navigationController?.pushViewController(secondVC, animated: true)
                } else {
                    print("Error: Could not instantiate SecondViewController. Check Storyboard ID.")
                    // Optionally, show an alert to the user
                    let alert = UIAlertController(title: "Navigation Error", message: "Could not open edit screen.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            // } else { // This else block for allPersons.indices.contains is no longer needed due to the guard
            //      print("Error: Selected row \(indexPath.row) is out of bounds for fetched persons.")
            //      let alert = UIAlertController(title: "Error", message: "Could not find the item to edit.", preferredStyle: .alert)
            //      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            //      self.present(alert, animated: true, completion: nil)
            // }
        }
        editAction.backgroundColor = .blue // Or any other color

        return [removeAction, editAction] // Or [editAction, removeAction] for different order
    }
    
     func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
     func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        model.moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}



extension ViewController: UITableViewDragDelegate{
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return model.dragItems(for: indexPath)
    }
}


extension ViewController:UITableViewDropDelegate{
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return model.canHandle(session)
    }
    
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destinationIndexPath: IndexPath
        
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let section = tableView.numberOfSections - 1
            let row = tableView.numberOfRows(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        coordinator.session.loadObjects(ofClass: NSString.self) { items in
            guard let stringItems = items as? [String] else {
                print("Error: Failed to load string items from drop session or items were not strings.")
                return
            }
            
            var indexPaths = [IndexPath]()
            for (index, item) in stringItems.enumerated() { // item is a String here
                do {
                    // saveName now returns the persisted Person object
                    let newPerson = try Database.DBinstance.saveName(item)
                    
                    let newIndexPath: IndexPath
                    if let destIndexPath = coordinator.destinationIndexPath {
                        newIndexPath = IndexPath(row: destIndexPath.row + index, section: destIndexPath.section)
                    } else {
                        // If no destinationIndexPath, add to the end of the last section
                        // This logic for 'row' ensures it's added after existing items if destIndexPath is nil
                        let section = tableView.numberOfSections > 0 ? tableView.numberOfSections - 1 : 0
                        let row = tableView.numberOfRows(inSection: section)
                        newIndexPath = IndexPath(row: row + index, section: section)
                    }
                    
                    // Ensure model.addItem is called with a valid index for the model's array
                    // If newIndexPath.row is based on tableView.numberOfRows, it should be correct for appending to model
                    self.model.addItem(newPerson, at: newIndexPath.row) // addItem in Model now takes a Person
                    indexPaths.append(newIndexPath)
                } catch {
                    print("Error saving dropped item \(item): \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
                    // Consider showing an alert to the user for the failed save
                     let alert = UIAlertController(title: "Save Error", message: "Could not save item: \(item)", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "OK", style: .default))
                     self.present(alert, animated: true)
                }
            }
            // Perform table view updates if any items were successfully added
            if !indexPaths.isEmpty {
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}
