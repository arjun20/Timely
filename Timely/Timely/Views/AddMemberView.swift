//
//  AddMemberView.swift
//  Timely
//
//  Created by Arjun Gautami on 07/09/25.
//

import SwiftUI

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var memberName = ""
    @State private var memberEmail = ""
    @State private var memberPhone = ""
    @State private var isAdmin = false
    
    let onMemberAdded: (GroupMember) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppWideBackgroundView(showFloatingParticles: true, particleCount: 4)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 8) {
                            Text("Add Group Member")
                                .timelyStyle(.largeTitle)
                            
                            Text("Add a friend to your group")
                                .timelyStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Member Details Card
                        VStack(spacing: 20) {
                            // Name
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Name *")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Enter member's name", text: $memberName)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                            }
                            
                            // Email
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Email (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Enter email address", text: $memberEmail)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            
                            // Phone
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Phone (Optional)")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                TextField("Enter phone number", text: $memberPhone)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.body)
                                    .keyboardType(.phonePad)
                            }
                            
                            // Admin Toggle
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Group Admin")
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Admins can manage group settings")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isAdmin)
                                    .toggleStyle(SwitchToggleStyle(tint: .timelyBlue))
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.timelyCardBackground)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                                )
                        )
                        .timelyCardShadow()
                        .padding(.horizontal)
                        
                        // Add Member Button
                        Button(action: addMember) {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                Text("Add Member")
                            }
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(canAddMember ? Color.timelyBlue : Color.gray)
                            )
                            .timelyButtonShadow()
                        }
                        .disabled(!canAddMember)
                        .padding(.horizontal)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            .navigationTitle("Add Member")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.timelyBlue)
                }
            }
        }
    }
    
    private var canAddMember: Bool {
        !memberName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func addMember() {
        let newMember = GroupMember(
            name: memberName.trimmingCharacters(in: .whitespacesAndNewlines),
            email: memberEmail.isEmpty ? nil : memberEmail.trimmingCharacters(in: .whitespacesAndNewlines),
            phoneNumber: memberPhone.isEmpty ? nil : memberPhone.trimmingCharacters(in: .whitespacesAndNewlines),
            isAdmin: isAdmin
        )
        
        HapticFeedback.shared.success()
        onMemberAdded(newMember)
        dismiss()
    }
}

#Preview {
    AddMemberView { _ in }
}
