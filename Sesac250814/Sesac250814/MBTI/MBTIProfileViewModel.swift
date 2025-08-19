//
//  MBTIProfileViewModel.swift
//  Sesac250814
//
//  Created by 유태호 on 8/16/25.
//

import Foundation

protocol MBTIProfileViewModelDelegate: AnyObject {
    func didSelectProfileImage(index: Int)
}

class MBTIProfileViewModel {
    
    weak var delegate: MBTIProfileViewModelDelegate?
    
    // Observable Properties
    var selectedImageIndex: Observable<Int> = Observable(0)
    var previewImageName: Observable<String> = Observable("char1")
    var profileItems: Observable<[ProfileImageItem]> = Observable([])
    
    init(currentImageIndex: Int = 0) {
        selectedImageIndex.value = currentImageIndex
        updatePreviewImage()
        updateProfileItems()
        setupBindings()
    }
    
    private func setupBindings() {
        selectedImageIndex.bind { [weak self] in
            self?.updatePreviewImage()
            self?.updateProfileItems()
        }
    }
    
    func selectProfileImage(at index: Int) {
        selectedImageIndex.value = index
    }
    
    func confirmSelection() {
        delegate?.didSelectProfileImage(index: selectedImageIndex.value)
    }
    
    func getNumberOfItems() -> Int {
        return ProfileImageGrid.totalImageCount
    }
    
    func getProfileItem(at index: Int) -> ProfileImageItem {
        let isSelected = index == selectedImageIndex.value
        return ProfileImageItem(index: index, isSelected: isSelected)
    }
    
    private func updatePreviewImage() {
        let imageName = "char\(selectedImageIndex.value + 1)"
        previewImageName.value = imageName
    }
    
    private func updateProfileItems() {
        let items = ProfileImageGrid.generateItems(selectedIndex: selectedImageIndex.value)
        profileItems.value = items
    }
}
