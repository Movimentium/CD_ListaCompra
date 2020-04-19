//
//  Persistator.swift
//  CD_ListaCompra
//
//  Created by Miguel on 19/04/2020.
//  Copyright © 2020 Miguel Gallego Martín. All rights reserved.
//

import Foundation
import CoreData

class Persistator {
    
    static let single = Persistator()
    
    private init() {
        print(#function)
    }
    
    private lazy var arrNombresArticulos:[String] = {
        print(#function)
        return obtenerNombresDeArticulos()
    }()
    
    var numeroDeArticulos: Int {
        return arrNombresArticulos.count
    }
    
    func nombreArticulo(at i:Int) -> String {
        return arrNombresArticulos[i]
    }
    
    func borrarArticulo(at i:Int) {
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Articulo")
        fr.predicate = NSPredicate(format: "nombre = %@", nombreArticulo(at: i))
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fr)
        do {
            try moctx.execute(batchDelete)
            arrNombresArticulos.remove(at: i)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func guardarArticulo(_ nombre:String) {
        let entity = NSEntityDescription.entity(forEntityName: "Articulo", in: moctx)!
        let articulo = NSManagedObject(entity: entity, insertInto: moctx)
        articulo.setValue(nombre, forKey: "nombre")
        saveContext()
        arrNombresArticulos.append(nombre)
    }
    
    private func obtenerNombresDeArticulos() -> [String] {
        var nombres: [String] = []
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Articulo")
        if let results:[Articulo] = try? moctx.fetch(fr) as? [Articulo], results.isEmpty == false {
            results.forEach { ($0.nombre != nil ? nombres.append($0.nombre!) : nil) }
        }
        return nombres
    }
    
    
    // MARK: - Core Data stack
    
    private lazy var moctx: NSManagedObjectContext = {
        print(#function)
        return persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        print(#function)
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CD_ListaCompra")
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
        if moctx.hasChanges {
            do {
                try moctx.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
}
