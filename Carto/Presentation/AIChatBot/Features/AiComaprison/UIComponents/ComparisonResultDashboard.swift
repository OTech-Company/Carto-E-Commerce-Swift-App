//
//  ComparisonResultDashboard.swift
//  Carto
//
//  Created by Osama Hosam on 06/07/2026.
//

import SwiftUI

struct ComparisonResultDashboard: View {
    let matrix: AIComparisonResponse
    let p1: Product?
    let p2: Product?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            // Native Structured Specs Table
            VStack(alignment: .leading, spacing: 0) {
                // Table Header
                HStack(spacing: 0) {
                    Text("Metric")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(width: 90, alignment: .leading)
                    
                    Spacer()
                    
                    Text(p1?.title ?? "Product 1")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 8)
                    
                    Text(p2?.title ?? "Product 2")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Color(.secondarySystemGroupedBackground))
                
                Divider()
                
                // Table Body Rows
                ForEach(matrix.comparisons, id: \.metricName) { metric in
                    HStack(spacing: 0) {
                        // Feature label column
                        Text(metric.metricName)
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(width: 90, alignment: .leading)
                        
                        Spacer()
                        
                        // Product 1 Column value
                        Text(metric.values["\(p1?.id ?? 1)"] ?? "—")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 8)
                        
                        // Product 2 Column value
                        Text(metric.values["\(p2?.id ?? 2)"] ?? "—")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 14)
                    Divider()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray5), lineWidth: 0.5)
            )
            
            // Summary Block Callout
            VStack(alignment: .leading, spacing: 6) {
                Text("Analysis Summary")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Text(matrix.summary)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            
            // Bottom Final Verdict Placement Block
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("AI Verdict")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                Text(matrix.verdict)
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.orange.opacity(0.06))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.15), lineWidth: 1)
            )
        }
    }
}
