//
//  Database.swift
//  CoreDataDemo
//
//  Created by Manav on 22/08/17.
//  Copyright © 2017 Manav. All rights reserved.
//

import Foundation
import CoreData

class Database :NSObject{
    // MARK: - Core Data stack
    static let DBinstance = Database()
    
    private override init() {
        super.init()
        //ERROR: This prevents others from using the default '()' initializer for DBManager class.
    }
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func saveName(_ name:String) -> Void {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: persistentContainer.viewContext) as! Person
        person.name = name
        saveContext()
    }
    
    func fetchNames() -> [Person] {
        var names = [Person]()
        let namesFetch = NSFetchRequest<Person>(entityName: "Person")
        do {
            let fetchedNames = try persistentContainer.viewContext.fetch(namesFetch)
            names = fetchedNames.flatMap{ $0}
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
        return names
    }
    
    func deleteNames(withRow:Int) -> Void {
        let namesFetch = NSFetchRequest<Person>(entityName: "Person")
        do {
            let fetchedNames = try persistentContainer.viewContext.fetch(namesFetch)
            persistentContainer.viewContext.delete(fetchedNames[withRow])
                try persistentContainer.viewContext.save()
            
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
}




