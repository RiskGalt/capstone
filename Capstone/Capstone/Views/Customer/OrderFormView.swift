//
//  OrderFormView.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import SwiftUI

struct OrderFormView: View {
    var store: B2BLogisticsStore
    @Environment(\.dismiss) private var dismiss
    
    // State Tracking
    @State private var selectedClientID: UUID = UUID()
    @State private var quantities: [UUID: Int] = [:] // SKU ID -> Ordered Quantity
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Set up initial state data safely on load
    init(store: B2BLogisticsStore) {
        self.store = store
        _selectedClientID = State(initialValue: store.clients.first?.id ?? UUID())
    }
    
    // Temporary helper payload for live pricing feedback
    var temporaryOrderPayload: OrderPayload {
        OrderPayload(clientAccountID: selectedClientID, orderedItems: quantities.filter { $0.value > 0 })
    }
    
    var body: some View {
        Form {
            // SECTION 1: Account Identification
            Section("Select Corporate Distributor") {
                Picker("Client Hub", selection: $selectedClientID) {
                    ForEach(store.clients) { client in
                        Text(client.storeName).tag(client.id)
                    }
                }
            }
            
            // SECTION 2: Interactive Product Matrix
            Section("Product Groupings & Case Counts") {
                ForEach(BeverageCategory.allCases, id: \.self) { category in
                    let categorySKUs = store.skus.filter { $0.category == category }
                    
                    if !categorySKUs.isEmpty {
                        Text(category.rawValue)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.secondary)
                        
                        ForEach(categorySKUs) { sku in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(sku.flavorName)
                                        .font(.subheadline)
                                    Text(String(format: "$%.2f/case (MOQ: %d)", sku.basePricePerCase, sku.minimumOrderQuantity))
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                // Stepper bound to our tracking dictionary
                                Stepper(value: Binding(
                                    get: { quantities[sku.id] ?? 0 },
                                    set: { quantities[sku.id] = $0 }
                                ), in: 0...500) {
                                    Text("\(quantities[sku.id] ?? 0) cs")
                                        .font(.body)
                                        .frame(width: 60, alignment: .trailing)
                                }
                            }
                        }
                    }
                }
            }
            
            // SECTION 3: Live Invoice Estimation Engine
            let totals = B2BFinancialEngine.calculateInvoice(for: temporaryOrderPayload, in: store)
            Section("Live Bill of Lading Cost Summary") {
                LabeledContent("Subtotal", value: String(format: "$%.2f", totals.subtotal))
                if totals.contractDiscount > 0 {
                    LabeledContent("Contract Multiplier Discount", value: String(format: "-$%.2f", totals.contractDiscount))
                        .foregroundColor(.green)
                }
                LabeledContent("Ontario HST (13%)", value: String(format: "$%.2f", totals.hstAmount))
                LabeledContent("Estimated Invoice Total", value: String(format: "$%.2f", totals.grandTotal))
                    .bold()
            }
            
            // SECTION 4: Submission Trigger Action
            Section {
                Button(action: submitOrder) {
                    Text("Submit Wholesale Payload")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                }
                .disabled(temporaryOrderPayload.totalCaseCount == 0)
            }
        }
        .navigationTitle("Create Order")
        .alert("Order Validation Check", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Validation & Persistence Engine
    private func submitOrder() {
        let order = temporaryOrderPayload
        
        // 1. Run B2B MOQ Check Guard
        let validationFailures = B2BFinancialEngine.validateMOQs(for: order, in: store)
        
        if !validationFailures.isEmpty {
            var errors: [String] = []
            for (skuID, minRequired) in validationFailures {
                if let sku = store.skus.first(where: { $0.id == skuID }) {
                    errors.append("• \(sku.flavorName) requires minimum \(minRequired) cases.")
                }
            }
            alertMessage = "Corporate procurement constraints failed:\n" + errors.joined(separator: "\n")
            showAlert = true
            return
        }
        
        // 2. Clear to persist if validation matches parameters
        store.placeOrder(order)
        dismiss()
    }
}

#Preview {
    NavigationStack {
        OrderFormView(store: B2BLogisticsStore())
    }
}
