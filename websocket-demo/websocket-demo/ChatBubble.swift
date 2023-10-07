//
//  ChatBubble.swift
//  websocket-demo
//
//  Created by youtak on 10/7/23.
//

import SwiftUI

struct ChatBubble: View {
    
    let model: ChatBubbleModel

    
    var body: some View {
        HStack {
            
            if model.isMe {
                Spacer()
            }
            
            VStack(alignment: model.isMe ? .trailing : .leading, spacing: 10) {
                Text(model.nickname)
                    .font(.title3)
                
                Text(model.text)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(model.isMe ? .green : .blue)
                    .clipShape(.rect(cornerRadius: 5))
            }
            .padding(.horizontal)
            
            if !model.isMe {
                Spacer()
            }
        }
    }
}

#Preview {
    Group {
        ChatBubble(model:
                    ChatBubbleModel(
                        nickname: "유저",
                        text: "Hello, World!",
                        isMe: false
                    )
                )
    
        ChatBubble(model:
                    ChatBubbleModel(
                        nickname: "나",
                        text: "안녕, 월드!",
                        isMe: true
                    )
                )
    }
}
