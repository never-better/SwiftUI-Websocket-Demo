//
//  ChatBubbleModel.swift
//  websocket-demo
//
//  Created by youtak on 10/7/23.
//

import Foundation

struct ChatBubbleModel: Hashable {
    let nickname: String
    let text: String
    let isMe: Bool
}

struct ChatBubbleEntity: Codable {
    let id: String
    let nickname: String
    let text: String
    
    func toDomain(_ myID: String) -> ChatBubbleModel {
        ChatBubbleModel(
            nickname: self.nickname,
            text: self.text,
            isMe: self.id == myID 
        )
    }
}
