//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 7/31/23.
//
import MapKit
import SwiftUI

struct AddressView: View {
    @ObservedObject var order: SharedOrder
    
    @StateObject var viewModel: AddressViewModel
    @FocusState private var isFocusedTextField: Bool
    
    var body: some View {
        Form {
            Section {
                // TODO: How do I implement one of those address finders? That would be cool to learn
                
                TextField("Type address", text: $viewModel.searchableText)
                                    .padding()
                                    .autocorrectionDisabled()
                                    .focused($isFocusedTextField)
                                    .font(.title)
                                    .onReceive(
                                        viewModel.$searchableText.debounce(
                                            for: .seconds(1),
                                            scheduler: DispatchQueue.main
                                        )
                                    ) {
                                        viewModel.searchAddress($0)
                                    }
                                    .background(Color.init(uiColor: .systemBackground))
                                    .overlay {
                                        ClearButton(text: $viewModel.searchableText)
                                            .padding(.trailing)
                                            .padding(.top, 8)
                                    }
                                    .onAppear {
                                        isFocusedTextField = true
                                    }

                                List(self.viewModel.results) { address in
                                    AddressRow(address: address)
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            // Lights up when user has entered a character into each field above
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ClearButton: View {
    
    @Binding var text: String
    
    var body: some View {
        if text.isEmpty == false {
            HStack {
                Spacer()
                Button {
                    text = ""
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .foregroundColor(Color(red: 0.7, green: 0.7, blue: 0.7))
                }
                .foregroundColor(.secondary)
            }
        } else {
            EmptyView()
        }
    }
}

struct AddressRow: View {
    
    let address: AddressResult
    
    var body: some View {
        NavigationLink {
            MapView(address: address)
        } label: {
            VStack(alignment: .leading) {
                Text(address.title)
                Text(address.subtitle)
                    .font(.caption)
            }
        }
        .padding(.bottom, 2)
    }
}

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()

    private let address: AddressResult
    
    init(address: AddressResult) {
        self.address = address
    }
    
    var body: some View {
        Map(
            coordinateRegion: $viewModel.region,
            annotationItems: viewModel.annotationItems,
            annotationContent: { item in
                MapMarker(coordinate: item.coordinate)
            }
        )
        .onAppear {
            self.viewModel.getPlace(from: address)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
