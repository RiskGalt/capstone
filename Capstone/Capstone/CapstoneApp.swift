//
//  CapstoneApp.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import SwiftUI

@main
struct CapstoneApp: App {
    @State private var store = B2BLogisticsStore()
    
    var body: some Scene {
        WindowGroup {
            MainDistributionDashboardView(store: store)
        }
    }
}
