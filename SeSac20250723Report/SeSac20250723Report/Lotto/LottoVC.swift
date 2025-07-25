//
//  LottoVC.swift
//  SeSac20250723Report
//
//  Created by 유태호 on 7/24/25.
//

import UIKit
import SnapKit
import Alamofire

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
    
    // 피커뷰 관련 프로퍼티
    let pickerView = UIPickerView()
    let toolbar = UIToolbar()
    var lottoNumbers: [Int] = Array(1...1000) // 1부터 1000까지의 회차 번호
    
    override func viewDidLoad() {
        super.view.backgroundColor = .white
        
        configureHierarchy()
        configureView()
        configureLayout()
        setupPickerView()
    }
    
    func setupPickerView() {
        // 피커뷰 설정
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // 툴바 설정
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        let cancelButton = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        toolbar.items = [cancelButton, flexSpace, doneButton]
        
        // 텍스트필드에 피커뷰와 툴바 설정
        lottoNumberTextField.inputView = pickerView
        lottoNumberTextField.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedNumber = lottoNumbers[selectedRow]
        lottoNumberTextField.text = "\(selectedNumber)"
        
        // 선택된 번호로 로또 정보 요청
        lottoRequest(drwNo: selectedNumber)
        
        lottoNumberTextField.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        lottoNumberTextField.resignFirstResponder()
    }
    
    func lottoRequest(drwNo: Int = 1000) {
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(drwNo)"
        AF.request(url, method: .get)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LottoNumber.self) { response in
            
            switch response.result {
                case .success(let lottoNumber):
                    print(lottoNumber)
                    
                    // UI 업데이트는 메인 스레드에서 실행
                    DispatchQueue.main.async {
                        self.updateLottoNumbers(with: lottoNumber)
                    }
                
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func updateLottoNumbers(with lottoNumber: LottoNumber) {
        // 스택뷰의 기존 번호 라벨들 업데이트
        let numbers = [
            lottoNumber.drwtNo1,
            lottoNumber.drwtNo2,
            lottoNumber.drwtNo3,
            lottoNumber.drwtNo4,
            lottoNumber.drwtNo5,
            lottoNumber.drwtNo6
        ]
        
        var labelIndex = 0
        for arrangedSubview in horizontalStackView.arrangedSubviews {
            if let numberLabel = arrangedSubview as? LottoNumberLabel, labelIndex < numbers.count {
                numberLabel.text = "\(numbers[labelIndex])"
                labelIndex += 1
            }
        }
        
        // 보너스 번호 업데이트
        bonusNumberLabel.text = "\(lottoNumber.bnusNo)"
        
        // 회차 정보 업데이트
        lottoNumberMainLabel.text = "\(lottoNumber.drwNo)회차 당첨번호"
        
        // 추첨일 업데이트
        lottoDateLabel.text = "\(lottoNumber.drwNoDate) 추첨"
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension LottoVC: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lottoNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(lottoNumbers[row])회차"
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
