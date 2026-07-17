//
//  B2BDataSeed.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import Foundation

struct B2BDataSeed {
    static func seedData(into store: B2BLogisticsStore) {
        store.skus.removeAll()
        store.clients.removeAll()
        store.vehicles.removeAll()
        store.orders.removeAll()
        store.routes.removeAll()
        
        let brand = "Sunberry Farms"
        let coreFlavors = ["Mango", "Guava", "POG (Passion Orange Guava)", "Dragon Fruit", "Lychee"]
        let altFlavors = ["Mango", "Guava", "Passion Fruit", "Dragon Fruit", "Lychee"]
        let extraTetraFlavors = ["Pineapple Ginger", "Coconut Water Blend"]
        
        for flavor in coreFlavors {
            let code = "SB-960-\(flavor.prefix(3).uppercased())"
            store.addSKU(BeverageSKU(skuCode: code, flavorName: "\(flavor) 960ml", brandName: brand, category: .juices, basePricePerCase: 45.00, minimumOrderQuantity: 5))
        }
        
        for flavor in coreFlavors {
            let code = "SB-473-\(flavor.prefix(3).uppercased())"
            store.addSKU(BeverageSKU(skuCode: code, flavorName: "\(flavor) 473ml", brandName: brand, category: .juices, basePricePerCase: 32.00, minimumOrderQuantity: 8))
        }
        
        for flavor in altFlavors {
            let code = "SB-SPK-\(flavor.prefix(3).uppercased())"
            store.addSKU(BeverageSKU(skuCode: code, flavorName: "\(flavor) Sparkling 4-Pack", brandName: brand, category: .energyDrinks, basePricePerCase: 28.00, minimumOrderQuantity: 10))
        }
        
        for flavor in (altFlavors + extraTetraFlavors) {
            let code = "SB-TET-\(flavor.prefix(3).uppercased())"
            store.addSKU(BeverageSKU(skuCode: code, flavorName: "\(flavor) 1L Tetra Pak", brandName: brand, category: .caseBundles, basePricePerCase: 38.00, minimumOrderQuantity: 5))
        }
        
        let testClients = [
            ClientAccount(storeName: "Metro Supercentre - Scarborough", shippingAddress: "3221 Eglinton Ave E", postalCodeFSA: "M1J", taxIdentifier: "ON-TX-991A", customContractDiscountMultiplier: 0.90),
            ClientAccount(storeName: "Loblaws Distribution Hub", shippingAddress: "60 Lakeshore Blvd E", postalCodeFSA: "M5E", taxIdentifier: "ON-TX-884B", customContractDiscountMultiplier: 0.85),
            ClientAccount(storeName: "Sobeys Wholesale Terminal", shippingAddress: "8400 Chinguacousy Rd", postalCodeFSA: "L6Y", taxIdentifier: "ON-TX-112C"),
            ClientAccount(storeName: "FreshCo Regional Market", shippingAddress: "2300 Yonge St", postalCodeFSA: "M4P", taxIdentifier: "ON-TX-556D")
        ]
        
        for client in testClients {
            store.addClient(client)
        }
        
        store.vehicles.append(FleetVehicle(truckIdentifier: "Express Regional Courier (Truck 01)", maxCaseCapacity: 50, maxShiftHours: 8.0))
        store.vehicles.append(FleetVehicle(truckIdentifier: "Heavy Freightliner (Truck 02)", maxCaseCapacity: 250, maxShiftHours: 10.0))
    }
}
