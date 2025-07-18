//
//  TravleMainViewController+CollectionView.swift
//  Sesac250718Report
//
//  Created by 유태호 on 7/19/25.
//

import UIKit

extension TravleMainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredChatRooms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TravleCollectionViewCell", for: indexPath) as! TravleCollectionViewCell
        
        let chatRoom = filteredChatRooms[indexPath.item]
        cell.configure(with: chatRoom)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedChatRoom = filteredChatRooms[indexPath.item]
        print("선택된 채팅방: \(selectedChatRoom.chatroomName)")
        
        // 채팅 상세 화면으로 이동
        let storyboard = UIStoryboard(name: "TravleChatView", bundle: nil)
        if let chatDetailVC = storyboard.instantiateViewController(withIdentifier: "TravleChatViewController") as? TravleChatViewController {
            chatDetailVC.chatRoom = selectedChatRoom
            
            // Navigation Controller push
            navigationController?.pushViewController(chatDetailVC, animated: true)
            
            print("화면 전환 완료: \(selectedChatRoom.chatroomName)")
        }
    }
}
