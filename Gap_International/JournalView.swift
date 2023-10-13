//
//  JournalView.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/20/23.
//

import SwiftUI

struct JournalView: View {
    @Binding var isLoggedIn: Bool
    var username: String

    @State private var userComments: [Comment] = []

    @State private var selectedComment: Comment?

    var body: some View {
        NavigationView {
            List(userComments) { comment in
                Button(action: {
                    selectedComment = comment
                }) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Chapter: \(comment.chapterName)")
                            .font(.headline)
                        Text("Date: \(comment.date)")
                            .font(.caption)
                        Text("Comment: \(comment.comment)")
                            .font(.body)
                    }
                }
            }
            .navigationBarTitle("Journal")
            
            if let comment = selectedComment {
                Text("Selected Comment:")
                VStack {
                    Text("Chapter: \(comment.chapterName)")
                        .font(.headline)
                    Text("Date: \(comment.date)")
                        .font(.caption)
                    Text("Comment: \(comment.comment)")
                        .font(.body)
                }
                .padding()
            }
        }
        .onAppear {
            // Load user comments
            loadUserComments()
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Utilize the full screen
    }

    func loadUserComments() {
        // Call the API to get user comments
        let apiService = APIService()
        apiService.getUserComments(username: username) { result in
            switch result {
            case .success(let comments):
                // Populate userComments with the retrieved comments
                userComments = comments
            case .failure(let error):
                print("Error loading user comments: \(error)")
            }
        }
    }
}

#Preview{
    ContentView()
}



