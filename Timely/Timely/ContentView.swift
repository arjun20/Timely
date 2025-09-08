//
//  ContentView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = EventViewModel()
    @StateObject private var errorHandler = ErrorHandler()
    @State private var currentStep: AppStep = .eventSelection
    @State private var showingSettings = false
    @State private var showingGroups = false
    
    enum AppStep {
        case eventSelection
        case timeSelection
        case confirmation
    }
    
    var body: some View {
        ZStack {
            // Enhanced animated background
            EnhancedBackgroundView(showParticles: true, particleCount: 6)
            
            VStack(spacing: 0) {
                // Header with action buttons
                HStack {
                    Button(action: {
                        showingGroups = true
                    }) {
                        Image(systemName: "person.2.fill")
                            .font(.title2)
                            .foregroundColor(.timelyBlue)
                    }
                    .padding(.leading)
                    .padding(.top, 8)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.timelyBlue)
                    }
                    .padding(.trailing)
                    .padding(.top, 8)
                }
                
                // Progress indicator
                ProgressIndicator(currentStep: currentStep)
                    .padding(.top, 8)
                
                // Main content
                ZStack {
                    switch currentStep {
                    case .eventSelection:
                        EventCardSelectionView(onContinue: {
                            withAnimation {
                                currentStep = .timeSelection
                            }
                        })
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading),
                                removal: .move(edge: .trailing)
                            ))
                    case .timeSelection:
                        TimeSelectionView(onContinue: {
                            withAnimation {
                                currentStep = .confirmation
                            }
                        })
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    case .confirmation:
                        ConfirmationView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: currentStep)
            }
        }
        .environmentObject(viewModel)
        .environmentObject(errorHandler)
        .errorAlert(errorHandler: errorHandler)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showingGroups) {
            GroupSelectionView()
                .environmentObject(viewModel)
        }
        .onReceive(viewModel.$selectedEventCard) { eventCard in
            if eventCard != nil && currentStep == .eventSelection {
                withAnimation {
                    currentStep = .timeSelection
                }
            }
        }
        .onReceive(viewModel.$selectedTimeSlot) { timeSlot in
            if timeSlot != nil && currentStep == .timeSelection {
                withAnimation {
                    currentStep = .confirmation
                }
            }
        }
        .onReceive(viewModel.$selectedEventCard) { eventCard in
            // Reset to home when eventCard is cleared (after going home)
            if eventCard == nil && currentStep != .eventSelection {
                withAnimation {
                    currentStep = .eventSelection
                }
            }
        }
    }
}

struct ProgressIndicator: View {
    let currentStep: ContentView.AppStep
    
    private var steps: [ContentView.AppStep] {
        [.eventSelection, .timeSelection, .confirmation]
    }
    
    private var currentStepIndex: Int {
        steps.firstIndex(of: currentStep) ?? 0
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                Circle()
                    .fill(stepColor(for: step))
                    .frame(width: 8, height: 8)
                    .scaleEffect(currentStep == step ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentStep)
                
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
                        .frame(height: 2)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 32)
        .accessibleProgressIndicator(currentStep: currentStepIndex, totalSteps: steps.count)
    }
    
    private func stepColor(for step: ContentView.AppStep) -> Color {
        let currentIndex = steps.firstIndex(of: currentStep) ?? 0
        let stepIndex = steps.firstIndex(of: step) ?? 0
        
        if stepIndex <= currentIndex {
            return Color.timelyBlue
        } else {
            return Color.secondary.opacity(0.3)
        }
    }
}

#Preview {
    ContentView()
}
