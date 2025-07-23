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
    
    let horizontalStackView: UIStackView = {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .equalSpacing
        horizontalStackView.spacing = 5
        
        return horizontalStackView
    }()
    
    let bonusTextLabel = LottoBonusLabel()
    var bonusNumberLabel: LottoNumberLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureView()
        configureLayout()
    }
}

extension LottoVC {
    
    func configureHierarchy() {
        // 라벨 생성해서 스택뷰에 추가
        for i in 1...6 {
            let numberLabel = LottoNumberLabel()
            numberLabel.text = "\(i)번"
            // 정사각형 크기 제약
            numberLabel.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            horizontalStackView.addArrangedSubview(numberLabel)
        }
        
        // + 라벨
        let plusLabel = LottoPlusLabel()
        horizontalStackView.addArrangedSubview(plusLabel)
        
        // 7번 라벨 스택뷰에 추가
        bonusNumberLabel = LottoNumberLabel()
        bonusNumberLabel.text = "7번"
        bonusNumberLabel.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        horizontalStackView.addArrangedSubview(bonusNumberLabel)
        
        view.addSubview(lottoNumberTextField)
        view.addSubview(lottoExplanationLabel)
        view.addSubview(lottoDateLabel)
        view.addSubview(lottoNumberMainLabel)
        view.addSubview(horizontalStackView)
        view.addSubview(bonusTextLabel)
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
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(lottoNumberMainLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        bonusTextLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(5)
            make.centerX.equalTo(bonusNumberLabel)  // 7번 라벨 중앙에 정렬
        }
    }
    
    func configureLayout() {
        view.backgroundColor = .white
    }
}

#Preview {
    LottoVC()
}
