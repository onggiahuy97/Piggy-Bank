//
//  DataController.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/25/22.
//

import CoreData

class DataController: ObservableObject {
    static let shared = DataController()
    
    init() {}
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Main")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistant stores \(error.localizedDescription)")
            }
        }
        return container
    }()
    
}
