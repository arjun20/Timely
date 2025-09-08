//
//  GroupSelectionView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct GroupSelectionView: View {
    @EnvironmentObject var viewModel: EventViewModel
    @State private var groups: [Timely.Group] = []
    @State private var showingCreateGroup = false
    @State private var selectedGroup: Timely.Group?
    @State private var showingGroupDetail = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 8)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Choose Your Group")
                                .timelyStyle(.largeTitle)
                            
                            Text("Select a group to find available times together")
                                .timelyStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Groups Grid
                        if groups.isEmpty {
                            EmptyStateView(
                                icon: "👥",
                                title: "No Groups Yet",
                                message: "Create your first group to start finding time together with friends!"
                            )
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(groups) { group in
                                    GroupCard(
                                        group: group,
                                        isSelected: selectedGroup?.id == group.id
                                    ) {
                                        selectGroup(group)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Create New Group Button
                        Button(action: {
                            showingCreateGroup = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Create New Group")
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
                                            colors: [.timelyBlue, .timelyGreen],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .timelyButtonShadow()
                        }
                        .padding(.horizontal)
                        
                        // Continue Button (when group is selected)
                        if selectedGroup != nil {
                            Button(action: {
                                showingGroupDetail = true
                            }) {
                                HStack {
                                    Text("Continue with \(selectedGroup?.name ?? "Group")")
                                    Image(systemName: "arrow.right")
                                }
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(selectedGroup?.color.color ?? .timelyBlue)
                                )
                                .timelyButtonShadow()
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Groups")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            loadGroups()
        }
        .sheet(isPresented: $showingCreateGroup) {
            CreateGroupView { newGroup in
                groups.append(newGroup)
                saveGroups()
            }
        }
        .sheet(isPresented: $showingGroupDetail) {
            if let group = selectedGroup {
                GroupDetailView(group: group) {
                    // Handle group actions
                }
            }
        }
    }
    
    private func selectGroup(_ group: Timely.Group) {
        HapticFeedback.shared.selection()
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedGroup = group
        }
    }
    
    private func loadGroups() {
        // Load groups from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "saved_groups"),
           let decodedGroups = try? JSONDecoder().decode([Timely.Group].self, from: data) {
            groups = decodedGroups
        }
    }
    
    private func saveGroups() {
        if let encoded = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(encoded, forKey: "saved_groups")
        }
    }
}

struct GroupCard: View {
    let group: Timely.Group
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Group Icon
                ZStack {
                    Circle()
                        .fill(group.color.color.opacity(0.2))
                        .frame(width: 60, height: 60)
                    
                    Text(group.color.emoji)
                        .font(.title)
                }
                
                // Group Info
                VStack(spacing: 4) {
                    Text(group.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("\(group.members.count) member\(group.members.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? group.color.color.opacity(0.1) : Color.timelyCardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? group.color.color : Color.secondary.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .timelyCardShadow()
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    GroupSelectionView()
        .environmentObject(EventViewModel())
}
