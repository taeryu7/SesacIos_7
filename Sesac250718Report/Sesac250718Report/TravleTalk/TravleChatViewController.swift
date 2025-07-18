//
//  TravleChatViewController.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/18/25.
//

import UIKit

class TravleChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var chatTableView: UITableView!
    
    @IBOutlet var messageInputTextField: UITextField!
    
    @IBOutlet var sendButton: UIButton!
    
    
    // 전달받을 데이터
    var chatRoom: ChatRoom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupInputView()
    }
    
    func setupUI() {
        // 네비게이션 타이틀을 채팅방 이름으로 설정
        self.title = chatRoom.chatroomName
        
        // 배경색 설정
        view.backgroundColor = UIColor.systemBackground
        
        // 뒤로가기 버튼 설정 (자동으로 생성됨)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    func setupTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        // XIB 파일 등록
        let myMessageXib = UINib(nibName: "MyMessageTableViewCell", bundle: nil)
        chatTableView.register(myMessageXib, forCellReuseIdentifier: "MyMessageTableViewCell")
        
        let otherMessageXib = UINib(nibName: "OtherMessageTableViewCell", bundle: nil)
        chatTableView.register(otherMessageXib, forCellReuseIdentifier: "OtherMessageTableViewCell")
        
        // 테이블뷰 설정
        chatTableView.separatorStyle = .none
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 60
        
        // 키보드가 올라올 때 테이블뷰 스크롤
        scrollToBottom(animated: false)
    }
    
    func setupInputView() {
        messageInputTextField.placeholder = "메시지를 입력하세요..."
        messageInputTextField.borderStyle = .roundedRect
        messageInputTextField.delegate = self
        
        sendButton.setTitle("전송", for: .normal)
        sendButton.backgroundColor = UIColor.systemBlue
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    }
    
    @objc func sendButtonTapped() {
        guard let messageText = messageInputTextField.text,
              !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        // 현재 날짜 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        
        // 새로운 채팅 메시지 생성
        let newChat = Chat(user: ChatList.me, date: currentDate, message: messageText)
        
        // 채팅방에 메시지 추가
        chatRoom.chatList.append(newChat)
        
        // 텍스트필드 초기화
        messageInputTextField.text = ""
        
        // 테이블뷰 리로드 및 하단으로 스크롤
        chatTableView.reloadData()
        scrollToBottom(animated: true)
    }
    
    func scrollToBottom(animated: Bool) {
        DispatchQueue.main.async {
            if !self.chatRoom.chatList.isEmpty {
                let indexPath = IndexPath(row: self.chatRoom.chatList.count - 1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatRoom.chatList[indexPath.row]
        
        // 내 메시지인지 판단
        if chat.user.name == ChatList.me.name {
            // 내 메시지 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
            cell.configure(with: chat)
            return cell
        } else {
            // 상대방 메시지 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageTableViewCell", for: indexPath) as! OtherMessageTableViewCell
            cell.configure(with: chat)
            return cell
        }
    }
    
    /// 엔터키 누르면 메시지 전송하는 이벤트
    /// 옵션의 데이터 추가를 위해서 넣어놓음
    /// 돌아가는지는 모름, 확인필요
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
}
