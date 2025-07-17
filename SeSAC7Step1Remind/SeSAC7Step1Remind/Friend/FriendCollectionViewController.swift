//
//  FriendCollectionViewController.swift
//  SeSAC7Step1Remind
//
//  Created by 유태호 on 7/17/25.
//

import UIKit
/*
 TableView -> CollectionView
       row -> item
 1. collectionView 아웃렛 연결
 2. 하위 객체들 호출
 */

class FriendCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xib = UINib(nibName: "FriendCollectionViewCell", bundle: nil)
        
        myCollectionView.register(xib, forCellWithReuseIdentifier: "FriendCollectionViewCell")
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        /// 셀의 너비와 높이도 설정하는것이 필요함.
        
        let layout = UICollectionViewFlowLayout()
        
        // 화면넓이 호출
        let deviceWidth = UIScreen.main.bounds.width
        
        // 화면 넓이에서 계산
        let cellWidth: CGFloat = deviceWidth - (16*3) - (16*3)
        
        
        layout.itemSize = CGSize(width: cellWidth/4 , height: cellWidth/4)
        
        // 전체셀에서 화면과의 여백
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 16, right: 16)
        
        // 객체간 여백
        layout.minimumInteritemSpacing = 14
        
        // 객체간 여백
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        
        myCollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionViewCell", for: indexPath) as! FriendCollectionViewCell
        
        
        cell.nameLabel.text = "\(indexPath)"
        
        return cell
    }
    
    
    
    
    
}
