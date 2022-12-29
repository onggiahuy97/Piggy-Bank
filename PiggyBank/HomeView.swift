//
//  HomeView.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/25/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var piggyVM: PiggyViewModel
        
    @State private var showAddNewPiggy = false
    
    var header: String {
        if piggyVM.piggies.isEmpty {
            return "Piggy is empty, please add more"
        } else {
            return "Piggy Processes"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text(header)
                        .font(.system(size: 18, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                    ForEach(piggyVM.piggies) { piggy in
                        PiggyCardView(piggy: piggy)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .background(Color.background)
            .navigationTitle("Piggy Bank")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            showAddNewPiggy.toggle()
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .sheet(isPresented: $showAddNewPiggy, content: AddNewPiggyView.init)
                        Button("Delete") {
                            piggyVM.deleteAll()
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        ForEach(PiggyViewModel.FilterType.allCases) { type in
                            Button(role: type == .Deleted ? .destructive : .none) {
                                piggyVM.filterType = type
                            } label: {
                                Label(type.label.0, systemImage: type.label.1)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
