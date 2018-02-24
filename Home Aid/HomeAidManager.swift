//
//  HomeAidManager.swift
//  Home Aid
//
//  Created by Albrecht Oster on 23.02.18.
//

import Foundation

typealias HomeAidCompletionBlock = ((Bool) -> ())?

class HomeAidManager {
    static let apiHost = URL(string: "https://home-aid.dyn.a0s.de")
    
    static let shared = HomeAidManager()
    
    func openDoor(success: HomeAidCompletionBlock = nil) {
        makeRequest(path: "/open-door", success: success)
    }
    
    private func makeRequest(path: String, success: HomeAidCompletionBlock) {
        let url = URL(string: path, relativeTo: HomeAidManager.apiHost)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("api error, path: \(path), error message: \(error!)")
            } else if let httpResponse = response as? HTTPURLResponse {
                success?(httpResponse.statusCode == 200)
            }
        }
        
        task.resume()
    }
}
