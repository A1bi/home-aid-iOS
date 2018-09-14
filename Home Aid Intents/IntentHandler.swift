//
//  IntentHandler.swift
//  IntentHandler
//
//  Created by Albrecht Oster on 14.09.18.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is OpenDoorIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return OpenDoorIntentHandler()
    }
    
}
