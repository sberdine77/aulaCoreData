//
//  ViewController.swift
//  PersonFatherChildren
//
//  Created by Sávio Xavier on 06/04/18.
//  Copyright © 2018 Sávio Xavier. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var people: [NSManagedObject] = []
    var addresses: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //always need to be done
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let personEntity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
//        let addressEntity = NSEntityDescription.entity(forEntityName: "Address", in: managedContext)!
        
        //fetching entities
        people = fetch(entityName: "Person", managedContext: managedContext)
        self.addresses = fetch(entityName: "Address", managedContext: managedContext)
        
        //deleting entities
        deleteAll(objects: people, managedContext: managedContext)
        deleteAll(objects: addresses, managedContext: managedContext)
        
        //populating entities
        let person1 = NSManagedObject(entity: personEntity, insertInto: managedContext)
        person1.setValue("Cristina", forKey: "name")
        person1.setValue("Oliveira", forKey: "surname")
        person1.setValue(29, forKey: "age")
        
//        let address1 = NSManagedObject(entity: addressEntity, insertInto: managedContext)
//        address1.setValue("Brodway", forKey: "street")
//        address1.setValue("New York", forKey: "city")
        
        let person2 = NSManagedObject(entity: personEntity, insertInto: managedContext)
        person2.setValue("Joao", forKey: "name")
        person2.setValue("Oliveira", forKey: "surname")
        person2.setValue(27, forKey: "age")
        
        person1.setValue(person2, forKey: "spouse")
        
        let childPerson = NSManagedObject(entity: personEntity, insertInto: managedContext)
        childPerson.setValue("Luna", forKey: "name")
        childPerson.setValue("Oliveira", forKey: "surname")
        childPerson.setValue(5, forKey: "age")
        
        // Create Relationship
        let children = person2.mutableSetValue(forKey: "children")
        children.add(childPerson)
        
        let anotherChildPerson = NSManagedObject(entity: personEntity, insertInto: managedContext)
        anotherChildPerson.setValue("Lucy", forKey: "name")
        anotherChildPerson.setValue("Oliveira", forKey: "surname")
        anotherChildPerson.setValue(7, forKey: "age")
        
        // Create Relationship
        anotherChildPerson.setValue(person2, forKey: "father")
        
        //saving entities
        print(save(managedContext: managedContext))
        
        //fetching entities
        people = fetch(entityName: "Person", managedContext: managedContext)
        self.addresses = fetch(entityName: "Address", managedContext: managedContext)

        
        //fetching entities with descriptors
//        let sortByNameDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        people = fetchWithDescriptor(entityName: "Person", managedContext: managedContext, sortDescriptor: sortByNameDescriptor)
//        let sortByAgeDescriptor = NSSortDescriptor(key: "age", ascending: true)
//        people = fetchWithDescriptor(entityName: "Person", managedContext: managedContext, sortDescriptor: sortByAgeDescriptor)
        
        
//        fetching entities with predicates
//        let predicate1 = NSPredicate(format: "%K == %@", "first", "Lucy")
//        people = fetchWithPredicate(entityName: "Person", managedContext: managedContext, predicate: predicate1)
//        let predicate2 = NSPredicate(format: "%K <= %i", "age", 10)
//        people = fetchWithPredicate(entityName: "Person", managedContext: managedContext, predicate: predicate2)
        
        
        
        for person in people{
            if let name = person.value(forKey: "name"), let surname = person.value(forKey: "surname"){
                
                if let spouse = person.value(forKey: "spouse"){
                    let spouseTemp = spouse as! NSManagedObject
                    print("\(name) \(surname) spouse: \(String(describing: spouseTemp.value(forKey: "name")!)) \(String(describing: spouseTemp.value(forKey: "surname")!))")
                }else{
                   print("\(name) \(surname) spouse: None")
                }
            }
        }
        
        for address in self.addresses{
            if let street = address.value(forKey: "street"), let city = address.value(forKey: "city"){
                print("\(street) \(city)")
            }
        }
        
    }
    
    func deleteAll(objects: [NSManagedObject], managedContext: NSManagedObjectContext){
        for object in objects{
            managedContext.delete(object)
        }
        save(managedContext: managedContext)
    }
    
    func save(managedContext: NSManagedObjectContext) -> String{
        do {
            try managedContext.save()
            return "Saving successfull"
        } catch let error as NSError {
            return "Could not save. \(error) \(error.userInfo)"
        }

    }
    
    func fetch(entityName: String, managedContext: NSManagedObjectContext) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            print("Fetch successfull")
            return objects
        } catch let error as NSError {
            print("Could not fetch. Return value is []. \(error) \(error.userInfo)")
            return []
        }
        
    }
    
    func fetchWithDescriptor(entityName: String, managedContext: NSManagedObjectContext, sortDescriptor: NSSortDescriptor) -> [NSManagedObject]{
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            let objects = try managedContext.fetch(fetchRequest)
            print("Fetch successfull")
            return objects
        } catch let error as NSError {
            print("Could not fetch. Return value is []. \(error) \(error.userInfo)")
            return []
        }
    }
    
    func fetchWithPredicate(entityName: String, managedContext: NSManagedObjectContext, predicate: NSPredicate) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        fetchRequest.predicate = predicate
        do {
            let objects = try managedContext.fetch(fetchRequest)
            print("Fetch successfull")
            return objects
        } catch let error as NSError {
            print("Could not fetch. Return value is []. \(error) \(error.userInfo)")
            return []
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

