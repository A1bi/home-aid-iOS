//
//  OpenDoorIntentHandler.swift
//  Home Aid Intents
//
//  Created by Albrecht Oster on 14.09.18.
//

import UIKit

class OpenDoorIntentHandler: NSObject, OpenDoorIntentHandling {
    public func handle(intent: OpenDoorIntent, completion: @escaping (OpenDoorIntentResponse) -> Void) {
        HomeAidManager.shared.openDoor { (error) in
            let responseCode: OpenDoorIntentResponseCode = error == nil ? .success : .failure
            let response = OpenDoorIntentResponse(code: responseCode, userActivity: nil)
            completion(response)
        }
    }
}
