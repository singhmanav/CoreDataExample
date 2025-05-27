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
    
    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
                throw error
            }
        }
    }
    
    
    func saveName(_ name:String) throws -> Person {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: persistentContainer.viewContext) as! Person
        person.name = name
        do {
            try saveContext()
            return person
        } catch {
            print("Error saving name (\(name)): \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
            throw error
        }
    }
    
    func fetchNames() -> [Person] {
        var names = [Person]()
        let namesFetch = NSFetchRequest<Person>(entityName: "Person")
        do {
            let fetchedNames = try persistentContainer.viewContext.fetch(namesFetch)
            names = fetchedNames.flatMap{ $0}
        } catch {
            print("Failed to fetch names: \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
            // Return an empty array in case of an error.
        }
        return names
    }
    
    func deleteNames(withRow:Int) throws {
        let namesFetch = NSFetchRequest<Person>(entityName: "Person")
        let context = persistentContainer.viewContext
        do {
            let fetchedNames = try context.fetch(namesFetch)
            if fetchedNames.indices.contains(withRow) {
                context.delete(fetchedNames[withRow])
                try context.save() // This save is specific to the delete operation
            } else {
                print("Error deleting name: index out of bounds \(withRow)")
                // Consider throwing a custom error here if appropriate
                // For now, just printing and not attempting to delete / save
                return // Or throw a specific error like AppError.indexOutOfBounds
            }
        } catch {
            print("Error deleting name at row \(withRow): \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
            throw error
        }
    }

    func updateName(for objectID: NSManagedObjectID, with newName: String) throws {
        let context = persistentContainer.viewContext
        do {
            guard let personToUpdate = try context.existingObject(with: objectID) as? Person else {
                // If existingObject(with:) returns nil (shouldn't happen if ID is valid but object deleted)
                // or if the cast to Person fails.
                print("Error: Could not find or cast Person object with ID \(objectID) for update.")
                throw NSError(domain: "Database", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Failed to find or cast Person object for update."])
            }
            
            personToUpdate.name = newName
            try saveContext() // Propagates errors from saveContext
            print("Successfully updated name for objectID: \(objectID) to '\(newName)'")
        } catch let error as NSError where error.domain == "Database" && error.code == 1001 {
            // Re-throw custom error if it's the one we created
            throw error
        } catch {
            // Handles errors from context.existingObject(with:) if it throws (e.g., invalid objectID)
            // or errors from saveContext()
            print("Error updating name for objectID \(objectID): \(error.localizedDescription), userInfo: \((error as NSError).userInfo)")
            throw error // Re-throw any other errors
        }
    }
}




