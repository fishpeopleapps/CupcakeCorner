//
//  Order.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 7/31/23.
//
import SwiftUI

// This is added to make our references easier to deal with!
// This @ allows us to access properties that aren't "there" directly
@dynamicMemberLookup
class SharedOrder: ObservableObject {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Unicorn"]
    @Published var data = Order()
    // Custom subpath, they allow us to read our properties in Order
    subscript<T>(dynamicMember keyPath: KeyPath<Order, T>) -> T {
        data[keyPath: keyPath]
    }
    // Custom subpath, but this one is writable, we're briding the gap between two places
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Order, T>) -> T {
        get {
            data[keyPath: keyPath]
        }
        set {
            data[keyPath: keyPath] = newValue
        }
    }
}
/// Holds our data for 'SharedOrder' class above
/// Holds all data related to a single order
struct Order: Codable {
    enum CodingKeys: CodingKey {
        case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
    }
    var type = 0
    var quantity = 3
    /// This makes it so if we disable special requests that both extraFrosting and addSprinkles will be false
    /// and not left on
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    var hasValidAddress: Bool {
        if name.isReallyEmpty || streetAddress.isReallyEmpty || city.isReallyEmpty || zip.isReallyEmpty {
            return false
        }

        return true
    }
    var cost: Double {
        // Base cost is $2 ea
        var cost = Double(quantity) * 2
        // Fancy flavors cost more
        cost += (Double(type) / 2)
        // Extras
        if extraFrosting {
            cost += Double(quantity)
        }
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        return cost
    }
}
