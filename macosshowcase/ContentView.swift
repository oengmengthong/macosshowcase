//
//  ContentView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundColor(.orange)
            
            Text("macOS SwiftUI Showcase")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("A comprehensive demonstration of SwiftUI components and features for macOS development")
                .font(.title3)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                Label("9 Complete Demo Categories", systemImage: "rectangle.3.group")
                Label("100+ UI Components", systemImage: "slider.horizontal.3")
                Label("SwiftData Integration", systemImage: "cylinder")
                Label("macOS-Specific Features", systemImage: "macwindow")
                Label("Real Working Examples", systemImage: "play.circle")
            }
            .font(.headline)
            .foregroundColor(.blue)
            
            Text("Use this app as a reference for building modern macOS applications with SwiftUI")
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
