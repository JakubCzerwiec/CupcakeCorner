//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Mój Maczek on 30/10/2024.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutView(order: order)
                } .onTapGesture(perform: { // Challenge 3 - Saving data in UserDefaults
                    UserDefaults.standard.set(order.name, forKey: "OrderName")
                    UserDefaults.standard.set(order.streetAddress, forKey: "OrderStreetAdress")
                    UserDefaults.standard.set(order.city, forKey: "OrderCity")
                    UserDefaults.standard.set(order.zip, forKey: "OrderZip")
                })
            } // By default link is disabled, until valid adress is typed in the form
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddressView(order: Order())
}
