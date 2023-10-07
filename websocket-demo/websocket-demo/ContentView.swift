//
//  ContentView.swift
//  websocket-demo
//
//  Created by youtak on 10/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var networkService: NetworkServiceTwo = NetworkServiceTwo()
    @State var textfield: String = ""
    
    var body: some View {
        VStack {
            
            List(networkService.chatBubbleModel, id: \.self) { chatBubbleModel in
                ChatBubble(model: chatBubbleModel)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            
            HStack {
                TextField("", text: $textfield)
                
                Button(
                    action: {
                        sendChat(self.textfield)
                        self.textfield = ""
                    },
                    label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24, alignment: .center)
                    }
                )
            }
            .padding()
            .background(.gray.opacity(0.4))
            .clipShape(.rect(cornerRadius: 5))
            .padding(.horizontal)
        }
    }
}

extension ContentView {
    func sendChat(_ text: String) {
//        let newChat = ChatBubbleModel(user: "나", text: text, isMe: true)
        networkService.sendMessage(text)
    }
}

#Preview {
    ContentView()
}
