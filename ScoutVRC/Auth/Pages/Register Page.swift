//
//  Register Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/15/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct Register_Page: View {
    // Text Controllers
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var team: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    // Alert State
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Classes
    @StateObject var togglePages = TogglePages()
    
    func signUpWithEmail() {
        if password == confirmPassword {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as NSError? {
                    // Return feedback for incorrect email / password
                    alertTitle = "Error"
                    alertMessage = error.localizedDescription
                    showAlert = true
                } else {
                    // Create a new user dictionary
                    let user: [String: Any] = [
                        "email": email,
                        "username": username,
                        "team number": team,
                        "match notifications": false,
                        "message notifications": false
                    ]
                    
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    // Add a new document with a generated ID to the "users" collection
                    Firestore.firestore().collection("users").document(userID).setData(user)
                }
            }
        } else {
            // Show alert for passwords not matching
            alertTitle = "Error"
            alertMessage = "Passwords Do Not Match"
            showAlert = true
        }
    }
    
    
    var body: some View {
        NavigationView {
            // Content
            VStack {
                // Page Name and Message
                Group {
                    // Page Name
                    Text("R E G I S T E R")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    
                    // Spacing for UI
                    Spacer().frame(height: 5)
                    
                    // Welcome Message
                    Text("Let's create an account for you!")
                        .font(.system(size: 14))
                        .fontWeight(.none)
                    
                    // Spacing for UI
                    Spacer().frame(height: 30)
                }
                
                // Login and Password Text Fields
                Group {
                    // Email Field
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 15)
                    
                    // Username Field
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 15)
                    
                    // Team Field
                    TextField("Team Number", text: $team)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 15)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 15)
                    
                    // Confirm Password Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 30)
                }
                
                // Register Button
                Button(action: {
                    signUpWithEmail()
                }) {
                    Text("R E G I S T E R")
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .fontWeight(.bold)
                }.padding(.horizontal, 28)
                
                // Register Redirect
                Group {
                    // Spacing for UI
                    Spacer().frame(height: 50)
                    
                    HStack {
                        // Message
                        Text("Already Have an Account?")
                            .font(.system(size: 15))
                        
                        // Button
                        Button(action: {
                            togglePages.togglePage()
                        }) {
                            Text("Login Now!")
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                        }
                    }
                }
            }.padding(.horizontal, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        }
    }
}

#Preview {
    Register_Page()
}
