//
//  PiggyViewModel.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import SwiftUI
import CoreData

class PiggyViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let piggiesController: NSFetchedResultsController<Pig>
    
    @Published var filterType = FilterType.Now {
        didSet {
            
        }
    }
    @Published var piggies: [Pig] = []
    
    var dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
        
        let piggiesRequest: NSFetchRequest<Pig> = Pig.fetchRequest()
        piggiesRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Pig.createdDate, ascending: true)]
        
        piggiesController = NSFetchedResultsController(
            fetchRequest: piggiesRequest,
            managedObjectContext: dataController.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        super.init()
        
        piggiesController.delegate = self
        
        do {
            try piggiesController.performFetch()
            piggies = piggiesController.fetchedObjects ?? []
        } catch {
            print("Failed tof fetch initial data.")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        piggies = (piggiesController.fetchedObjects ?? []).sorted(by: { $0.createdDate! < $1.createdDate! })
    }
    
    func deleteAll() {
        piggies.forEach { pig in
            dataController.container.viewContext.delete(pig)
        }
        try? dataController.container.viewContext.save()
    }
}

extension PiggyViewModel {
    enum FilterType: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        
        case Now, Done, All, Deleted
        
        var label: (String, String) {
            switch self {
            case .Now: return ("Show Now", "circle.dashed")
            case .Done: return ("Show Completed", "eye")
            case .All: return ("Show All", "aqi.low")
            case .Deleted: return ("Show Deleted", "trash")
            }
        }
    }
}
