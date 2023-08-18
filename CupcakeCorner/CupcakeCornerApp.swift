//
//  CupcakeCornerApp.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 7/31/23.
//

import SwiftUI

@main
struct CupcakeCornerApp: App {
    @StateObject var monitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(monitor)
        }
    }
}
