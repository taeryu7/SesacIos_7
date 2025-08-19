//
//  PhotoDetailViewController.swift
//  Sesac250814
//
//  Created by 유태호 on 8/14/25.
//

import UIKit
import SnapKit
import Charts
import SwiftUI

final class PhotoDetailViewController: UIViewController {
    
    private let viewModel: PhotoDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let profileImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let likeButton = UIButton()
    
    private let mainImageView = UIImageView()
    
    private let infoTitleLabel = UILabel()
    private let sizeLabel = UILabel()
    private let viewsLabel = UILabel()
    private let downloadsLabel = UILabel()
    
    private let chartTitleLabel = UILabel()
    private let segmentedControl = UISegmentedControl(items: ["조회수", "다운로드"])
    private let chartContainerView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    init(photo: Photo) {
        self.viewModel = PhotoDetailViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        bindViewModel()
        viewModel.loadStatistics()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "사진 상세"
        
        scrollView.showsVerticalScrollIndicator = false
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.backgroundColor = .systemGray5
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = .black
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .systemGray
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .systemRed
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        mainImageView.backgroundColor = .systemGray6
        
        infoTitleLabel.text = "정보"
        infoTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        infoTitleLabel.textColor = .black
        
        [sizeLabel, viewsLabel, downloadsLabel].forEach { label in
            label.font = .systemFont(ofSize: 14)
            label.textColor = .darkGray
            label.numberOfLines = 0
        }
        
        chartTitleLabel.text = "차트"
        chartTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        chartTitleLabel.textColor = .black
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        chartContainerView.backgroundColor = .systemGray6
        chartContainerView.layer.cornerRadius = 8
        
        loadingIndicator.hidesWhenStopped = true
    }
    
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [profileImageView, nameLabel, dateLabel, likeButton, mainImageView,
         infoTitleLabel, sizeLabel, viewsLabel, downloadsLabel,
         chartTitleLabel, segmentedControl, chartContainerView, loadingIndicator].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading).offset(-12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileImageView.snp.bottom)
            make.leading.equalTo(nameLabel)
            make.trailing.lessThanOrEqualTo(likeButton.snp.leading).offset(-12)
        }
        
        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.trailing.equalToSuperview().offset(-16)
            make.width.height.equalTo(30)
        }
        
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        sizeLabel.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(infoTitleLabel)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(infoTitleLabel)
        }
        
        downloadsLabel.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(infoTitleLabel)
        }
        
        chartTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(downloadsLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(infoTitleLabel)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(chartTitleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalTo(infoTitleLabel)
            make.height.equalTo(32)
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalTo(infoTitleLabel)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(chartContainerView)
        }
    }
    
    private func bindViewModel() {
        viewModel.photoDetailInfo.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updatePhotoInfo()
            }
        }
        
        viewModel.statisticsInfo.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updateStatisticsInfo()
            }
        }
        
        viewModel.isLoading.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if self?.viewModel.isLoading.value == true {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.chartData.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                self?.updateChart()
            }
        }
        
        viewModel.showToast.bind(owner: self) { [weak self] in
            DispatchQueue.main.async {
                if let message = self?.viewModel.showToast.value {
                    self?.showToast(message: message)
                    self?.viewModel.showToast.value = nil
                }
            }
        }
    }

    private func updatePhotoInfo() {
        let photoInfo = viewModel.photoDetailInfo.value
        nameLabel.text = photoInfo.photo.user.name
        dateLabel.text = photoInfo.formattedDate
        sizeLabel.text = photoInfo.sizeText
        likeButton.isSelected = photoInfo.isLiked
        
        loadImage(from: viewModel.getProfileImageURL(), into: profileImageView)
        loadImage(from: viewModel.getMainImageURL(), into: mainImageView)
    }
    
    private func updateStatisticsInfo() {
        let statisticsInfo = viewModel.statisticsInfo.value
        viewsLabel.text = statisticsInfo.viewsText
        downloadsLabel.text = statisticsInfo.downloadsText
    }
    
    private func updateChart() {
        chartContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let chartData = viewModel.chartData.value
        
        if chartData.isEmpty {
            showEmptyChart()
            return
        }
        
        let chartView = createSwiftUIChart(data: chartData)
        let hostingController = UIHostingController(rootView: chartView)
        
        addChild(hostingController)
        chartContainerView.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        hostingController.view.backgroundColor = .clear
    }
    
    private func createSwiftUIChart(data: [ChartDataItem]) -> some View {
        Chart {
            ForEach(data) { item in
                AreaMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.8),
                            Color.blue.opacity(0.3),
                            Color.blue.opacity(0.1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Value", item.value)
                )
                .foregroundStyle(Color.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month(.abbreviated).day())
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel()
            }
        }
        .animation(.easeInOut(duration: 0.8), value: segmentedControl.selectedSegmentIndex)
    }
    
    private func showEmptyChart() {
        let messageLabel = UILabel()
        messageLabel.text = "차트 데이터를 불러올 수 없습니다"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .systemGray
        messageLabel.font = .systemFont(ofSize: 16)
        
        chartContainerView.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    @objc private func likeButtonTapped() {
        viewModel.toggleLike()
    }
    
    @objc private func segmentChanged() {
        viewModel.selectChartType(index: segmentedControl.selectedSegmentIndex)
    }
    
    private func showToast(message: String) {
        guard self.presentedViewController == nil else { return }
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true)
        }
    }
}
