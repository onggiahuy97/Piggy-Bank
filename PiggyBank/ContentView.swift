//
//  ContentView.swift
//  PiggyBank
//
//  Created by Huy Ong on 12/25/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Piggy", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
