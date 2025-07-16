//
//  File.swift
//  SwiftUIMaps
//
//  Created by Ibrahim Mo Gedami on 02/07/2025.
//

import SwiftUI

struct VerifyEmployeeView: View {
    
    @State private var name = ""
    @State private var password = ""
    @State private var reason = ""
    @State private var isShaking = false
    @State private var isVerifying = false
    @State private var showForm = false
    @Environment(\.dismiss) var dismiss
    @State private var showEmployeeList = false

    var body: some View {
        ZStack {
            // Background Gradient
//            LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color.black.opacity(0.08),
//                        Color.black.opacity(0.15)
//                    ]),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//                .ignoresSafeArea()
//                .background(.ultraThinMaterial)
            
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.25),
                    Color.black.opacity(0.45)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("Verify Identity")
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                    .padding(.top, 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .animation(.easeOut.delay(0.2), value: showForm)

                VStack(spacing: 16) {
                    FloatingInput(
                        title: "Employee Name",
                        text: $name,
                        isEditable: false,
                        rightView: {
                            Button {
                                showEmployeeList = true
                            } label: {
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    )
                    .sheet(isPresented: $showEmployeeList) {
                        EmployeeListView(selected: $name)
                    }
                    FloatingInput(title: "Password", text: $password, isSecure: true)
                    FloatingInput(title: "Reason for Verification", text: $reason)
                }
                .offset(x: isShaking ? -8 : 0)
                .animation(isShaking ? .default.repeatCount(3, autoreverses: true) : .default, value: isShaking)

                HStack(spacing: 14) {
                    GlassButton(
                        title: "Cancel",
                        background: .regularMaterial,
                        foreground: .primary,
                        border: Color.gray.opacity(0.3)
                    ) {
                        dismiss()
                    }

                    GlassButton(title: isVerifying ? "" : "Verify", background: .ultraThickMaterial, foreground: .blue, isLoading: isVerifying) {
                        verify()
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .background(.regularMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                    .cornerRadius(10)
            )
            .padding()
            .scaleEffect(showForm ? 1 : 0.95)
            .opacity(showForm ? 1 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showForm)
        }
        .onAppear {
            showForm = true
        }
    }

    private func verify() {
        guard !name.isEmpty, !password.isEmpty, !reason.isEmpty else {
            isShaking = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isShaking = false
            }
            return
        }

        isVerifying = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isVerifying = false
            dismiss()
        }
    }
    
}

struct FloatingInput: View {
    let title: String
    @Binding var text: String
    var isSecure: Bool = false
    var isEditable: Bool = true
    var rightView: AnyView? = nil  // Optional View as a stored property

    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(isFocused ? .accentColor : .gray)

            HStack(spacing: 8) {
                if isSecure {
                    Group {
                        if isPasswordVisible {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    }
                    .focused($isFocused)
                } else {
                    TextField("", text: $text)
                        .disabled(!isEditable)
                        .focused($isFocused)
                }

                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                } else if let rightView {
                    rightView
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isFocused ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 1.2)
                    )
            )
            .shadow(color: isFocused ? Color.accentColor.opacity(0.2) : .clear, radius: 5)
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

struct GlassButton: View {
    
    var title: String
    var background: Material
    var foreground: Color
    var border: Color = .clear
    var isLoading: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foreground))
                } else {
                    Text(title)
                        .font(.headline)
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(background)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(border, lineWidth: 1)
                    )
            )
            .foregroundColor(foreground)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    VerifyEmployeeView()
}

struct EmployeeListView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selected: String
    
    let employees = ["Alice", "Bob", "Charlie", "Diana"]
    
    var body: some View {
        NavigationStack {
            List(employees, id: \.self) { employee in
                Button {
                    selected = employee
                    dismiss()
                } label: {
                    HStack {
                        Text(employee)
                        if selected == employee {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Employee")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension FloatingInput {
    init(
        title: String,
        text: Binding<String>,
        isSecure: Bool = false,
        isEditable: Bool = true,
        @ViewBuilder rightView: () -> some View
    ) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.rightView = AnyView(rightView())
    }

    init(
        title: String,
        text: Binding<String>,
        isSecure: Bool = false,
        isEditable: Bool = true
    ) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
        self.isEditable = isEditable
        self.rightView = nil
    }
}
