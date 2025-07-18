//
//  ChartsVisualizationDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI
import Charts

struct SalesData: Identifiable {
    let id = UUID()
    let month: String
    let sales: Double
    let category: String
}

struct PerformanceData: Identifiable {
    let id = UUID()
    let metric: String
    let value: Double
    let target: Double
}

struct ChartsVisualizationDemoView: View {
    @State private var animateCharts = false
    @State private var selectedDataSet = 0
    
    // Sample data
    private let salesData = [
        SalesData(month: "Jan", sales: 45000, category: "Product A"),
        SalesData(month: "Feb", sales: 52000, category: "Product A"),
        SalesData(month: "Mar", sales: 38000, category: "Product A"),
        SalesData(month: "Apr", sales: 61000, category: "Product A"),
        SalesData(month: "May", sales: 55000, category: "Product A"),
        SalesData(month: "Jun", sales: 67000, category: "Product A"),
        SalesData(month: "Jan", sales: 32000, category: "Product B"),
        SalesData(month: "Feb", sales: 41000, category: "Product B"),
        SalesData(month: "Mar", sales: 29000, category: "Product B"),
        SalesData(month: "Apr", sales: 48000, category: "Product B"),
        SalesData(month: "May", sales: 43000, category: "Product B"),
        SalesData(month: "Jun", sales: 52000, category: "Product B"),
    ]
    
    private let performanceData = [
        PerformanceData(metric: "Revenue", value: 85, target: 100),
        PerformanceData(metric: "Users", value: 120, target: 100),
        PerformanceData(metric: "Retention", value: 75, target: 80),
        PerformanceData(metric: "Satisfaction", value: 92, target: 90),
    ]
    
