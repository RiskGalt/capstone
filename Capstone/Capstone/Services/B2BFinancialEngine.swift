//
//  B2BFinancialEngine.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import Foundation

struct B2BFinancialEngine {
    
    // Ontario Harmonized Sales Tax rate
    private static let hstRate = 0.13
    
    // MARK: - Core Calculation Breakdown
    struct FinancialBreakdown {
        var subtotal: Double
        var contractDiscount: Double
        var taxableAmount: Double
        var hstAmount: Double
        var grandTotal: Double
    }
    
    /// Computes the complete commercial breakdown for an order payload
    static func calculateInvoice(for order: OrderPayload, in store: B2BLogisticsStore) -> FinancialBreakdown {
        var runningSubtotal: Double = 0.0
        
        // Find the client to look up custom contractual terms
        let client = store.clients.first(where: { $0.id == order.clientAccountID })
        let discountMultiplier = client?.customContractDiscountMultiplier ?? 1.0
        
        // Tally up items based on base case pricing
        for (skuID, quantity) in order.orderedItems {
            if let sku = store.skus.first(where: { $0.id == skuID }) {
                runningSubtotal += sku.basePricePerCase * Double(quantity)
            }
        }
        
        let subtotal = runningSubtotal
        let discountAmount = subtotal * (1.0 - discountMultiplier)
        let taxableAmount = subtotal - discountAmount
        let hstAmount = taxableAmount * hstRate
        let grandTotal = taxableAmount + hstAmount
        
        return FinancialBreakdown(
            subtotal: subtotal,
            contractDiscount: discountAmount,
            taxableAmount: taxableAmount,
            hstAmount: hstAmount,
            grandTotal: grandTotal
        )
    }
    
    // MARK: - Validation Guards
    /// Checks if any item in the order fails the corporate distribution MOQ rule
    static func validateMOQs(for order: OrderPayload, in store: B2BLogisticsStore) -> [UUID: Int] {
        var failingSKUs: [UUID: Int] = [:] // SKU ID -> Required MOQ amount
        
        for (skuID, quantity) in order.orderedItems {
            if let sku = store.skus.first(where: { $0.id == skuID }) {
                if quantity < sku.minimumOrderQuantity && quantity > 0 {
                    failingSKUs[sku.id] = sku.minimumOrderQuantity
                }
            }
        }
        return failingSKUs
    }
}
