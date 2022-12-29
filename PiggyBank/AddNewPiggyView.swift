//
//  AddNewPiggyView.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import SwiftUI
import Combine

struct AddNewPiggyView: View {
    
    @Environment(\.managedObjectContext) var viewContext
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var url = ""
    @State private var amount = ""
    @State private var saving = ""
    @State private var dateCreated = Date()
    @State private var dueDate = Date()
    @State private var image: UIImage?
    
    @State private var showErrorMessage = false
    @State private var errorTextMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("Give a piggy name", text: $name)
                    TextField("URL?", text: $url)
                }
                
                Section("Price") {
                    TextField("Total Amount", text: $amount)
                        .keyboardType(.numberPad)
                    TextField("Saving Amount", text: $saving)
                        .keyboardType(.numberPad)
                }
                
                Section("Date") {
                    DatePicker("Date Created", selection: $dateCreated, displayedComponents: [.date])
                    DatePicker("Date Goal", selection: $dueDate, displayedComponents: [.date])
                }
                
                Section("Photo") {
                    PhotoPicker(inputSource: $image)
                }
            }
            .navigationTitle("New Saving!!!")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: savePiggy)
                    .buttonStyle(.borderedProminent)
                }
            }
            .onReceive(Just(errorTextMessage)) { newError in
                if !newError.isEmpty {
                    self.errorTextMessage = newError
                    self.showErrorMessage = true
                }
            }
            .alert(errorTextMessage, isPresented: $showErrorMessage) {
                Button("OK") {}
            }
        }
    }
    
    private func savePiggy() {
        
        guard !name.isEmpty else {
            self.errorTextMessage = "Name is empty"
            return
        }
        
        guard let amount = Double(amount), amount != 0 else {
            self.errorTextMessage = "Total amount is not valid!"
            return
        }
        
        let pig = Pig(context: viewContext)
        pig.name = name
        pig.url = url
        pig.priceGoal = amount
        pig.createdDate = dateCreated
        pig.dueDate = dueDate
        pig.image = image?.jpegData(compressionQuality: 0.7)
    
        if let savingValue = Double(saving) {
            let pigInput = PigInput(context: viewContext)
            pigInput.amount = savingValue
            pigInput.date = Date()
            pigInput.pig = pig
        }
        
        do {
            try viewContext.save()
        } catch {
            self.errorTextMessage = error.localizedDescription
            return
        }
        
        self.dismiss()
    }
}

struct AddNewPiggyView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewPiggyView()
    }
}