    private let temperatureData = [
        (day: "Mon", temp: 22.5),
        (day: "Tue", temp: 24.1),
        (day: "Wed", temp: 19.8),
        (day: "Thu", temp: 21.3),
        (day: "Fri", temp: 25.7),
        (day: "Sat", temp: 28.2),
        (day: "Sun", temp: 26.9),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Charts & Visualization")
                
                lineChartsSection
                barChartsSection
                specializedChartsSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Charts & Visualization")
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                animateCharts = true
            }
        }
    }
    
    private var lineChartsSection: some View {
        demoSection("Line Charts") {
            VStack(spacing: 20) {
                GroupBox("Temperature Trend") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(Array(temperatureData.enumerated()), id: \.offset) { index, data in
                                LineMark(
                                    x: .value("Day", data.day),
                                    y: .value("Temperature", animateCharts ? data.temp : 0)
                                )
                                .foregroundStyle(.blue)
                                .interpolationMethod(.catmullRom)
                                
                                PointMark(
                                    x: .value("Day", data.day),
                                    y: .value("Temperature", animateCharts ? data.temp : 0)
                                )
                                .foregroundStyle(.blue)
                                .symbolSize(50)
                            }
                        }
                        .frame(height: 200)
                        .chartYAxis {
                            AxisMarks(position: .leading)
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                                AxisGridLine()
                                AxisTick()
                                AxisValueLabel()
                            }
                        }
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Animated line chart with smooth curves")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Multi-Series Line Chart") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(salesData) { data in
                                LineMark(
                                    x: .value("Month", data.month),
                                    y: .value("Sales", animateCharts ? data.sales : 0)
                                )
                                .foregroundStyle(by: .value("Category", data.category))
                                .symbol(by: .value("Category", data.category))
                            }
                        }
                        .frame(height: 200)
                        .chartLegend(position: .top, alignment: .leading)
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Multi-series line chart with legends")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var barChartsSection: some View {
        demoSection("Bar Charts") {
            VStack(spacing: 20) {
                GroupBox("Sales by Month") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(salesData.filter { $0.category == "Product A" }) { data in
                                BarMark(
                                    x: .value("Month", data.month),
                                    y: .value("Sales", animateCharts ? data.sales : 0)
                                )
                                .foregroundStyle(.blue.gradient)
                                .cornerRadius(4)
                            }
                        }
                        .frame(height: 200)
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Animated bar chart with gradients")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Grouped Bar Chart") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(salesData) { data in
                                BarMark(
                                    x: .value("Month", data.month),
                                    y: .value("Sales", animateCharts ? data.sales : 0)
                                )
                                .foregroundStyle(by: .value("Category", data.category))
                                .position(by: .value("Category", data.category))
                            }
                        }
                        .frame(height: 200)
                        .chartLegend(position: .top, alignment: .leading)
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Grouped bar chart comparing categories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Horizontal Bar Chart") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(performanceData) { data in
                                BarMark(
                                    x: .value("Value", animateCharts ? data.value : 0),
                                    y: .value("Metric", data.metric),
                                    width: 20
                                )
                                .foregroundStyle(.green.gradient)
                                .cornerRadius(4)
                                
                                // Target line
                                RuleMark(
                                    x: .value("Target", data.target)
                                )
                                .foregroundStyle(.red)
                                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                            }
                        }
                        .frame(height: 200)
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Horizontal bars with target lines")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var specializedChartsSection: some View {
        demoSection("Specialized Charts") {
            VStack(spacing: 20) {
                GroupBox("Area Chart") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(temperatureData, id: \.day) { data in
                                AreaMark(
                                    x: .value("Day", data.day),
                                    y: .value("Temperature", animateCharts ? data.temp : 0)
                                )
                                .foregroundStyle(.purple.gradient.opacity(0.6))
                                .interpolationMethod(.catmullRom)
                                
                                LineMark(
                                    x: .value("Day", data.day),
                                    y: .value("Temperature", animateCharts ? data.temp : 0)
                                )
                                .foregroundStyle(.purple)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .frame(height: 200)
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Area chart with gradient fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Interactive Chart") {
                    VStack(spacing: 15) {
                        Picker("Data Set", selection: $selectedDataSet) {
                            Text("Product A").tag(0)
                            Text("Product B").tag(1)
                            Text("Combined").tag(2)
                        }
                        .pickerStyle(.segmented)
                        
                        Chart {
                            ForEach(filteredSalesData()) { data in
                                BarMark(
                                    x: .value("Month", data.month),
                                    y: .value("Sales", data.sales)
                                )
                                .foregroundStyle(.orange.gradient)
                                .cornerRadius(6)
                            }
                        }
                        .frame(height: 200)
                        .animation(.easeInOut(duration: 0.5), value: selectedDataSet)
                        
                        Text("Interactive chart with data filtering")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Custom Styling") {
                    VStack(spacing: 15) {
                        Chart {
                            ForEach(performanceData) { data in
                                BarMark(
                                    x: .value("Metric", data.metric),
                                    y: .value("Value", animateCharts ? data.value : 0)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: data.value >= data.target ? [.green, .mint] : [.orange, .red],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )
                                )
                                .cornerRadius(8)
                            }
                        }
                        .frame(height: 200)
                        .chartYScale(domain: 0...150)
                        .chartXAxis {
                            AxisMarks { value in
                                AxisValueLabel()
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .chartYAxis {
                            AxisMarks(position: .leading) { value in
                                AxisGridLine()
                                    .foregroundStyle(.gray.opacity(0.3))
                                AxisValueLabel()
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .animation(.easeInOut(duration: 1.5), value: animateCharts)
                        
                        Text("Custom styling with conditional colors")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Chart Controls") {
                    VStack(spacing: 15) {
                        Button("Animate Charts") {
                            animateCharts = false
                            withAnimation(.easeInOut(duration: 1.5)) {
                                animateCharts = true
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Reset Animation") {
                            animateCharts = false
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Control chart animations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func filteredSalesData() -> [SalesData] {
        switch selectedDataSet {
        case 0:
            return salesData.filter { $0.category == "Product A" }
        case 1:
            return salesData.filter { $0.category == "Product B" }
        default:
            return salesData
        }
    }
    
    private func demoSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            
            content()
        }
    }
    
    private func headerSection(_ title: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("SwiftUI Charts with animations, interactions, and custom styling")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ChartsVisualizationDemoView()
    }
}
