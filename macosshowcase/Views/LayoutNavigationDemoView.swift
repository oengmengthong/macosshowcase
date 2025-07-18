//
//  LayoutNavigationDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct LayoutNavigationDemoView: View {
    @State private var selectedTab = 0
    @State private var showingSheet = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Layout & Navigation Components")
                
                navigationSection
                layoutContainersSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Layout & Navigation")
        .sheet(isPresented: $showingSheet) {
            SheetContentView()
        }
    }
    
    private var navigationSection: some View {
        demoSection("Navigation Components") {
            VStack(spacing: 20) {
                // NavigationLink Demo
                GroupBox("NavigationLink") {
                    VStack(alignment: .leading, spacing: 10) {
                        NavigationLink("Go to Detail View") {
                            DetailView()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("NavigationLink creates navigable connections between views")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // TabView Demo
                GroupBox("TabView") {
                    VStack {
                        TabView(selection: $selectedTab) {
                            VStack {
                                Image(systemName: "house.fill")
                                    .font(.title)
                                Text("Home Tab")
                            }
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .tag(0)
                            
                            VStack {
                                Image(systemName: "gear")
                                    .font(.title)
                                Text("Settings Tab")
                            }
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(1)
                        }
                        .frame(height: 150)
                        
                        Text("TabView provides tab-based navigation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Sheet Presentation
                GroupBox("Sheet Presentation") {
                    VStack(alignment: .leading, spacing: 10) {
                        Button("Show Sheet") {
                            showingSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("Modal sheet presentation for secondary content")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var layoutContainersSection: some View {
        demoSection("Layout Containers") {
            VStack(spacing: 20) {
                // VStack/HStack Demo
                GroupBox("VStack & HStack") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            ForEach(1...3, id: \.self) { number in
                                Circle()
                                    .fill(Color.blue.gradient)
                                    .frame(width: 40, height: 40)
                                    .overlay(Text("\(number)").foregroundColor(.white))
                            }
                        }
                        
                        VStack(spacing: 10) {
                            ForEach(["A", "B", "C"], id: \.self) { letter in
                                Rectangle()
                                    .fill(Color.green.gradient)
                                    .frame(height: 30)
                                    .overlay(Text(letter).foregroundColor(.white))
                            }
                        }
                        
                        Text("HStack arranges views horizontally, VStack vertically")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // ZStack Demo
                GroupBox("ZStack (Layered Layout)") {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(Color.purple.gradient)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .fill(Color.orange.gradient)
                                .frame(width: 80, height: 80)
                            
                            Text("Front")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        
                        Text("ZStack layers views on top of each other")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Grid Demo
                GroupBox("Grid Layout") {
                    VStack {
                        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                ForEach(1...4, id: \.self) { number in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.red.gradient)
                                        .frame(height: 40)
                                        .overlay(Text("\(number)").foregroundColor(.white))
                                }
                            }
                            
                            GridRow {
                                ForEach(5...8, id: \.self) { number in
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.blue.gradient)
                                        .frame(height: 40)
                                        .overlay(Text("\(number)").foregroundColor(.white))
                                }
                            }
                        }
                        
                        Text("Grid provides structured 2D layout")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // GroupBox Demo
                GroupBox("GroupBox Container") {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("This is content inside a GroupBox")
                        Text("GroupBox groups related content with optional title")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Divider()
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Grouped content item")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
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
            
            Text("Explore various layout and navigation components available in SwiftUI for macOS")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct DetailView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
            
            Text("Detail View")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a detail view reached via NavigationLink")
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Detail")
    }
}

struct SheetContentView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Modal Sheet")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("This is a modal sheet presentation")
                .font(.body)
                .foregroundColor(.secondary)
            
            Button("Dismiss") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding()
        .frame(minWidth: 300, minHeight: 200)
    }
}

#Preview {
    NavigationStack {
        LayoutNavigationDemoView()
    }
}
