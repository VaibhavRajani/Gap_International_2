//
//  LoginView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import SwiftUI

struct LoginView: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var isLoggedIn: Bool
    @Binding var loginError: Bool
    @ObservedObject var apiService: APIService
    @State private var isSignUp = false
    @State private var signUpUsername: String = ""
    @State private var signUpPassword: String = ""
    
    var body: some View {
        //       NavigationView {
        NavigationLink("", destination: EmptyView())
        VStack {
            if isSignUp {
                // Sign-up form
                TextField("Username", text: $signUpUsername)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $signUpPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Sign Up") {
                    apiService.signUp(username: signUpUsername, password: signUpPassword) { result in
                        switch result {
                        case .success(let response):
                            if response == "Success" {
                                isLoggedIn = true
                            } else {
                                loginError = true
                            }
                        case .failure:
                            loginError = true
                        }
                    }
                }
                Button("Back to Login") {
                                        isSignUp = false
                                    }
            } else {
                // Login form
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Login") {
                    apiService.login(username: username, password: password) { result in
                        switch result {
                        case .success(let response):
                            print("Login Response: \(response)") // Add this line to print the response
                            if response.contains("success"){
                                isLoggedIn = true
                                print("User logged in successfully")
                                print(isLoggedIn)
                            } else {
                                loginError = true
                                print("Login Error")
                            }
                        case .failure(let error):
                            print("Login Error: \(error)")
                            loginError = true
                        }
                    }
                }
                
                
                // Use NavigationLink to redirect to MainContentView
                //                    NavigationLink(
                //                        destination: MainContentView(),
                //                        isActive: $isLoggedIn,
                //                        label: {
                //                            EmptyView()
                //                        }
                //                    )
                
                .navigationDestination(isPresented: $isLoggedIn){
                    MainContentView(isLoggedIn: $isLoggedIn, username: username)
                 //   MainContentView()
                }

                Button("Sign Up") {
                    isSignUp.toggle()
                }
            }
        }
                    .navigationBarHidden(true)
        //        }
        //        .navigationViewStyle(StackNavigationViewStyle())
    }
}


#Preview {
    ContentView()
}

