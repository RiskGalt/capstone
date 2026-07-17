//
//  MainDistributionDashboardView.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import SwiftUI

struct MainDistributionDashboardView: View {
    // Pass the store directly to the view as a stable property
    var store: B2BLogisticsStore
    
    var body: some View {
        TabView {
            // Tab 1: Logistics & Fleet Management Console
            NavigationStack {
                List {
                    Section("Fleet Asset Utilization") {
                        LabeledContent("Active Delivery Trucks", value: "\(store.vehicles.count)")
                        LabeledContent("Optimized Routes Generated", value: "\(store.routes.count)")
                    }
                    
                    Section("Wholesale Operations") {
                        NavigationLink("Demand Forecasting Panel") {
                            Text("Demand Graphs & FSA Clusters Coming Soon")
                        }
                        // Clickable link to jump into your new capacity load tracking console
                        NavigationLink("Fleet Routing Optimization") {
                            RouteOptimizationView(store: store)
                        }
                    }
                }
                .navigationTitle("Logistics Console")
            }
            .tabItem {
                Label("Logistics", systemImage: "truck.box.fill")
            }
            
            // Tab 2: Corporate Customer Portal
                        NavigationStack {
                            List {
                                Section("Client Accounts") {
                                    LabeledContent("Registered Distributors", value: "\(store.clients.count)")
                                }
                                
                                Section("Wholesale Operations Panel") {
                                    NavigationLink("Browse Wholesale Catalog") {
                                        ProductCatalogView(store: store)
                                    }
                                    // Clickable link to trigger the new interactive order builder sheet
                                    NavigationLink("Generate Purchase Order") {
                                        OrderFormView(store: store)
                                    }
                                }
                                
                                Section("Live Fulfillment Queue") {
                                    LabeledContent("Pending Shipments", value: "\(store.orders.count)")
                                }
                            }
                            .navigationTitle("Customer Portal")
                        }
                        .tabItem {
                            Label("Customers", systemImage: "building.2.crop.leftback.fill")
                        }
        }
    }
}

#Preview {
    MainDistributionDashboardView(store: B2BLogisticsStore())
}
