//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Mój Maczek on 30/10/2024.
//

import SwiftUI

struct CheckoutView: View {
    var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingError = false
    
    var body: some View {
        ScrollView {
            VStack { // Fetching image from web
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total cost is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place order") {
                    Task { // asychron function must be wrapped in the Task, and marked with await key word
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize) // This disables scrolling when content is not filling all the screen
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        } // second alert for challenge 2
        .alert("Placing order failed, please try again later", isPresented: $showingError) {
            Button("OK") {}
        }
    }
    
    func placeOrder() async { // encoding order to JSON
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        // where it will be sent
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url) // making URL request from url
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // value JSON, Content-Type
        request.httpMethod = "POST" // method POST for sending data
        
        do { // this (data, _) meand send without metadata, for our URLrequest and encoded data
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handling what we get back from the server
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Check out failed \(error.localizedDescription)")
            showingError = true // triggers alert - challenge 2
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
