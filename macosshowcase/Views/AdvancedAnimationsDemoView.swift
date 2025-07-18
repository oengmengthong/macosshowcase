//
//  AdvancedAnimationsDemoView.swift
//  macosshowcase
//
//  Created by Mengthong on 18/7/25.
//

import SwiftUI

struct AdvancedAnimationsDemoView: View {
    @State private var rotationAngle: Double = 0
    @State private var scaleValue: Double = 1.0
    @State private var springOffset: CGSize = .zero
    @State private var showingModal = false
    @State private var isAnimating = false
    @State private var morphShape = false
    @State private var cardFlipped = false
    @State private var particleAnimation = false
    @State private var wavePhase: Double = 0
    @State private var breathingScale: Double = 1.0
    @State private var glowIntensity: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                headerSection("Advanced Animations")
                
                basicAnimationsSection
                springAnimationsSection
                customAnimationsSection
                complexAnimationsSection
                
                Spacer(minLength: 50)
            }
            .padding()
        }
        .navigationTitle("Advanced Animations")
        .onAppear {
            startContinuousAnimations()
        }
    }
    
    private var basicAnimationsSection: some View {
        demoSection("Basic Animation Types") {
            VStack(spacing: 20) {
                GroupBox("Rotation & Scale") {
                    VStack(spacing: 20) {
                        HStack(spacing: 30) {
                            // Rotating square
                            Rectangle()
                                .fill(.blue.gradient)
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(rotationAngle))
                                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: rotationAngle)
                            
                            // Scaling circle
                            Circle()
                                .fill(.green.gradient)
                                .frame(width: 60, height: 60)
                                .scaleEffect(scaleValue)
                                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: scaleValue)
                        }
                        
                        HStack {
                            Button("Start Rotation") {
                                rotationAngle = 360
                            }
                            
                            Button("Start Scaling") {
                                scaleValue = scaleValue == 1.0 ? 1.5 : 1.0
                            }
                        }
                        
                        Text("Linear rotation and easing scale animations")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Easing Curves Comparison") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            AnimationBar(title: "Linear", animation: .linear(duration: 1), isAnimating: $isAnimating)
                            AnimationBar(title: "Ease In", animation: .easeIn(duration: 1), isAnimating: $isAnimating)
                            AnimationBar(title: "Ease Out", animation: .easeOut(duration: 1), isAnimating: $isAnimating)
                            AnimationBar(title: "Ease In Out", animation: .easeInOut(duration: 1), isAnimating: $isAnimating)
                        }
                        
                        Button("Compare Easing Curves") {
                            isAnimating.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("Different easing curves side by side")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var springAnimationsSection: some View {
        demoSection("Spring Animations") {
            VStack(spacing: 20) {
                GroupBox("Interactive Spring") {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.purple.gradient)
                            .frame(width: 60, height: 60)
                            .offset(springOffset)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: springOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        springOffset = value.translation
                                    }
                                    .onEnded { _ in
                                        springOffset = .zero
                                    }
                            )
                        
                        Text("Drag the circle to see spring animation")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Button("Bounce Left") {
                                springOffset = CGSize(width: -100, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    springOffset = .zero
                                }
                            }
                            
                            Button("Bounce Right") {
                                springOffset = CGSize(width: 100, height: 0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    springOffset = .zero
                                }
                            }
                        }
                    }
                    .frame(height: 150)
                }
                
                GroupBox("Spring Presets") {
                    VStack(spacing: 15) {
                        HStack(spacing: 20) {
                            SpringDemoView(title: "Bouncy", spring: .bouncy, isTriggered: $isAnimating)
                            SpringDemoView(title: "Snappy", spring: .snappy, isTriggered: $isAnimating)
                            SpringDemoView(title: "Smooth", spring: .smooth, isTriggered: $isAnimating)
                        }
                        
                        Button("Test Spring Presets") {
                            isAnimating.toggle()
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Built-in spring animation presets")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var customAnimationsSection: some View {
        demoSection("Custom Animations") {
            VStack(spacing: 20) {
                GroupBox("Morphing Shapes") {
                    VStack(spacing: 15) {
                        ZStack {
                            if morphShape {
                                Circle()
                                    .fill(.orange.gradient)
                                    .frame(width: 100, height: 100)
                                    .transition(.scale.combined(with: .opacity))
                            } else {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.blue.gradient)
                                    .frame(width: 100, height: 60)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .animation(.easeInOut(duration: 0.8), value: morphShape)
                        
                        Button("Morph Shape") {
                            morphShape.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Text("Shape morphing with combined transitions")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("3D Card Flip") {
                    VStack(spacing: 15) {
                        ZStack {
                            // Front of card
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.blue.gradient)
                                .frame(width: 120, height: 80)
                                .overlay(
                                    Text("Front")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                )
                                .rotation3DEffect(
                                    .degrees(cardFlipped ? 90 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(cardFlipped ? 0 : 1)
                            
                            // Back of card
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.gradient)
                                .frame(width: 120, height: 80)
                                .overlay(
                                    Text("Back")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                )
                                .rotation3DEffect(
                                    .degrees(cardFlipped ? 0 : -90),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(cardFlipped ? 1 : 0)
                        }
                        .animation(.easeInOut(duration: 0.6), value: cardFlipped)
                        
                        Button("Flip Card") {
                            cardFlipped.toggle()
                        }
                        .buttonStyle(.bordered)
                        
                        Text("3D rotation with perspective")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Breathing Effect") {
                    VStack(spacing: 15) {
                        Circle()
                            .fill(.mint.gradient)
                            .frame(width: 80, height: 80)
                            .scaleEffect(breathingScale)
                            .shadow(color: .mint.opacity(glowIntensity), radius: 20)
                            .onAppear {
                                startBreathingAnimation()
                            }
                        
                        Text("Continuous breathing animation with glow")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    private var complexAnimationsSection: some View {
        demoSection("Complex Animations") {
            VStack(spacing: 20) {
                GroupBox("Wave Animation") {
                    VStack(spacing: 15) {
                        WaveShape(phase: wavePhase)
                            .fill(.blue.gradient)
                            .frame(height: 100)
                            .clipped()
                            .onAppear {
                                startWaveAnimation()
                            }
                        
                        Text("Continuous wave animation using custom shape")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Particle System") {
                    VStack(spacing: 15) {
                        ZStack {
                            ForEach(0..<8, id: \.self) { index in
                                Circle()
                                    .fill(.yellow.gradient)
                                    .frame(width: 12, height: 12)
                                    .offset(
                                        x: particleAnimation ? cos(Double(index) * .pi / 4) * 60 : 0,
                                        y: particleAnimation ? sin(Double(index) * .pi / 4) * 60 : 0
                                    )
                                    .opacity(particleAnimation ? 0.3 : 1.0)
                                    .animation(
                                        .easeOut(duration: 1.5)
                                        .delay(Double(index) * 0.1)
                                        .repeatForever(autoreverses: true),
                                        value: particleAnimation
                                    )
                            }
                            
                            Circle()
                                .fill(.orange.gradient)
                                .frame(width: 20, height: 20)
                        }
                        .frame(width: 150, height: 150)
                        .onAppear {
                            particleAnimation = true
                        }
                        
                        Text("Particle explosion with staggered delays")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Sequential Animation") {
                    VStack(spacing: 15) {
                        HStack(spacing: 10) {
                            ForEach(0..<5, id: \.self) { index in
                                Rectangle()
                                    .fill(.purple.gradient)
                                    .frame(width: 20, height: 20)
                                    .scaleEffect(isAnimating ? 1.5 : 1.0)
                                    .animation(
                                        .easeInOut(duration: 0.3)
                                        .delay(Double(index) * 0.1)
                                        .repeatForever(autoreverses: true),
                                        value: isAnimating
                                    )
                            }
                        }
                        
                        Button("Start Sequence") {
                            isAnimating.toggle()
                        }
                        .buttonStyle(.bordered)
                        
                        Text("Sequential animation with staggered timing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                GroupBox("Animation Controls") {
                    VStack(spacing: 15) {
                        HStack {
                            Button("Reset All") {
                                resetAllAnimations()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Start All") {
                                startAllAnimations()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        
                        Text("Control all animations simultaneously")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func startContinuousAnimations() {
        rotationAngle = 360
        scaleValue = 1.5
        startBreathingAnimation()
        startWaveAnimation()
        particleAnimation = true
    }
    
    private func startBreathingAnimation() {
        withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
            breathingScale = 1.3
            glowIntensity = 0.8
        }
    }
    
    private func startWaveAnimation() {
        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            wavePhase = .pi * 2
        }
    }
    
    private func resetAllAnimations() {
        rotationAngle = 0
        scaleValue = 1.0
        springOffset = .zero
        morphShape = false
        cardFlipped = false
        isAnimating = false
        particleAnimation = false
        breathingScale = 1.0
        glowIntensity = 0
        wavePhase = 0
    }
    
    private func startAllAnimations() {
        startContinuousAnimations()
        isAnimating = true
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
            
            Text("Complex animation patterns with spring physics, morphing, and particle effects")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Supporting Views

struct AnimationBar: View {
    let title: String
    let animation: Animation
    @Binding var isAnimating: Bool
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(.blue.gradient)
                .frame(width: 8, height: 40)
                .offset(y: offset)
                .animation(animation.repeatForever(autoreverses: true), value: isAnimating)
                .onChange(of: isAnimating) { _, newValue in
                    offset = newValue ? -20 : 0
                }
        }
    }
}

struct SpringDemoView: View {
    let title: String
    let spring: Animation
    @Binding var isTriggered: Bool
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
            
            Circle()
                .fill(.green.gradient)
                .frame(width: 30, height: 30)
                .scaleEffect(scale)
                .animation(spring, value: scale)
                .onChange(of: isTriggered) { _, _ in
                    scale = scale == 1.0 ? 1.5 : 1.0
                }
        }
    }
}

struct WaveShape: Shape {
    var phase: Double
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin((relativeX * .pi * 4) + phase)
            let y = midHeight + sine * (height * 0.3)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    NavigationStack {
        AdvancedAnimationsDemoView()
    }
}
