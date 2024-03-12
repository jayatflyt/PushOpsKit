//
//  Router.swift
//
//
//  Created by May on 7/17/23.
//

import Foundation

internal class Router {
    private let sharedSession = URLSession.shared
    private static let baseURL = URL(string: "https://app-elb.pushoperations.com/api/v1")
    private var token: String
    internal var userID: Int?
    
    private let jsonDecoder = JSONDecoder()
    
    init(authKey: String) {
        self.token = authKey
    }
    
    internal func makeRequest(path: String, queryItems: [URLQueryItem]? = nil) async throws -> Data {
        guard var urlComponents = URLComponents(url: Router.baseURL!, resolvingAgainstBaseURL: true) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        urlComponents.path.append(path)
        
        if queryItems != nil {
            urlComponents.queryItems = queryItems
        }
        
        urlComponents.queryItems?.append(URLQueryItem(name: "token", value: token))
        
        guard let url = urlComponents.url else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        debugPrint(url)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sharedSession = URLSession.shared
        let (data, _) = try await sharedSession.data(for: urlRequest)
        
//        print(String(data: data, encoding: .utf8))
        
        return data
    }
    
    /**
     This method will return the session token of the authenticated user.
     Static to make sure the user can have a token before the `PushKit` class is initalized. 
     Full URL: `https://app-elb.pushoperations.com/api/v1/ios/login`
     */
    public static func auth(username: String, password: String) async throws -> PushUserSettings {
        var newUserSettings: PushUserSettings? = nil
        guard var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        urlComponents.path.append("/ios/login")
        
        guard let url = urlComponents.url else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        // Post Request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        let requestBody = [
            "userName": username,
            "passWord": password
        ]
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sharedSession = URLSession.shared
        let (data, _) = try await sharedSession.data(for: urlRequest)
        
//        print(String(data: data, encoding: .utf8))
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let status = json["status"] as? String, status == "Fail" {
                    if let reason = json["reason"] as? String, reason == "wrong Password or user login" {
                        // Incorrect username or password
                        throw PushError.incorrectLogin
                    } else {
                        throw PushError.invalidResponse
                    }
                } else {
                    // Try to decode as PushUserSettings
                    do {
                        let userSettings = try jsonDecoder.decode(PushUserSettings.self, from: data)
                        // Successfully parsed as PushUserSettings
                        // Handle user settings
                        newUserSettings = userSettings
                    } catch {
                        //TODO: This is being called on login. Why?
                        debugPrint("error: \(error)")
                        throw PushError.invalidJSON
                    }
                }
            } else {
                throw PushError.invalidJSON
            }
        return newUserSettings!
    }
    
//    TODO: This lol.
//    public func getNotificationToken(deviceToken: String, )
    
    /**
     This method will return the user details and company settings. This returns the same data that comes with an auth request, so if you need to refersh the data, use this method with the existing token instead.
     Full URL: `https://app-elb.pushoperations.com/api/v1/company/setting`
     - Parameters:
        - token: The auth token that is associated with the user's account.
     */
    public func getSettings() async throws -> PushUserSettings {
        var userSettings: PushUserSettings?
        
        let data = try await makeRequest(path: "/company/setting", queryItems: [URLQueryItem(name: "userableType", value: "employee")])
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        do {
            userSettings = try jsonDecoder.decode(PushUserSettings.self, from: data)
        } catch {
            throw PushError.invalidJSON
        }
        
        return userSettings!
    }
}
