//
//  GestureRecognizersDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct GestureRecognizersDemoView: View {
    @State private var dragOffset = CGSize.zero
    @State private var rotationAngle: Angle = .zero
    @State private var currentScale: CGFloat = 1.0
    @State private var finalScale: CGFloat = 1.0
    @State private var tapCount = 0
    @State private var longPressActivated = false
    @State private var gestureLog: [String] = []
    @State private var combinedOffset = CGSize.zero
    @State private var combinedRotation: Angle = .zero
    @State private var combinedScale: CGFloat = 1.0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Gesture Recognizers")
                
                basicGesturesSection
                complexGesturesSection
                combinedGesturesSection
                gestureLogSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Gesture Recognizers")
    }
    
    private var basicGesturesSection: some View {
        demoSection("Basic Gestures") {
            VStack(spacing: 20) {
                GroupBox("Tap Gestures") {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.blue.gradient)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("\(tapCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                            .scaleEffect(longPressActivated ? 1.2 : 1.0)
                            .onTapGesture {
                                tapCount += 1
                                addToLog("Single tap - Count: \(tapCount)")
                                
                                // Visual feedback
                                withAnimation(.easeInOut(duration: 0.1)) {
                                    // Small bounce effect
                                }
                            }
                            .onTapGesture(count: 2) {
                                tapCount = 0
                                addToLog("Double tap - Reset count")
                            }
                            .onLongPressGesture(minimumDuration: 1.0) {
                                longPressActivated.toggle()
                                addToLog("Long press - Activated: \(longPressActivated)")
                            }
                            .animation(.spring(), value: longPressActivated)
                        
                        VStack(spacing: 8) {
                            Text("• Single tap to increment")
                            Text("• Double tap to reset")
                            Text("• Long press to toggle size")
                        }
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Drag Gesture") {
                    VStack(spacing: 15) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.green.gradient)
                            .frame(width: 80, height: 80)
                            .offset(dragOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                        addToLog("Dragging: (\(Int(value.translation.width)), \(Int(value.translation.height)))")
                                    }
                                    .onEnded { value in
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                        addToLog("Drag ended - Return to center")
                                    }
                            )
                        
                        Button("Reset Position") {
                            withAnimation(.spring()) {
                                dragOffset = .zero
                            }
                            addToLog("Position reset manually")
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Drag the square around")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 200)
                }
            }
        }
    }
    
    private var complexGesturesSection: some View {
        demoSection("Complex Gestures") {
            VStack(spacing: 20) {
                GroupBox("Rotation Gesture") {
                    VStack(spacing: 15) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 60))
                            .foregroundColor(.purple)
                            .rotationEffect(rotationAngle)
                            .gesture(
                                RotationGesture()
                                    .onChanged { angle in
                                        rotationAngle = angle
                                        addToLog("Rotating: \(Int(angle.degrees))°")
                                    }
                                    .onEnded { angle in
                                        addToLog("Rotation ended at: \(Int(angle.degrees))°")
                                    }
                            )
                        
                        Button("Reset Rotation") {
                            withAnimation(.spring()) {
                                rotationAngle = .zero
                            }
                            addToLog("Rotation reset")
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Use rotation gesture on the icon")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Magnification Gesture") {
                    VStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                            .scaleEffect(finalScale + currentScale - 1)
                            .gesture(
                                MagnificationGesture()
                                    .onChanged { scale in
                                        currentScale = scale
                                        addToLog("Scaling: \(String(format: "%.2f", scale))")
                                    }
                                    .onEnded { scale in
                                        finalScale *= scale
                                        currentScale = 1.0
                                        addToLog("Final scale: \(String(format: "%.2f", finalScale))")
                                    }
                            )
                        
                        HStack {
                            Button("Reset Scale") {
                                withAnimation(.spring()) {
                                    finalScale = 1.0
                                    currentScale = 1.0
                                }
                                addToLog("Scale reset")
                            }
                            .buttonStyle(.bordered)
                            
                            Text("Scale: \(String(format: "%.2f", finalScale + currentScale - 1))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Use pinch gesture to scale")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Sequence Gesture") {
                    VStack(spacing: 15) {
                        Text("Hold & Drag")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 120, height: 60)
                            .background(.red.gradient)
                            .cornerRadius(12)
                            .offset(dragOffset)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.5)
                                    .sequenced(before: DragGesture())
                                    .onChanged { value in
                                        switch value {
                                        case .first(true):
                                            addToLog("Long press detected - drag enabled")
                                        case .second(true, let drag):
                                            if let drag = drag {
                                                dragOffset = drag.translation
                                                addToLog("Dragging after long press")
                                            }
                                        default:
                                            break
                                        }
                                    }
                                    .onEnded { _ in
                                        withAnimation(.spring()) {
                                            dragOffset = .zero
                                        }
                                        addToLog("Sequence gesture ended")
                                    }
                            )
                        
                        Text("Long press first, then drag")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 150)
                }
            }
        }
    }
    
    private var combinedGesturesSection: some View {
        demoSection("Combined Gestures") {
            VStack(spacing: 20) {
                GroupBox("Multi-Gesture View") {
                    VStack(spacing: 15) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.mint.gradient)
                                .frame(width: 120, height: 120)
                                .overlay(
                                    VStack {
                                        Image(systemName: "hand.draw")
                                            .font(.title)
                                        Text("Multi")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                    }
                                    .foregroundColor(.white)
                                )
                        }
                        .offset(combinedOffset)
                        .rotationEffect(combinedRotation)
                        .scaleEffect(combinedScale)
                        .gesture(
                            SimultaneousGesture(
                                DragGesture(),
                                SimultaneousGesture(
                                    RotationGesture(),
                                    MagnificationGesture()
                                )
                            )
                            .onChanged { value in
                                combinedOffset = value.first?.translation ?? combinedOffset
                                combinedRotation = value.second?.first ?? combinedRotation
                                
                                if let magnification = value.second?.second {
                                    combinedScale = magnification
                                }
                                
                                addToLog("Multi-gesture active")
                            }
                            .onEnded { _ in
                                addToLog("Multi-gesture ended")
                            }
                        )
                        
                        Button("Reset All") {
                            withAnimation(.spring()) {
                                combinedOffset = .zero
                                combinedRotation = .zero
                                combinedScale = 1.0
                            }
                            addToLog("All combined gestures reset")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("Drag, rotate, and scale simultaneously")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 250)
                }
                
                GroupBox("Exclusive Gestures") {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.indigo.gradient)
                            .frame(width: 80, height: 80)
                            .overlay(
                                Text("Tap\nor\nDrag")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                            )
                            .offset(dragOffset)
                            .gesture(
                                ExclusiveGesture(
                                    TapGesture()
                                        .onEnded {
                                            addToLog("Exclusive tap gesture")
                                            withAnimation(.spring()) {
                                                // Add bounce effect
                                            }
                                        },
                                    DragGesture()
                                        .onChanged { value in
                                            dragOffset = value.translation
                                            addToLog("Exclusive drag gesture")
                                        }
                                        .onEnded { _ in
                                            withAnimation(.spring()) {
                                                dragOffset = .zero
                                            }
                                        }
                                )
                            )
                        
                        Text("Either tap OR drag (exclusive)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(height: 150)
                }
            }
        }
    }
    
    private var gestureLogSection: some View {
        demoSection("Gesture Log") {
            VStack(spacing: 20) {
                GroupBox("Real-time Gesture Events") {
                    VStack(spacing: 15) {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 4) {
                                ForEach(gestureLog.suffix(10).reversed(), id: \.self) { logEntry in
                                    HStack {
                                        Circle()
                                            .fill(.blue)
                                            .frame(width: 6, height: 6)
                                        
                                        Text(logEntry)
                                            .font(.caption)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 120)
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(8)
                        
                        HStack {
                            Button("Clear Log") {
                                gestureLog.removeAll()
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            Text("\(gestureLog.count) events")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Text("Shows the last 10 gesture events")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Gesture Testing Area") {
                    VStack(spacing: 15) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.gray.opacity(0.1))
                                .frame(height: 100)
                                .overlay(
                                    Text("Test any gesture here")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                )
                                .gesture(
                                    DragGesture()
                                        .onChanged { _ in
                                            addToLog("Test area: Drag gesture")
                                        }
                                )
                                .onTapGesture {
                                    addToLog("Test area: Tap gesture")
                                }
                                .onLongPressGesture {
                                    addToLog("Test area: Long press gesture")
                                }
                        }
                        
                        Text("Try different gestures in the area above")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func addToLog(_ message: String) {
        let timestamp = DateFormatter()
        timestamp.dateFormat = "HH:mm:ss"
        let logEntry = "[\(timestamp.string(from: Date()))] \(message)"
        
        gestureLog.append(logEntry)
        
        // Keep only the last 50 entries
        if gestureLog.count > 50 {
            gestureLog.removeFirst()
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
            
            Text("Advanced gesture handling with tap, drag, rotation, scaling, and combined gestures")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        GestureRecognizersDemoView()
    }
}
