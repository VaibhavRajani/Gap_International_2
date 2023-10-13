//
//  APIService.swift
//  Gap_International
//
//  Created by Vaibhav Rajani on 10/17/23.
//

import Foundation

struct Comment: Identifiable, Decodable {
    var chapterName: String
    var comment: String
    var level: Int
    var date: String

    var id: String {
        return chapterName + date // You can combine other properties to create a unique identifier
    }
    
    enum CodingKeys: String, CodingKey {
        case chapterName = "ChapterName"
        case comment = "Comment"
        case level = "Level"
        case date = "Date"
    }
}



class APIService: ObservableObject {
    // Define the base URL
    private let baseURL = "https://gapinternationalwebapi20200521010239.azurewebsites.net/api"
    
    // Implement a login function
    func login(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the URL for the login endpoint
        let loginURL = URL(string: "\(baseURL)/User/UserLogin")!
        
        // Create the request
        var request = URLRequest(url: loginURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: Any] = ["UserName": username, "Password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Login Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data, let response = String(data: data, encoding: .utf8) {
                print("Login Response: \(response)")
                completion(.success(response))
            }
        }.resume()
    }
    
    // Implement a sign-up function
    func signUp(username: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the URL for the sign-up endpoint
        let signUpURL = URL(string: "\(baseURL)/User/CreateUserAccount")!
        
        // Create the request
        var request = URLRequest(url: signUpURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: Any] = ["UserName": username, "Password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Sign Up Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data, let response = String(data: data, encoding: .utf8) {
                print("Sign Up Response: \(response)")
                completion(.success(response))
            }
        }.resume()
        
        
    }
    
    func saveComment(username: String, chapterName: String, comment: String, level: Int, completion: @escaping (Result<String, Error>) -> Void) {
        // Create the URL for the save comment endpoint
        let saveCommentURL = URL(string: "\(baseURL)/User/SaveJournal")!
        
        // Create the request
        var request = URLRequest(url: saveCommentURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Prepare the request body
        let body: [String: Any] = [
            "UserName": username,
            "ChapterName": chapterName,
            "Comment": comment,
            "Level": level
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        request.httpBody = jsonData
        
        // Perform the request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Save Comment Error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let data = data, let response = String(data: data, encoding: .utf8) {
                print("Save Comment Response: \(response)")
                completion(.success(response))
            }
        }.resume()
    }
    
    // ...

    func getUserComments(username: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        let urlString = "\(baseURL)/User/GetJournal?UserName=\(username)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let comments = try decoder.decode([Comment].self, from: data)
                    completion(.success(comments))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }


}
