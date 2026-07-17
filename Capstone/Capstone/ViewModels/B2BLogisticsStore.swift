//
//  B2BLogisticsStore.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import Foundation
import Observation

@Observable
final class B2BLogisticsStore {
    var skus: [BeverageSKU] = []
    var clients: [ClientAccount] = []
    var orders: [OrderPayload] = []
    var vehicles: [FleetVehicle] = []
    var routes: [DeliveryRoute] = []
    
    init() {
        // Automatically populate our product matrix and distribution targets immediately on app start!
        B2BDataSeed.seedData(into: self)
    }
    
    func addSKU(_ sku: BeverageSKU) { skus.append(sku) }
    func addClient(_ client: ClientAccount) { clients.append(client) }
    func placeOrder(_ order: OrderPayload) { orders.append(order) }
}
