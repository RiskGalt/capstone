//
//  RouteOptimizationView.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import SwiftUI

struct RouteOptimizationView: View {
    var store: B2BLogisticsStore
    
    var body: some View {
        List {
            // SECTION 1: Fleet Availability Overview
            Section("Active Fleet Resource Status") {
                ForEach(store.vehicles) { vehicle in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(vehicle.truckIdentifier)
                                .font(.subheadline)
                                .bold()
                            Text("Max Volumetric Limit: \(vehicle.maxCaseCapacity) cases")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        Text(vehicle.isActive ? "Available" : "In Transit")
                            .font(.caption)
                            .bold()
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(vehicle.isActive ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
                            .foregroundColor(vehicle.isActive ? .green : .gray)
                            .clipShape(Capsule())
                    }
                }
            }
            
            // SECTION 2: Capacity Demand Monitoring
            Section("Pending Manifest Cargo Load Tracker") {
                if store.orders.isEmpty {
                    Text("No pending wholesale orders in queue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    ForEach(store.orders) { order in
                        let client = store.clients.first(where: { $0.id == order.clientAccountID })
                        let matchingTruck = store.vehicles.first // For testing, evaluate against our standard first fleet runner
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(client?.storeName ?? "Unknown Distributor")
                                    .font(.headline)
                                Spacer()
                                Text("Region FSA: \(client?.postalCodeFSA ?? "N/A")")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.blue)
                            }
                            
                            HStack {
                                LabeledContent("Cargo Manifest Weight", value: "\(order.totalCaseCount) cases")
                                
                                Spacer()
                                
                                // DYNAMIC VOLUMETRIC CAPACITY GUARD
                                if let truck = matchingTruck, order.totalCaseCount > truck.maxCaseCapacity {
                                    HStack(spacing: 4) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                        Text("OVER CAPACITY")
                                    }
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.red)
                                } else {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                        Text("Fits Truck Limit")
                                    }
                                    .font(.caption2)
                                    .bold()
                                    .foregroundColor(.green)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Fleet Optimization")
    }
}

#Preview {
    NavigationStack {
        let previewStore = B2BLogisticsStore()
        // Seed a sample heavy order to demonstrate the over-capacity warning badge
        let sampleBigOrder = OrderPayload(
            clientAccountID: previewStore.clients.first?.id ?? UUID(),
            orderedItems: [previewStore.skus.first?.id ?? UUID() : 120] // 120 cases will easily blow past our 50-case courier limit!
        )
        previewStore.placeOrder(sampleBigOrder)
        return RouteOptimizationView(store: previewStore)
    }
}
