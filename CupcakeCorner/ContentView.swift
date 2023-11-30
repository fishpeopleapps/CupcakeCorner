//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 7/31/23.
//
// TODO: Splash Screen
// TODO: Improve UI
// TODO: Add AppIcon

import SwiftUI

struct ContentView: View {
    @StateObject var order = SharedOrder()
    @StateObject private var viewModel = AddressViewModel()
    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Allows users to choose the type of cupcake via a standard Picker
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(SharedOrder.types.indices) {
                            Text(SharedOrder.types[$0])
                        }
                    }
                    // Allows users to change the quantity of their order, up to 20
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    // Allows users to make special requests, by toggling on, the next block is enabled
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())

                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.addSprinkles)
                    }
                }
                // Allows users to navigate to the AddressView, where they can enter their details
                Section {
                    NavigationLink {
                       // AddressView(order: order, viewModel: viewModel)
                        Test()
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("CupcakeCorner")
        }
    }
}
