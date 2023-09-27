//
//  ResultView.swift
//  ARShooter2
//
//  Created by Dmitry Apenko on 26.09.2023.
//

import UIKit
import SnapKit

class ResultView: UIView {
    
    lazy var mainStack = UIStackView()
    lazy var shootsStack = UIStackView()
    lazy var beatsSpheresStack = UIStackView()
    
    lazy var shootsLabel = UILabel()
    lazy var shootsCountLabel = UILabel()
    
    lazy var beatsLabel = UILabel()
    lazy var beatsCountLabel = UILabel()
    
    let newGameButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch traitCollection.userInterfaceStyle == .dark {
        case true:
            shootsLabel.textColor = .white
            shootsCountLabel.textColor = .white
            beatsLabel.textColor = .white
            beatsCountLabel.textColor = .white
        case false:
            shootsLabel.textColor = .black
            shootsCountLabel.textColor = .black
            beatsLabel.textColor = .black
            beatsCountLabel.textColor = .black
        }
    }
    
    func setupUI() {
        self.backgroundColor = .systemBackground
        
        mainStack.axis = .vertical
        mainStack.spacing = 24
        mainStack.alignment = .fill
        mainStack.distribution = .fill
        mainStack.contentMode = .scaleToFill
        
        shootsStack.axis = .horizontal
        shootsStack.spacing = 8
        shootsStack.alignment = .top
        shootsStack.distribution = .fill
        shootsStack.contentMode = .scaleToFill

        beatsSpheresStack.axis = .horizontal
        beatsSpheresStack.spacing = 8
        beatsSpheresStack.alignment = .top
        beatsSpheresStack.distribution = .fill
        beatsSpheresStack.contentMode = .scaleToFill

        shootsLabel.text = "Выстрелы:"
        shootsLabel.font = UIFont.systemFont(ofSize: 17)
        
        shootsCountLabel.font = UIFont.systemFont(ofSize: 17)
        shootsCountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        shootsCountLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        beatsLabel.text = "Попадания:"
        beatsLabel.font = UIFont.systemFont(ofSize: 17)

        beatsCountLabel.font = UIFont.systemFont(ofSize: 17)
        beatsCountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        beatsCountLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

        let font = UIFont.boldSystemFont(ofSize: 17)
        let textString = NSAttributedString(string: "Новая игра", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: font])
        newGameButton.setAttributedTitle(textString, for: .normal)
    }
    
    func setupConstraints() {
        self.addSubview(mainStack)
        mainStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        mainStack.addArrangedSubview(shootsStack)
        shootsStack.addArrangedSubview(shootsLabel)
        shootsStack.addArrangedSubview(shootsCountLabel)
            
        mainStack.addArrangedSubview(beatsSpheresStack)
        beatsSpheresStack.addArrangedSubview(beatsLabel)
        beatsSpheresStack.addArrangedSubview(beatsCountLabel)
            
        mainStack.addArrangedSubview(newGameButton)
        
    }
}
