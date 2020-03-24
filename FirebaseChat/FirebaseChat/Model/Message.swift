//
//  Message.swift
//  FirebaseChat
//
//  Created by Chris Gonzales on 3/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseCore
import FirebaseDatabase

struct Message: Codable, Equatable {
    
    // MARK: - Properties
    
    let message: String
    let messageID: String
    let senderID: String
    let timestamp: Date
    let displayName: String
    
    var sender: SenderType {
        return Sender(senderId: senderID, displayName: displayName)
    }
    var kind: MessageKind {
        return .text(message)
    }
    
    // MARK: - Initializers
    
    init(message: String, messageID: String = UUID().uuidString,
         sender: Sender, timestamp: Date = Date()) {
        self.message = message
        self.messageID = messageID
        self.senderID = sender.senderId
        self.timestamp = timestamp
        self.displayName = sender.displayName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MessageKeys.self)
        
        let message = try container.decode(String.self,
                                           forKey: .message)
        let senderID = try container.decode(String.self,
                                             forKey: .senderID)
        let displayName = try container.decode(String.self,
                                               forKey: .displayName)
        let timestamp = try container.decode(Date.self,
                                             forKey: .timestamp)
        
        let sender = Sender(senderId: senderID,
                            displayName: displayName)
        
        self.init(message: message,
                  sender: sender,
                  timestamp: timestamp)
    }
    
    // MARK: - Methods
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: MessageKeys.self)
        
        try container.encode(message,
                             forKey: .message)
        try container.encode(senderID,
                             forKey: .senderID)
        try container.encode(displayName,
                             forKey: .displayName)
        try container.encode(timestamp,
                             forKey: .timestamp)
    }
    
//    func convertToDictionary(sender: Sender){
//        
//    }
//    
//    func convertToMessage(from dictionary: ) {
//        
//    }
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.message == rhs.message
    }
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

enum MessageKeys: String, CodingKey {
    case message
    case displayName
    case timestamp
    case senderID
}
