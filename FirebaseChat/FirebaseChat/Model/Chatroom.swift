//
//  Chatroom.swift
//  FirebaseChat
//
//  Created by Chris Gonzales on 3/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import MessageKit
import FirebaseCore
import FirebaseDatabase

class Chatroom: Codable, Equatable {
    
    let title: String
    var messages: [Message]
    let identifier: String
    
    init(title: String, messages: [Message] = [], identifier: String = UUID().uuidString) {
        self.title = title
        self.messages = messages
        self.identifier = identifier
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ChatroomKeys.self)
        
        let title = try container.decode(String.self,
                                         forKey: .title)
        let identifier = try container.decode(String.self,
                                              forKey: .identifier)
        if let messages = try container.decodeIfPresent([String: Message].self,
                                               forKey: .messages) {
            self.messages = Array(messages.values)
        } else {
            self.messages = []
        }
        self.title = title
        self.identifier = identifier
    }
    
    static func ==(lhs: Chatroom, rhs: Chatroom) -> Bool {
        return lhs.title == rhs.title &&
            lhs.identifier == rhs.identifier
    }
    
}

enum ChatroomKeys: String, CodingKey {
    case title
    case identifier
    case messages
}
