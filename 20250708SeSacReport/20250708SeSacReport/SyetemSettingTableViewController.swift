//
//  SyetemSettingTableViewController.swift
//  20250708SeSacReport
//
//  Created by 유태호 on 7/9/25.
//

import UIKit

class SyetemSettingTableViewController: UITableViewController {

    let allSettingList = ["공지사항", "실험실", "버전정보"]
    let personalSettingList = ["개인/보안", "알림", "채팅", "멀티프로필"]
    let extraSettingList = ["고객센터/도움말"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// 섹션 개수
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    /// 각 섹션의 셀 개수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return allSettingList.count
        case 1:
            return personalSettingList.count
        case 2:
            return extraSettingList.count
        default:
            return 0
        }
    }
    
    /// 섹션 헤더 타이틀
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "전체 설정"
        case 1:
            return "개인 설정"
        case 2:
            return "기타"
        default:
            return nil
        }
        
        
    }
    
    // 헤더가 표시되기 직전에 스타일 변경
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = .systemGray2
        }
    }
    
    /// 셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = allSettingList[indexPath.row]
        case 1:
            cell.textLabel?.text = personalSettingList[indexPath.row]
        case 2:
            cell.textLabel?.text = extraSettingList[indexPath.row]
        default:
            break
        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        
        return cell
    }
    
    
    /// 셀 높이
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    /// 섹션 간 간격 조정
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
}
