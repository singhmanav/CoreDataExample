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
        guard sourceIndex != destinationIndex else { return }
        
        let name = names[sourceIndex]
        names.remove(at: sourceIndex)
        names.insert(name, at: destinationIndex)
    }
    func addItem(_ name: String, at index: Int) {
        names.insert(name, at: index)
    }
}

extension Model {
    
    func canHandle(_ session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    func dragItems(for indexPath: IndexPath) -> [UIDragItem] {
        let name = names[indexPath.row]
        
        let data = name.data(using: .utf8)
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

