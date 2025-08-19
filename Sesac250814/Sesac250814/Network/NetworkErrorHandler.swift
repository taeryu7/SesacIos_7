//
//  NetworkErrorHandler.swift
//  Sesac250814
//
//  Created by 유태호 on 8/18/25.
//

import UIKit
import SnapKit

class NetworkErrorHandler {
    
    static let shared = NetworkErrorHandler()
    private init() {}
    
    func showAlert(
        for error: NetworkError,
        from viewController: UIViewController,
        retryAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: "네트워크 오류",
            message: error.userMessage,
            preferredStyle: .alert
        )
        
        // 재시도 가능한 에러인 경우 재시도 버튼 추가
        if error.shouldRetry, let retryAction = retryAction {
            alert.addAction(UIAlertAction(title: "다시 시도", style: .default) { _ in
                retryAction()
            })
        }
        
        // 취소/확인 버튼
        let cancelTitle = retryAction != nil ? "취소" : "확인"
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            cancelAction?()
        })
        
        viewController.present(alert, animated: true)
    }
    
    func showErrorView(
        for error: NetworkError,
        in containerView: UIView,
        retryAction: @escaping () -> Void
    ) {
        // 기존 에러 뷰 제거
        removeErrorView(from: containerView)
        
        let errorView = NetworkErrorView(error: error, retryAction: retryAction)
        errorView.tag = 999
        
        containerView.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    
    func removeErrorView(from containerView: UIView) {
        containerView.subviews.forEach { view in
            if view.tag == 999 {
                UIView.animate(withDuration: 0.3) {
                    view.alpha = 0
                } completion: { _ in
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func showToast(
        message: String,
        in viewController: UIViewController,
        duration: TimeInterval = 2.0
    ) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}

class NetworkErrorView: UIView {
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let retryButton = UIButton()
    
    private let retryAction: () -> Void
    
    init(error: NetworkError, retryAction: @escaping () -> Void) {
        self.retryAction = retryAction
        super.init(frame: .zero)
        
        setupUI(error: error)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(error: NetworkError) {
        backgroundColor = .clear
        
        // 아이콘 설정
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemGray
        
        switch error {
        case .noInternetConnection:
            iconImageView.image = UIImage(systemName: "wifi.slash")
            titleLabel.text = "인터넷 연결 없음"
        case .serverError:
            iconImageView.image = UIImage(systemName: "server.rack")
            titleLabel.text = "서버 오류"
        case .timeout:
            iconImageView.image = UIImage(systemName: "clock.arrow.circlepath")
            titleLabel.text = "연결 시간 초과"
        case .tooManyRequests:
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle")
            titleLabel.text = "API 한도 초과"
        default:
            iconImageView.image = UIImage(systemName: "exclamationmark.circle")
            titleLabel.text = "오류 발생"
        }
        
        // 라벨 설정
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        
        messageLabel.text = error.userMessage
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        // 버튼 설정
        if error.shouldRetry {
            retryButton.setTitle("다시 시도", for: .normal)
            retryButton.setTitleColor(.white, for: .normal)
            retryButton.backgroundColor = .systemBlue
            retryButton.layer.cornerRadius = 8
            retryButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
            retryButton.isHidden = false
        } else {
            retryButton.isHidden = true
        }
    }
    
    private func setupLayout() {
        [iconImageView, titleLabel, messageLabel, retryButton].forEach {
            addSubview($0)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(44)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func retryButtonTapped() {
        retryAction()
    }
}
