//
//  B2BModels.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import Foundation

// MARK: - 1. Beverage Category (For multi-tiered filtering)
enum BeverageCategory: String, Codable, CaseIterable {
    case juices = "Juices"
    case energyDrinks = "Energy Drinks"
    case bulkPallets = "Bulk Pallets"
    case caseBundles = "Case Bundles"
}

// MARK: - 2. Beverage SKU (Focused on Wholesale Pricing & Capacity)
struct BeverageSKU: Identifiable, Codable {
    let id: UUID
    var skuCode: String // e.g., "SUN-MGO-01"
    var flavorName: String
    var brandName: String
    var category: BeverageCategory
    var basePricePerCase: Double
    var minimumOrderQuantity: Int // MOQ validation
    
    init(id: UUID = UUID(), skuCode: String, flavorName: String, brandName: String, category: BeverageCategory, basePricePerCase: Double, minimumOrderQuantity: Int = 5) {
        self.id = id
        self.skuCode = skuCode
        self.flavorName = flavorName
        self.brandName = brandName
        self.category = category
        self.basePricePerCase = basePricePerCase
        self.minimumOrderQuantity = minimumOrderQuantity
    }
}

// MARK: - 3. Client Account (Our Delivery Targets)
struct ClientAccount: Identifiable, Codable {
    let id: UUID
    var storeName: String
    var shippingAddress: String
    var postalCodeFSA: String // First 3 digits of postal code (e.g., "M1P") for geographic clustering[cite: 2]
    var taxIdentifier: String // For HST auditing[cite: 2]
    var customContractDiscountMultiplier: Double // e.g., 0.90 represents a 10% contract discount[cite: 2]
    
    init(id: UUID = UUID(), storeName: String, shippingAddress: String, postalCodeFSA: String, taxIdentifier: String, customContractDiscountMultiplier: Double = 1.0) {
        self.id = id
        self.storeName = storeName
        self.shippingAddress = shippingAddress
        self.postalCodeFSA = postalCodeFSA.uppercased()
        self.taxIdentifier = taxIdentifier
        self.customContractDiscountMultiplier = customContractDiscountMultiplier
    }
}

// MARK: - 4. Order Payload (The Sales & Volumetric Source)
struct OrderPayload: Identifiable, Codable {
    let id: UUID
    var clientAccountID: UUID
    var orderDate: Date
    var isConfirmed: Bool
    var orderedItems: [UUID: Int] // SKU ID -> Case Quantity Ordered
    
    init(id: UUID = UUID(), clientAccountID: UUID, orderDate: Date = Date(), isConfirmed: Bool = false, orderedItems: [UUID : Int] = [:]) {
        self.id = id
        self.clientAccountID = clientAccountID
        self.orderDate = orderDate
        self.isConfirmed = isConfirmed
        self.orderedItems = orderedItems
    }
    
    // Calculates total physical case count (vital for truck capacity constraint calculations)[cite: 2]
    var totalCaseCount: Int {
        orderedItems.values.reduce(0, +)
    }
}

// MARK: - 5. Fleet Vehicle (Our Logistics Constraint Models)
struct FleetVehicle: Identifiable, Codable {
    let id: UUID
    var truckIdentifier: String // e.g., "Truck A - Freight Liner"
    var maxCaseCapacity: Int // Physical truck cargo limit (e.g., 200 cases)[cite: 2]
    var maxShiftHours: Double // e.g., 8.0 hours maximum operational limit per route[cite: 2]
    var isActive: Bool
    
    init(id: UUID = UUID(), truckIdentifier: String, maxCaseCapacity: Int = 200, maxShiftHours: Double = 8.0, isActive: Bool = true) {
        self.id = id
        self.truckIdentifier = truckIdentifier
        self.maxCaseCapacity = maxCaseCapacity
        self.maxShiftHours = maxShiftHours
        self.isActive = isActive
    }
}

// MARK: - 6. Delivery Route (The Output of the Optimization Engine)
struct DeliveryRoute: Identifiable, Codable {
    let id: UUID
    var scheduledDate: Date
    var fsaTargetRegion: String // Geographic cluster code (e.g., "M1P")[cite: 2]
    var stopSequenceOrder: [UUID] = [] // Ordered list of ClientAccount IDs mapped sequentially[cite: 2]
    var totalCasePayload: Int // Combined case sum of all orders on this route[cite: 2]
    var assignedVehicleID: UUID?
    
    init(id: UUID = UUID(), scheduledDate: Date, fsaTargetRegion: String, stopSequenceOrder: [UUID] = [], totalCasePayload: Int = 0, assignedVehicleID: UUID? = nil) {
        self.id = id
        self.scheduledDate = scheduledDate
        self.fsaTargetRegion = fsaTargetRegion.uppercased()
        self.stopSequenceOrder = stopSequenceOrder
        self.totalCasePayload = totalCasePayload
        self.assignedVehicleID = assignedVehicleID
    }
}
