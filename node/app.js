const express = require("express")
const app = express()
const { WebSocketServer } = require("ws")

app.use(express.static("public"))

app.listen(8000, () => {
  console.log(`Example app listening on port 8000`)
})

// 웹소켓 서버 생성
const wss = new WebSocketServer({ port: 8001 })

// broadcast 메소드 추가
wss.broadcast = (message) => {
  // 서버에 메시지가 들어오면 모든 클라이언트에게 보내줌
  wss.clients.forEach((client) => {
    client.send(message);
  });
};

// 연결, 연결 끊김
wss.on("connection", (ws, request) => {
  ws.on("message", (data) => {
    wss.broadcast(data.toString());
  });

  // 연결 
  wss.clients.forEach((client) => {
    let model = {
      id: "server",
      nickname : "server",
      text : `새로운 유저가 접속했습니다. 현재 유저 ${wss.clients.size} 명`
    };

    let jsonModel = JSON.stringify(model)
    client.send(jsonModel)
    console.log(`새로운 유저가 접속했습니다. 현재 유저 ${wss.clients.size} 명`)
  });

  // 연결 끊음
  ws.on("close", () => {
    let model = {
      id: "server",
      nickname : "server",
      text : `유저 한명이 떠났습니다. 현재 유저 ${wss.clients.size} 명`
    };

    let jsonModel = JSON.stringify(model)
    wss.broadcast(jsonModel);
    console.log(`유저 한명이 떠났습니다. 현재 유저 ${wss.clients.size} 명`);
  });

  }
);