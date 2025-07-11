//
//  emotionViewController.swift
//  Sesac250702ReportTHR
//
//  Created by 유태호 on 7/2/25.
//

import UIKit

class emotionViewController: UIViewController {

    
    @IBOutlet var imageButtonCollection: [UIButton]!
    
    @IBOutlet var countLabelCollection: [UILabel]!
    
    let imageNames = ["mono_slime1", "mono_slime2", "mono_slime3", "mono_slime4", "mono_slime5", "mono_slime6", "mono_slime7", "mono_slime8", "mono_slime9"]
    
    let labelNames = ["행복해", "사랑해","좋아해","당황해","속상해","우울해","심심해","침울해","눈물나"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        for (index, button) in imageButtonCollection.enumerated() {
            if index < imageNames.count {
                imageViewUI(LB: button, IM: imageNames[index])
            }
        }
        
        for (index, label) in countLabelCollection.enumerated() {
            if index < labelNames.count {
                labelUI(LB: label, LM: labelNames[index])
            }
        }
        
        for (index, button) in imageButtonCollection.enumerated() {
            button.tag = index
        }
        
    }
    
    private func imageViewUI(
        LB button: UIButton,
        IM backgroundImageName: String
    ) {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: backgroundImageName)
        config.background.imageContentMode = .scaleAspectFit
        config.title = ""
        button.configuration = config
        
        button.clipsToBounds = true
    }
    
    private func labelUI(
        LB label: UILabel,
        LM labeltext: String
    ) {
        label.text = labeltext
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
    }
    
    @IBAction func collectionButtonAction(_ sender: UIButton) {
        let index = sender.tag
        
        if index < countLabelCollection.count && index < labelNames.count {
            countLabelCollection[index].text = "\(labelNames[index]) \(Int.random(in: 1...999))"
        }
    }
    
    @IBAction func allAddButton(_ sender: UIButton) {
        for (index, label) in countLabelCollection.enumerated() {
            if index < labelNames.count {
                updateLabelCount(label: label, emotion: labelNames[index])
            }
        }
    }

    @IBAction func allRandomButton(_ sender: UIBarButtonItem) {
        for (index, label) in countLabelCollection.enumerated() {
            if index < labelNames.count {
                label.text = "\(labelNames[index]) \(Int.random(in: 1...999))"
            }
        }
    }
    
    @IBAction func allRandomButton2(_ sender: UIButton) {
        for (index, label) in countLabelCollection.enumerated() {
            if index < labelNames.count {
                label.text = "\(labelNames[index]) \(Int.random(in: 1...999))"
            }
        }
    }
    
    
    
    private func updateLabelCount(label: UILabel, emotion: String) {
        guard let currentText = label.text else { return }
        
        if currentText.contains(" ") {
            let components = currentText.components(separatedBy: " ")
            if components.count == 2, let currentNumber = Int(components[1]) {
                label.text = "\(emotion) \(currentNumber + 1)"
            } else {
                label.text = "\(emotion) 1"
            }
        } else {
            label.text = "\(emotion) 1"
        }
    }
    
}
