//
//  AddSavingView.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/27/22.
//

import SwiftUI

struct AddSavingView: View {
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var piggy: Pig
    
    @State private var amount = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Rectangle()
                        .frame(height: 200)
                        .foregroundColor(.blue.opacity(0.3))
                        .overlay(
                            Text("🐽")
                                .font(.system(size: 46))
                        )
                    
                    TextField("Amount of Saving", text: $amount)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                        .keyboardType(.numberPad)
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        guard let value = Double(amount) else {
                            return
                        }
                        
                        let pigInput = PigInput(context: viewContext)
                        pigInput.amount = value
                        pigInput.date = Date()
                        pigInput.pig = piggy
                        
                        try? viewContext.save()
                        self.dismiss()
                    }
                    .bold()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        self.dismiss()
                    }
                }
            }
        }
    }
}

//struct AddSavingView_Preview: PreviewProvider {
//    static var previews: some View {
//        AddSavingView()
//    }
//}
