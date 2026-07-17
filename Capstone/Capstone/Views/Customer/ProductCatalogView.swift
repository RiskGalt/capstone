//
//  productCatalogView.swift
//  Capstone
//
//  Created by Adam de Costa on 2026-07-17.
//

import SwiftUI

struct ProductCatalogView: View {
    var store: B2BLogisticsStore
    
    // We will leave the packagingImage helper function for logical branching,
    // but the main UI will use a stable container until actual photos are imported.
    func packagingImage(for flavorName: String) -> (icon: String, color: Color) {
        if flavorName.contains("960ml") {
            return ("bottle.condiment.fill", .orange)
        } else if flavorName.contains("473ml") {
            return ("can.fill", .yellow)
        } else if flavorName.contains("Sparkling") {
            return ("popcorn.fill", .pink)
        } else {
            return ("shippingbox.fill", .green)
        }
    }
    
    var body: some View {
        List {
            ForEach(BeverageCategory.allCases, id: \.self) { category in
                let categorySKUs = store.skus.filter { $0.category == category }
                
                if !categorySKUs.isEmpty {
                    Section(header: Text(category.rawValue)) {
                        ForEach(categorySKUs) { sku in
                            HStack(alignment: .center, spacing: 16) {
                                
                                // DYNAMIC IMAGE CONTAINER (Reserved for image assets)
                                ZStack {
                                    // TEMPORARY STABLE COLOR PLACEHOLDER (Wait for final assets)
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 64, height: 64)
                                    
                                    // THIS SPACE INTENTIONALLY LEFT BLANK FOR REAL IMAGES
                                    // When you have images, replace this with:
                                    // Image(sku.imageAssetName)
                                    // .resizable()
                                    // .aspectRatio(contentMode: .fit)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sku.flavorName)
                                        .font(.headline)
                                    Text("SKU: \(sku.skuCode)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 4) {
                                    Text(String(format: "$%.2f", sku.basePricePerCase))
                                        .font(.subheadline)
                                        .bold()
                                    Text("MOQ: \(sku.minimumOrderQuantity)")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Sunberry Catalog")
    }
}

#Preview {
    NavigationStack {
        ProductCatalogView(store: B2BLogisticsStore())
    }
}
