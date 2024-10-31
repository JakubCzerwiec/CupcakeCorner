//
//  Order.swift
//  CupcakeCorner
//
//  Created by Mój Maczek on 30/10/2024.
//

import Foundation

@Observable
class Order: Codable { // CodingKeys so when sending and receving data keys want't be with undersocres
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet { // when puting special request to false, all the others will be false again
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    
    var extraFrosting = false
    var addSprinkles = false
    
    // Challenge 3 - Reading address data from UserDefaults
    var name = UserDefaults.standard.string(forKey: "OrderName") ?? ""
    var streetAddress = UserDefaults.standard.string(forKey: "OrderStreetAdress") ?? ""
    var city = UserDefaults.standard.string(forKey: "OrderCity") ?? ""
    var zip = UserDefaults.standard.string(forKey: "OrderZip") ?? ""
    
    var hasValidAddress: Bool { // Solutin to challenge 1 - Do not accept white spaces
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || streetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return false
        }
        
        return true
    }
    
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        
        cost += Decimal(type) / 2
        
        if extraFrosting {
            cost += Decimal(quantity)
        }
        
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        
        return cost
    }
}
