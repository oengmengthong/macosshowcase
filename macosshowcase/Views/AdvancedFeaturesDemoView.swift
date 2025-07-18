//
//  AdvancedFeaturesDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct CustomViewModifier: ViewModifier {
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.controlBackgroundColor))
            .cornerRadius(cornerRadius)
            .shadow(radius: shadowRadius)
    }
}

extension View {
    func cardStyle(cornerRadius: CGFloat = 8, shadowRadius: CGFloat = 2) -> some View {
        modifier(CustomViewModifier(cornerRadius: cornerRadius, shadowRadius: shadowRadius))
    }
}

struct GeometryReader3D: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("Size: \(Int(geometry.size.width)) × \(Int(geometry.size.height))")
                    .font(.headline)
                
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(
                        width: geometry.size.width * 0.8,
                        height: geometry.size.height * 0.6
                    )
                    .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct AdvancedFeaturesDemoView: View {
    @State private var asyncResult: String = "Loading..."
    @State private var isTaskRunning = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Advanced Features")
                
                customViewsSection
                performanceSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Advanced Features")
        .task {
            await loadAsyncData()
        }
    }
    
    private var customViewsSection: some View {
        demoSection("Custom Views & Modifiers") {
            VStack(spacing: 20) {
                GroupBox("Custom ViewModifier") {
                    VStack(spacing: 15) {
                        Text("Standard View")
                            .padding()
                            .background(Color.gray.opacity(0.2))
                        
                        Text("With Custom Modifier")
                            .cardStyle()
                        
                        Text("Custom Styling")
                            .cardStyle(cornerRadius: 16, shadowRadius: 5)
                        
                        Text("Reusable view modifiers via extension")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("ViewBuilder Custom View") {
                    VStack(spacing: 15) {
                        CustomCardView(title: "Card 1", content: "First card content")
                        CustomCardView(title: "Card 2", content: "Second card content")
                        
                        Text("Custom views with @ViewBuilder for flexible content")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("GeometryReader") {
                    GeometryReader3D()
                        .frame(height: 200)
                        .cardStyle()
                }
            }
        }
    }
    
    private var performanceSection: some View {
        demoSection("Performance & Lifecycle") {
            VStack(spacing: 20) {
                GroupBox("Async Task Management") {
                    VStack(spacing: 15) {
                        HStack {
                            Text("Async Result:")
                                .font(.headline)
                            Spacer()
                            if isTaskRunning {
                                ProgressView()
                                    .scaleEffect(0.7)
                            }
                        }
                        
                        Text(asyncResult)
                            .padding()
                            .background(Color(.controlBackgroundColor))
                            .cornerRadius(8)
                        
                        Button("Reload Data") {
                            Task {
                                await loadAsyncData()
                            }
                        }
                        .disabled(isTaskRunning)
                        
                        Text("Async/await with .task() modifier")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("LazyVStack Performance") {
                    VStack(spacing: 15) {
                        Text("Efficient list rendering:")
                            .font(.headline)
                        
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(1...100, id: \.self) { number in
                                    HStack {
                                        Text("Item \(number)")
                                        Spacer()
                                        Text("Lazy loaded")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(8)
                                    .background(Color(.controlBackgroundColor))
                                    .cornerRadius(4)
                                    .onAppear {
                                        print("Item \(number) appeared")
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .frame(height: 200)
                        
                        Text("LazyVStack only renders visible items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Lifecycle Events") {
                    VStack(spacing: 15) {
                        LifecycleView()
                        
                        Text("View lifecycle with onAppear/onDisappear")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private func loadAsyncData() async {
        isTaskRunning = true
        asyncResult = "Loading..."
        
        // Simulate network request
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        asyncResult = "Data loaded successfully at \(Date().formatted(.dateTime.hour().minute().second()))"
        isTaskRunning = false
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
            
            Text("Advanced SwiftUI patterns, custom views, and performance optimization")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

struct CustomCardView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(content)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .cardStyle()
    }
}

struct LifecycleView: View {
    @State private var appearCount = 0
    @State private var disappearCount = 0
    @State private var isVisible = true
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Appear: \(appearCount)")
                Spacer()
                Text("Disappear: \(disappearCount)")
            }
            .font(.caption)
            
            Button(isVisible ? "Hide" : "Show") {
                isVisible.toggle()
            }
            
            if isVisible {
                Rectangle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(height: 50)
                    .overlay(Text("Lifecycle View"))
                    .onAppear {
                        appearCount += 1
                    }
                    .onDisappear {
                        disappearCount += 1
                    }
            }
        }
        .padding()
        .background(Color(.controlBackgroundColor))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        AdvancedFeaturesDemoView()
    }
}
