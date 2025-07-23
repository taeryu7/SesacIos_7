//
//  LottoVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import UIKit
import SnapKit

class LottoVC: UIViewController {
    
    let lottoNumberTextField = {
        let lottoNumberTextField = LottoTextField()
        lottoNumberTextField.placeholder = "로또번호를 입력해보세요"
        
        return lottoNumberTextField
    }()
    
    let lottoExplanationLabel = {
        let lottoExplanationLabel = LottoExplanationLabel()
        lottoExplanationLabel.text = "당첨번호 안내"
        
        return lottoExplanationLabel
    }()
    
    let lottoDateLabel = {
        let lottoDateLabel = LottoDateLabel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        lottoDateLabel.text = "\(todayString) 추첨"
        
        return lottoDateLabel
    }()
    
    let lottoNumberMainLabel = {
        let lottoNumberMainLabel = LottoNumberMainLabel()
        lottoNumberMainLabel.text = "회차 당첨번호"
        
        return lottoNumberMainLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureLayout()
    }
}

extension LottoVC {
    
    func configureHierarchy() {
        view.addSubview(lottoNumberTextField)
        view.addSubview(lottoExplanationLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(lottoNumberMainLabel)
    }
    
    func configureView() {
        lottoNumberTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(44)
        }
        
        lottoExplanationLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoNumberTextField.snp.bottom).offset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        lottoDateLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoNumberTextField.snp.bottom).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        lottoNumberMainLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoDateLabel.snp.bottom).offset(30)
            make.centerX.equalTo(view)
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
    }
}

#Preview {
    LottoVC()
}
