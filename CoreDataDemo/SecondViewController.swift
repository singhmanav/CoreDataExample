//
//  SecondViewController.swift
//  CoreDataDemo
//
//  Created by Manav on 22/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import UIKit
import CoreData
class SecondViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    var personToEdit: Person? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let person = personToEdit {
            nameTF.text = person.name
            self.title = "Edit Name"
        } else {
            self.title = "Add Name"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func save(_ sender: Any) {
        guard let nameToSave = nameTF.text, !nameToSave.isEmpty else {
            let alert = UIAlertController(title: "Input Error", message: "Name cannot be empty.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let person = personToEdit {
            // Edit mode
            do {
                try Database.DBinstance.updateName(for: person.objectID, with: nameToSave)
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error updating name: \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
                let alert = UIAlertController(title: "Error", message: "Failed to update name. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Add mode
            do {
                try Database.DBinstance.saveName(nameToSave)
                self.navigationController?.popViewController(animated: true)
            } catch {
                print("Error saving name: \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
                let alert = UIAlertController(title: "Error", message: "Failed to save name. Please ensure the input is valid and try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
