//
//  Dragging.swift
//  CoreDataDemo
//
//  Created by Manav on 23/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import UIKit
import MobileCoreServices

class Model {
    var names = [String]()
    
    func moveItem(at sourceIndex: Int, to destinationIndex: Int) {
        guard names.indices.contains(sourceIndex) else {
            print("Error: sourceIndex \(sourceIndex) is out of bounds for names array with count \(names.count).")
            return
        }
        guard names.indices.contains(destinationIndex) || destinationIndex == names.count else { // Allow inserting at the end
            print("Error: destinationIndex \(destinationIndex) is out of bounds for names array with count \(names.count).")
            return
        }
        guard sourceIndex != destinationIndex else { return }
        
        let name = names[sourceIndex]
        names.remove(at: sourceIndex)
        names.insert(name, at: destinationIndex)
    }
    
    func addItem(_ name: String, at index: Int) {
        guard index >= 0 && index <= names.count else {
            print("Error: index \(index) is out of bounds for insertion into names array with count \(names.count).")
            return
        }
        names.insert(name, at: index)
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
        let name = names[indexPath.row]
        
        guard let data = name.data(using: .utf8) else {
            print("Error: Could not convert name to UTF8 data for name: \(name)")
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

