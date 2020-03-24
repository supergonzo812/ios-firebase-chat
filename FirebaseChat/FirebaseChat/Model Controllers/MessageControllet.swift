//
//  MessageControllet.swift
//  FirebaseChat
//
//  Created by Chris Gonzales on 3/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation

class MessageController {
    
    var chatrooms: [Chatroom] = []
    var currentUser: Sender?
    
    func createMessage(in chatroom: Chatroom, withMessage message: String, sender: Sender, completion: @escaping () -> Void) {
        
        guard let index = chatrooms.firstIndex(of: chatroom) else {
            completion()
            return
        }
        
        let message = Message(message: message,
                              sender: sender)
        
        chatrooms[index].messages.append(message)
        
        let requestURL = Keys.baseURL.appendingPathComponent(chatroom.identifier).appendingPathComponent("messages").appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONEncoder().encode(message)
        } catch {
            NSLog("Error encoding message to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error creating message: \(error)")
                completion()
                return
            }
            
            completion()
        }.resume()
    }
}
