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
    // ? !
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupInputView()
        
        // 디버깅용 초기 메시지 개수 확인
        print("초기 채팅방 메시지 개수: \(chatRoom.chatList.count)")
        print("채팅방 이름: \(chatRoom.chatroomName)")
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
            print("빈 메시지는 전송할 수 없습니다.")
            return
        }
        
        // 현재 날짜와 시간 생성
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        
        // 새로운 채팅 메시지 생성
        let newChat = Chat(user: ChatList.me, date: currentDate, message: messageText)
        
        // 채팅방에 메시지 추가
        chatRoom.chatList.append(newChat)
        
        // 텍스트필드 초기화
        messageInputTextField.text = ""
        
        // 테이블뷰에 새로운 행 추가 (애니메이션 효과와 함께)
        let newIndexPath = IndexPath(row: chatRoom.chatList.count - 1, section: 0)
        
        chatTableView.beginUpdates()
        chatTableView.insertRows(at: [newIndexPath], with: .bottom)
        chatTableView.endUpdates()
        
        // 새로 추가된 메시지로 스크롤
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom(animated: true)
        }
        
        print("메시지 전송 완료: \(messageText)")
        print("현재 채팅방 메시지 개수: \(chatRoom.chatList.count)")
    }
    
    func scrollToBottom(animated: Bool) {
        guard !chatRoom.chatList.isEmpty else {
            print("채팅 리스트가 비어있어서 스크롤할 수 없습니다.")
            return
        }
        
        DispatchQueue.main.async {
            let lastIndexPath = IndexPath(row: self.chatRoom.chatList.count - 1, section: 0)
            
            // 해당 인덱스가 유효한지 확인
            if lastIndexPath.row < self.chatTableView.numberOfRows(inSection: 0) {
                self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
                print("하단으로 스크롤 완료")
            } else {
                print("스크롤할 인덱스가 유효하지 않습니다.")
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
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("엔터키로 메시지 전송")
        sendButtonTapped()
        return true
    }
}
