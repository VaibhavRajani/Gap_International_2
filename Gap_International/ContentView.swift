//
//  ContentView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var loginError = false
    @State private var username = ""
    @State private var password = ""
    @ObservedObject var apiService = APIService()
    
    var body: some View {
        if isLoggedIn {
            MainContentView(isLoggedIn: $isLoggedIn, username: username)
        } else {
            LoginView(username: $username, password: $password, isLoggedIn: $isLoggedIn, loginError: $loginError, apiService: apiService)
        }
    }
}

#Preview {
    ContentView()
}
