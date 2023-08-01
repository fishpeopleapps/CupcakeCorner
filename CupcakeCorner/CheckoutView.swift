//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 7/31/23.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: SharedOrder
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                // reserves space so the UI doesn't jump after the image loads
                .frame(height: 233)
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        // Dynamic alert that shows either confirmation or error messages
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    /// Submits an encoded order to an online resource and returns a confirmation or error message
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order.data) else {
            print("Failed to encode order")
            return
        }
        /// This resource allows us to send data and it mirrors it right back to us
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // This is what we commend out to force an error
        request.httpMethod = "POST"
        /// Now we're all set to make our network request
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Thank You!"
            alertMessage = """
                            Your order for \(decodedOrder.quantity)x
                            \(SharedOrder.types[decodedOrder.type].lowercased()) cupcakes is on its way!
                            """
            showingAlert = true
        } catch {
            alertTitle = "Oops!"
            alertMessage = "Sorry, checkout failed. \n\nMessage: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: SharedOrder())
    }
}
