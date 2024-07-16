//
//  Login Page.swift
//  ScoutVRC
//
//  Created by Daksh Gupta on 6/14/24.
//

import SwiftUI
import FirebaseAuth

struct Login_Page: View {
    // Text Controllers
    @State private var email: String = ""
    @State private var password: String = ""
    
    // Alert State
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // Classes
    @StateObject var togglePages = TogglePages()
    
    func signInWithEmail() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if (error as NSError?) != nil {
                // Return feedback for incorrect email / password
                alertTitle = "Error"
                alertMessage = "Invalid Email or Password"
                showAlert = true
            } else {
                // Returns loading circle until redirected
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Content
            VStack {
                // Page Name and Message
                Group {
                    // Page Name
                    Text("L O G I N")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    
                    // Spacing for UI
                    Spacer().frame(height: 5)
                    
                    // Welcome Message
                    Text("Welcome Back! We've missed you!")
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
                    
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(10)
                    
                    // Spacing for UI
                    Spacer().frame(height: 10)
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            togglePages.togglePage()
                        }) {
                            Text("Forgot Password?")
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                        }
                        
                        Spacer().frame(width: 25, height: 0)
                    }
                    
                    // Spacing for UI
                    Spacer().frame(height: 30)

                }
                
                // Login Button
                Button(action: signInWithEmail) {
                    Text("L O G I N")
                        .frame(maxWidth: .greatestFiniteMagnitude)
                        .padding()
                        .background(Color(#colorLiteral(red: 0.8570463061, green: 0.8669943213, blue: 0.8452582955, alpha: 1)))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .fontWeight(.bold)
                }.padding(.horizontal, 28)
                
                // Spacing for UI
                Spacer().frame(height: 50)
                
                // Register Redirect
                Group {
                    HStack {
                        // Message
                        Text("Don't Have an Account?")
                            .font(.system(size: 15))
                        
                        // Button
                        Button(action: {
                            togglePages.togglePage()
                        }) {
                            Text("Register Now!")
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                        }
                    }
                }
            }.padding(.horizontal, 20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    Login_Page()
}
