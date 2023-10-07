//
//  NetworkServiceTwo.swift
//  websocket-demo
//
//  Created by youtak on 10/7/23.
//

import Foundation

// MARK: - async await 사용

final class NetworkServiceTwo: ObservableObject {

    @Published var chatBubbleModel = [ChatBubbleModel]()
    
    static let shared = NetworkServiceTwo()
    
    private var webSocketTask: URLSessionWebSocketTask?
    private var timer: Timer?
    
    init() {
        connect()
    }

    private func connect() {
        guard let url = URL(string: "ws://localhost:8001/") else { return }
        let request = URLRequest(url: url)
        webSocketTask = URLSession.shared.webSocketTask(with: request)
        webSocketTask?.resume()
        self.startPing()
        receiveMessage()
    }
    
    private func receiveMessage() {
        guard let webSocketTask = webSocketTask else { return }
        
        Task {
            let message = try await webSocketTask.receive()
            
            switch message {
            case .string(let stringMessage):
                self.handleMessage(stringMessage)
            case .data:
                break
            @unknown default:
                break
            }
            
            receiveMessage()
        }
         
    }
    
    func sendMessage(_ text: String) {
        let model = ChatBubbleEntity(id: User.id, nickname: User.nickname, text: text)
        guard let jsonData = try? JSONEncoder().encode(model) else {
            return
        }
        let message = String(data: jsonData, encoding: .utf8)!
        
        guard let webSocketTask = webSocketTask else {
            print("언래핑 에러")
            return
        }
        
        Task {
            try await webSocketTask.send(.string(message))
        }
    }
    
    private func handleMessage(_ message: String) {
        let jsonData = message.data(using: .utf8)
        guard let entity = try? JSONDecoder().decode(ChatBubbleEntity.self, from: jsonData!) else {
            return
        }
        let model = entity.toDomain(User.id)
        
        DispatchQueue.main.async {
            self.chatBubbleModel.append(model)
        }
    }

    // MARK: - Ping

    private func startPing() {
      self.timer?.invalidate()
      self.timer = Timer.scheduledTimer(
        withTimeInterval: 10,
        repeats: true,
        block: { [weak self] _ in self?.ping() }
      )
    }
    
    private func ping() {
        webSocketTask?.sendPing { [weak self](error) in
            if let error = error {
                print("Ping failed: \(error)")
            }
            self?.startPing()
        }
    }
}

