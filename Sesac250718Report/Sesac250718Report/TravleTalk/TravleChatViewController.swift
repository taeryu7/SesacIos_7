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
    
    
    var chatRoom: ChatRoom!
    
    // 날짜별로 그룹화된 채팅 데이터
    private var groupedChats: [(date: String, chats: [Chat])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupInputView()
        groupChatsByDate() // 날짜별로 채팅 그룹화
        
        print("초기 채팅방 메시지 개수: \(chatRoom.chatList.count)")
        print("채팅방 이름: \(chatRoom.chatroomName)")
    }
    
    func setupUI() {
        self.title = chatRoom.chatroomName
        view.backgroundColor = UIColor.systemBackground
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
        
        // 섹션 헤더 스타일 설정
        chatTableView.sectionHeaderTopPadding = 10
        
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
    
    // 날짜별로 채팅을 그룹화하는 함수
    func groupChatsByDate() {
        groupedChats.removeAll()
        
        guard !chatRoom.chatList.isEmpty else { return }
        
        var currentDateChats: [Chat] = []
        var currentDate = ""
        
        for chat in chatRoom.chatList {
            let chatDate = extractDateOnly(from: chat.date)
            
            if currentDate.isEmpty {
                // 첫 번째 채팅
                currentDate = chatDate
                currentDateChats.append(chat)
            } else if currentDate == chatDate {
                // 같은 날짜의 채팅
                currentDateChats.append(chat)
            } else {
                // 날짜가 바뀜 - 이전 날짜 그룹 저장
                groupedChats.append((date: currentDate, chats: currentDateChats))
                
                // 새로운 날짜 그룹 시작
                currentDate = chatDate
                currentDateChats = [chat]
            }
        }
        
        // 마지막 그룹 저장
        if !currentDateChats.isEmpty {
            groupedChats.append((date: currentDate, chats: currentDateChats))
        }
        
        chatTableView.reloadData()
        print("날짜별 그룹 개수: \(groupedChats.count)")
    }
    
    private func extractDateOnly(from dateString: String) -> String {
        let components = dateString.components(separatedBy: " ")
        return components.first ?? dateString
    }
    
    @objc func sendButtonTapped() {
        guard let messageText = messageInputTextField.text,
              !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("빈 메시지는 전송할 수 없습니다.")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let currentDate = dateFormatter.string(from: Date())
        
        let newChat = Chat(user: ChatList.me, date: currentDate, message: messageText)
        
        // 새 메시지의 날짜 확인
        let newMessageDate = extractDateOnly(from: currentDate)
        let isNewDateSection = groupedChats.isEmpty || groupedChats.last?.date != newMessageDate
        
        // 채팅방에 메시지 추가
        chatRoom.chatList.append(newChat)
        messageInputTextField.text = ""
        
        if isNewDateSection {
            // 새로운 날짜 섹션 추가
            groupedChats.append((date: newMessageDate, chats: [newChat]))
            let newSectionIndex = groupedChats.count - 1
            chatTableView.insertSections(IndexSet(integer: newSectionIndex), with: .bottom)
        } else {
            // 기존 섹션에 메시지 추가
            let lastSectionIndex = groupedChats.count - 1
            groupedChats[lastSectionIndex].chats.append(newChat)
            let newIndexPath = IndexPath(row: groupedChats[lastSectionIndex].chats.count - 1, section: lastSectionIndex)
            chatTableView.insertRows(at: [newIndexPath], with: .bottom)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.scrollToBottom(animated: true)
        }
        
        print("메시지 전송 완료: \(messageText)")
    }
    
    func scrollToBottom(animated: Bool) {
        guard !groupedChats.isEmpty else {
            print("채팅 그룹이 비어있어서 스크롤할 수 없습니다.")
            return
        }
        
        DispatchQueue.main.async {
            let lastSection = self.groupedChats.count - 1
            let lastRow = self.groupedChats[lastSection].chats.count - 1
            let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
            
            if lastIndexPath.section < self.chatTableView.numberOfSections &&
               lastIndexPath.row < self.chatTableView.numberOfRows(inSection: lastIndexPath.section) {
                self.chatTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
                print("하단으로 스크롤 완료")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedChats.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedChats[section].chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = groupedChats[indexPath.section].chats[indexPath.row]
        
        if chat.user.name == ChatList.me.name {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageTableViewCell", for: indexPath) as! MyMessageTableViewCell
            cell.configure(with: chat)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OtherMessageTableViewCell", for: indexPath) as! OtherMessageTableViewCell
            cell.configure(with: chat)
            return cell
        }
    }
    
    // 섹션 헤더 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // 섹션 헤더 뷰 (날짜 표시)
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.systemBackground
        
        // 왼쪽 구분선
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(leftLine)
        
        // 오른쪽 구분선
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.separator.withAlphaComponent(0.5)
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(rightLine)
        
        // 날짜 라벨
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        dateLabel.textColor = .secondaryLabel
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = UIColor.systemBackground
        dateLabel.layer.cornerRadius = 8
        dateLabel.layer.masksToBounds = true
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 날짜 포맷팅
        let dateString = groupedChats[section].date
        dateLabel.text = "  \(formatDateForDisplay(dateString))  "
        
        headerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            // 왼쪽 구분선
            leftLine.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            leftLine.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -10),
            leftLine.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // 오른쪽 구분선
            rightLine.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            rightLine.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            rightLine.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            // 날짜 라벨
            dateLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            dateLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ])
        
        return headerView
    }
    
    private func formatDateForDisplay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let calendar = Calendar.current
        let today = Date()
        
        if calendar.isDate(date, inSameDayAs: today) {
            return "오늘"
        }
        
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "어제"
        }
        
        if calendar.component(.year, from: date) == calendar.component(.year, from: today) {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "M월 d일 EEEE"
            return outputFormatter.string(from: date)
        } else {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.dateFormat = "yyyy년 M월 d일 EEEE"
            return outputFormatter.string(from: date)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("엔터키로 메시지 전송")
        sendButtonTapped()
        return true
    }
}
