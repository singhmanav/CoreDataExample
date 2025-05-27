//
//  Dragging.swift
//  CoreDataDemo
//
//  Created by Manav on 23/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData // Required for Person type

class Model {
    var names = [Person]() // Changed from [String] to [Person]
    
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard names.indices.contains(sourceIndex) else {
            print("Error: sourceIndex \(sourceIndex) is out of bounds for names array with count \(names.count).")
            return
        }
        // Allow inserting at the end (index == names.count)
        guard names.indices.contains(destinationIndex) || destinationIndex == names.count else {
            print("Error: destinationIndex \(destinationIndex) is out of bounds for names array with count \(names.count).")
            return
        }
        guard sourceIndex != destinationIndex else { return }
        
        let person = names[sourceIndex] // Now a Person object
        names.remove(at: sourceIndex)
        names.insert(person, at: destinationIndex) // Inserting a Person object
    }
    
    func addItem(_ person: Person, at index: Int) { // Changed from name: String to person: Person
        guard index >= 0 && index <= names.count else {
            print("Error: index \(index) is out of bounds for insertion into names array with count \(names.count).")
            return
        }
        names.insert(person, at: index) // Inserting a Person object
    }
}

extension Model {
    
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        guard names.indices.contains(indexPath.row) else {
            print("Error: indexPath.row \(indexPath.row) is out of bounds for names array with count \(names.count).")
            return []
        }
        let person = names[indexPath.row] // person is a Person object
        let nameString = person.name ?? "" // Use person's name, default to empty string if nil
        
        guard let data = nameString.data(using: .utf8) else {
            print("Error: Could not convert name to UTF8 data for name: \(nameString)")
            return []
        }
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
}

