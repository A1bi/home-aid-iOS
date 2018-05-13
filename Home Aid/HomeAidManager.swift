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
    static var authToken:String? {
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: "ApiAuthToken")
        }
        get {
            return UserDefaults.standard.string(forKey: "ApiAuthToken")!
        }
    }

    static let shared = HomeAidManager()
    
    func openDoor(completion: HomeAidCompletionBlock = nil) {
        makeRequest(path: "/open-door", completion: completion)
    }
    
    private func makeRequest(path: String, completion: HomeAidCompletionBlock) {
        let url = URL(string: path, relativeTo: HomeAidManager.apiHost)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        if let authToken = HomeAidManager.authToken {
            request.setValue(authToken, forHTTPHeaderField: "X-Auth")
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
