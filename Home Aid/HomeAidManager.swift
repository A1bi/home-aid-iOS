//
//  HomeAidManager.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import Foundation

typealias HomeAidCompletionBlock = ((HomeAidError?) -> ())?

enum HomeAidError: Error {
    case requestFailed(error: Error)
    case unexpectedResponse(statusCode: Int)
}

class HomeAidManager {
    static let apiHost = URL(string: "https://home-aid.dyn.a0s.de")
    static let defaults = UserDefaults(suiteName: "group.de.a0s.home-aid")
    static var authToken:String? {
        set(newValue) {
            defaults?.setValue(newValue, forKey: "ApiAuthToken")
        }
        get {
            return defaults?.string(forKey: "ApiAuthToken")
        }
    }

    static let shared = HomeAidManager()
    
    func openDoor(completion: HomeAidCompletionBlock = nil) {
        makeRequest(path: "/open-door", completion: completion)
    }

    func registerPushDeviceToken(token: String, completion: HomeAidCompletionBlock = nil) {
        makeRequest(path: "/push-device-tokens", data: ["token": token], completion: completion)
    }
    
    private func makeRequest(path: String, data: Dictionary<String, String>? = nil, completion: HomeAidCompletionBlock) {
        let url = URL(string: path, relativeTo: HomeAidManager.apiHost)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        if let authToken = HomeAidManager.authToken {
            request.setValue(authToken, forHTTPHeaderField: "X-Auth")
        }

        if let d = data {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            if let json = try? JSONSerialization.data(withJSONObject: d, options: []) {
                request.httpBody = json
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if error != nil {
                completion?(HomeAidError.requestFailed(error: error!))
                print("api error, path: \(path), error message: \(error!)")
            } else if httpResponse == nil || httpResponse!.statusCode != 200 {
                completion?(HomeAidError.unexpectedResponse(statusCode: httpResponse?.statusCode ?? -1))
            } else {
                completion?(nil)
            }
        }
        
        task.resume()
    }
}
