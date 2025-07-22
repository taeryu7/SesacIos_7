//
//  TravleMainViewController.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/18/25.
//

import UIKit

class TravleMainViewController: UIViewController {
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var chatListCollectionView: UICollectionView!
    
    // 데이터 소스
    var allChatRooms: [ChatRoom] = []
    var filteredChatRooms: [ChatRoom] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Controller 설정
        setupNavigationController()
        
        setupUI()
        setupCollectionView()
        setupSearchBar()
        loadChatData()
    }
    
    
    // 스토리보드에서 네비게이션 컨트롤러 설정없이 네비게이션 컨트롤러 적용 가능하게 해주는 코드
    func setupNavigationController() {
        // 현재 뷰컨트롤러가 Navigation Controller 안에 없다면 생성
        if navigationController == nil {
            let navController = UINavigationController(rootViewController: self)
            
            // 현재 window의 rootViewController를 Navigation Controller로 교체
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        }
    }
    
    func setupUI() {
        // 네비게이션 타이틀 설정
        self.title = ""
        
        // 배경색 설정
        view.backgroundColor = UIColor.systemBackground
    }
    
    func setupCollectionView() {
        let xib = UINib(nibName: "TravleCollectionViewCell", bundle: nil)
        chatListCollectionView.register(xib, forCellWithReuseIdentifier: "TravleCollectionViewCell")
        
        // 델리게이트 설정
        chatListCollectionView.delegate = self
        chatListCollectionView.dataSource = self
        
        // 컬렉션뷰 레이아웃 설정
        setupCollectionViewLayout()
    }
    
    func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        // 화면 넓이 계산 (테이블뷰 스타일로 한 줄에 하나씩)
        let deviceWidth = UIScreen.main.bounds.width
        let horizontalPadding: CGFloat = 16
        let cellWidth = deviceWidth - (horizontalPadding * 2)
        
        layout.itemSize = CGSize(width: cellWidth, height: 80)
        
        // 전체 섹션 여백
        layout.sectionInset = UIEdgeInsets(top: 8, left: horizontalPadding, bottom: 8, right: horizontalPadding)
        
        // 셀 간 간격
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        
        chatListCollectionView.collectionViewLayout = layout
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "채팅방을 검색해보세요"
        searchBar.searchBarStyle = .minimal
        
        // 검색바 취소 버튼 설정
        searchBar.showsCancelButton = false
    }
    
    func loadChatData() {
        // ChatList에서 데이터 가져오기
        allChatRooms = ChatList.list
        filteredChatRooms = allChatRooms
        
        // 최신 메시지 순으로 정렬
        sortChatRoomsByLatestMessage()
        
        chatListCollectionView.reloadData()
    }
    
    func sortChatRoomsByLatestMessage() {
        filteredChatRooms.sort { chatRoom1, chatRoom2 in
            guard let lastDate1 = chatRoom1.chatList.last?.date,
                  let lastDate2 = chatRoom2.chatList.last?.date else {
                return false
            }
            return lastDate1 > lastDate2
        }
    }
    
    func applySearchFilter() {
        guard let searchText = searchBar.text else {
            filteredChatRooms = allChatRooms
            chatListCollectionView.reloadData()
            return
        }
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedSearchText.isEmpty {
            filteredChatRooms = allChatRooms
        } else {
            filteredChatRooms = allChatRooms.filter { chatRoom in
                // 채팅방 이름으로 검색
                chatRoom.chatroomName.lowercased().contains(trimmedSearchText.lowercased()) ||
                // 마지막 메시지로 검색
                (chatRoom.chatList.last?.message.lowercased().contains(trimmedSearchText.lowercased()) ?? false)
            }
        }
        
        sortChatRoomsByLatestMessage()
        chatListCollectionView.reloadData()
        
        // 검색 결과 피드백
        if filteredChatRooms.isEmpty && !trimmedSearchText.isEmpty {
            print("검색 결과가 없습니다: '\(trimmedSearchText)'")
        } else {
            print("'\(trimmedSearchText)' 검색 결과: \(filteredChatRooms.count)개")
        }
    }
}


// TODO:
/*
오토레이아웃 수정을 통해 글자에 따라 채팅버블유동적으로 조절하기 (내채팅은 적용, 상대 채팅은 미적용)
    + 텍스트라벨 디자인 짜치는 경우가 있음, 수정 필요
날짜가 달라졌을 때, 날짜 구분선 넣어보기
    아마 구조체 내부에서 날짜 값 확인후 dd 기준으로 구분선을 넣어야할듯, 근데 해당 로직이 있는지 참고자료 조사 필요
‘메시지를 입력하세요’ 란인 텍스트뷰를, 세줄까지 늘려보기 (카카오톡처럼)
    해당 부분 textField -> textView로 교체필요
*/
