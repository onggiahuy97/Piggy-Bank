//
//  PiggyBankApp.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/25/22.
//

import SwiftUI

@main
struct PiggyBankApp: App {
    @StateObject var dataController: DataController
    @StateObject var piggiesViewModel: PiggyViewModel
    
    init() {
        let dataController = DataController()
        let piggiesViewModel = PiggyViewModel(dataController: dataController)
        _dataController = StateObject(wrappedValue: dataController)
        _piggiesViewModel = StateObject(wrappedValue: piggiesViewModel)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(piggiesViewModel)
        }
    }
}
