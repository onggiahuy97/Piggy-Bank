//
//  PiggyCardView.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/28/22.
//

import SwiftUI

struct PiggyCardView: View {
    @ObservedObject var piggy: Pig
    
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var showAddSaving = false
    @State private var saving = ""
    @State private var savingDate = Date()
    
    var body: some View {
        VStack(alignment: .leading) {
            Color(.blue).opacity(0.4)
                .frame(height: 140)
                .overlay(alignment: .bottom) {
                    ProgressView(value: piggy.processValue) {
                        Text("\(piggy.name ?? "")")
                            .bold()
                    }
                    .padding(5)
                    .background(.ultraThinMaterial)
                }
            VStack(alignment: .leading) {
                HStack {
                    Label("Saving $\(piggy.totalSaving.toString())",
                          systemImage: piggy.canBuy ? "checkmark.circle" : "circle.dashed"
                    )
                    .bold(piggy.canBuy)
                    
                    Spacer()
                    Label("Goal $\(piggy.priceGoal.toString())", systemImage: "dollarsign.circle")
                }
                Divider()
                HStack {
                    Label("\(piggy.onGoingDays) Days", systemImage: "calendar.badge.clock")
                    Spacer()
                    Label("Due: \((piggy.dueDate ?? Date()).toString())", systemImage: "calendar")
                        .foregroundColor(piggy.isPassedDueDate ? .red : .primary)
                }
                
                Divider()
                
                if !piggy.savingInputs.isEmpty {
                    DisclosureGroup {
                        ForEach(piggy.savingInputs) { saving in
                            HStack {
                                Text("$ \(saving.amount.toString())")
                                Spacer()
                                Text(saving.date ?? Date(), style: .date)
                            }
                        }
                    } label: {
                        Label("Show Saving Details", systemImage: "list.bullet.rectangle.portrait")
                    }
                    
                    Divider()
                }
                
                if showAddSaving {
                    HStack {
                        TextField("How much?", text: $saving)
                            .keyboardType(.numberPad)
                            
                        DatePicker("", selection: $savingDate, displayedComponents: .date)
                    }
                    Divider()
                }
                
                HStack {
                    
                    if showAddSaving {
                        Button("Save") {
                            guard let value = Double(saving) else {
                                return
                            }
                            
                            let pigInput = PigInput(context: viewContext)
                            pigInput.amount = value
                            pigInput.date = Date()
                            pigInput.pig = piggy
                            
                            try? viewContext.save()
                            
                            saving = ""
                            showAddSaving = false
                        }
                        
                        Divider()
                        
                        Button("Cancel") {
                            showAddSaving = false
                        }
                    } else {
                        Button("Add Saving") {
                            self.showAddSaving.toggle()
                        }
                    }
                    
                    Divider()
                    
                    Button("Edit") {}
                    
                    Spacer()
                    
                    if piggy.totalSaving > piggy.priceGoal {
                        Button {
                            
                        } label: {
                            Label("Crack!", systemImage: "hammer")
                                .bold()
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .background(.white)
        .frame(maxWidth: .infinity)
        .cornerRadius(12)
        .shadow(radius: 1, y: 1)
    }
}
