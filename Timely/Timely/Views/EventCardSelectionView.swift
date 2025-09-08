//
//  EventCardSelectionView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct EventCardSelectionView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var selectedCard: EventCard?
    @State private var showingCreateEventCard = false
    let onContinue: () -> Void
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What would you like to do?")
                            .timelyStyle(.largeTitle)
                        
                        Text("Choose an activity and we'll find the perfect time for everyone")
                            .timelyStyle(.secondary)
                    }
                    .padding(.horizontal)
                    
                    // Event Cards Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(viewModel.eventCards) { card in
                            EventCardView(
                                eventCard: card,
                                isSelected: selectedCard?.id == card.id,
                                onTap: {
                                    HapticFeedback.shared.selection()
                                    withAnimation(AnimationConstants.gentleSpring) {
                                        selectedCard = card
                                        viewModel.selectEventCard(card)
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Create Custom Event Card Button
                    Button(action: {
                        showingCreateEventCard = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Create Custom Event")
                        }
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        colors: [.timelyGreen, .timelyBlue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .timelyButtonShadow()
                    }
                    .padding(.horizontal)
                    
                    // Continue Button
                    if selectedCard != nil {
                        VStack(spacing: 16) {
                            Button(action: {
                                onContinue()
                            }) {
                                HStack {
                                    Text("Find Available Times")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color.timelyBlue)
                                )
                                .timelyButtonShadow()
                            }
                            .padding(.horizontal)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Timely")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadEventCards()
            }
        }
        .sheet(isPresented: $showingCreateEventCard) {
            CreateEventCardView { newEventCard in
                // Add the new event card to the view model
                viewModel.addCustomEventCard(newEventCard)
            }
        }
    }
}

#Preview {
    EventCardSelectionView(onContinue: {})
        .environmentObject(EventViewModel())
}
