//
//  ChatroomController.swift
//  FirebaseChat
//
//  Created by Chris Gonzales on 3/24/20.
//  Copyright © 2020 Chris Gonzales. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatroomController {
    
    var chatrooms: [Chatroom] = []
    var currentUser: Sender?
    
    var ref: DatabaseReference = Database.database().reference()
    
    func fetchChatrooms(completion: @escaping () -> Void) {
        
        let requestURL = Keys.baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching chatrooms: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion()
                return
            }
            
            do{
                self.chatrooms = try JSONDecoder().decode([String: Chatroom].self, from: data).map({$0.value})
            } catch {
                self.chatrooms = []
                NSLog("Error decoding message threads from JSON data: \(error)")
            }
            completion()
        }.resume()
    }
    
    func createChatroom(with title: String, completion: @escaping () -> Void) {
        let chatroom = Chatroom(title: title)
        
        let requestURL = Keys.baseURL.appendingPathComponent(chatroom.identifier).appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        do{
            request.httpBody = try JSONEncoder().encode(chatroom)
        } catch {
            NSLog("Error encoding chatroom to JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error creating chatroom: \(error)")
                completion()
                return
            }
            
            self.chatrooms.append(chatroom)
            completion()
        }.resume()
    }
    
}
