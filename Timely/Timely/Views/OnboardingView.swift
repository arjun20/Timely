//
//  OnboardingView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    private let pages = [
        OnboardingPage(
            icon: "📅",
            title: "Find Perfect Times",
            description: "Quickly discover when everyone is free to meet up",
            color: Color.timelyBlue
        ),
        OnboardingPage(
            icon: "☕️",
            title: "Choose Activities",
            description: "Pick from curated event cards or create your own",
            color: Color.timelyPurple
        ),
        OnboardingPage(
            icon: "🎉",
            title: "Confirm & Meet",
            description: "Send invites and add events to everyone's calendar",
            color: Color.timelyGreen
        )
    ]
    
    var body: some View {
        if showMainApp {
            ContentView()
        } else {
            ZStack {
                EnhancedBackgroundView(showParticles: true, particleCount: 4)
                
                VStack(spacing: 0) {
                    // Page Content
                    TabView(selection: $currentPage) {
                        ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                            OnboardingPageView(page: page)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentPage)
                    
                    // Bottom Section
                    VStack(spacing: 24) {
                        // Page Indicators
                        HStack(spacing: 8) {
                            ForEach(0..<pages.count, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? Color.timelyBlue : Color.secondary.opacity(0.3))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
                            }
                        }
                        
                        // Action Button
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                withAnimation {
                                    showMainApp = true
                                }
                            }
                        }) {
                            HStack {
                                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                } else {
                                    Image(systemName: "sparkles")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(pages[currentPage].color)
                            )
                            .timelyButtonShadow()
                        }
                        .padding(.horizontal, 32)
                        
                        // Skip Button
                        if currentPage < pages.count - 1 {
                            Button("Skip") {
                                withAnimation {
                                    showMainApp = true
                                }
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Text(page.icon)
                .font(.system(size: 120))
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: page.icon)
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .timelyStyle(.title)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .timelyStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    OnboardingView()
}
