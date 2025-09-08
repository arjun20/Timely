//
//  EnhancedBackgroundView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EnhancedBackgroundView: View {
    @State private var animateGradient = false
    @State private var animateParticles = false
    @State private var particles: [BackgroundParticle] = []
    
    let showParticles: Bool
    let particleCount: Int
    
    init(showParticles: Bool = true, particleCount: Int = 8) {
        self.showParticles = showParticles
        self.particleCount = particleCount
    }
    
    var body: some View {
        ZStack {
            // Base gradient background
            LinearGradient(
                colors: [
                    Color.timelyBlue.opacity(0.08),
                    Color.timelyGreen.opacity(0.06),
                    Color.timelyOrange.opacity(0.04),
                    Color.timelyBlue.opacity(0.08)
                ],
                startPoint: animateGradient ? .topLeading : .bottomTrailing,
                endPoint: animateGradient ? .bottomTrailing : .topLeading
            )
            .ignoresSafeArea()
            
            // Subtle pattern overlay
            if showParticles {
                GeometryReader { geometry in
                    ForEach(particles) { particle in
                        Circle()
                            .fill(particle.color)
                            .frame(width: particle.size, height: particle.size)
                            .position(particle.position)
                            .opacity(particle.opacity)
                            .blur(radius: particle.blur)
                            .animation(
                                .easeInOut(duration: particle.duration)
                                .repeatForever(autoreverses: true),
                                value: animateParticles
                            )
                    }
                }
                .ignoresSafeArea()
            }
            
            // Subtle mesh gradient overlay
            MeshGradientOverlay()
                .opacity(0.3)
        }
        .onAppear {
            startAnimations()
            if showParticles {
                generateParticles()
            }
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
            animateGradient.toggle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
                animateParticles.toggle()
            }
        }
    }
    
    private func generateParticles() {
        let colors: [Color] = [
            .timelyBlue.opacity(0.15),
            .timelyGreen.opacity(0.12),
            .timelyOrange.opacity(0.1)
        ]
        
        for i in 0..<particleCount {
            let particle = BackgroundParticle(
                id: i,
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                ),
                color: colors.randomElement() ?? .timelyBlue.opacity(0.15),
                size: CGFloat.random(in: 20...60),
                opacity: Double.random(in: 0.1...0.3),
                blur: CGFloat.random(in: 1...3),
                duration: Double.random(in: 4...8)
            )
            particles.append(particle)
        }
    }
}

struct MeshGradientOverlay: View {
    @State private var animate = false
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = geometry.size.width
                let height = geometry.size.height
                
                // Create subtle wave pattern
                path.move(to: CGPoint(x: 0, y: height * 0.3))
                
                for x in stride(from: 0, through: width, by: 20) {
                    let y = height * 0.3 + sin((x / width) * .pi * 2 + (animate ? .pi : 0)) * 30
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [
                        Color.timelyBlue.opacity(0.05),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 10.0).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct BackgroundParticle: Identifiable {
    let id: Int
    var position: CGPoint
    let color: Color
    let size: CGFloat
    let opacity: Double
    let blur: CGFloat
    let duration: Double
}

// MARK: - View Modifier
struct EnhancedBackgroundModifier: ViewModifier {
    let showParticles: Bool
    let particleCount: Int
    
    func body(content: Content) -> some View {
        ZStack {
            EnhancedBackgroundView(showParticles: showParticles, particleCount: particleCount)
            content
        }
    }
}

extension View {
    func enhancedBackground(showParticles: Bool = true, particleCount: Int = 8) -> some View {
        modifier(EnhancedBackgroundModifier(showParticles: showParticles, particleCount: particleCount))
    }
}

#Preview {
    VStack {
        Text("Enhanced Background")
            .font(.title)
            .foregroundColor(.primary)
        Spacer()
    }
    .enhancedBackground()
}
