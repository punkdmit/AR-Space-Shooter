//
//  GameView.swift
//  ARShooter2
//
//  Created by Dmitry Apenko on 26.09.2023.
//

import UIKit
import ARKit
import SnapKit

class GameView: UIView {
    
    let sceneView = ARSCNView()
    let beatsSpheresLabel = UILabel()
    let aimImage = UIImageView()
    let shootImage = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        sceneView.scene.background.contents = UIImage(named: "Space")
        sceneView.showsStatistics = false

        beatsSpheresLabel.text = "0"
        beatsSpheresLabel.textColor = .white

        
        aimImage.image = UIImage(named: "Aim")
        
        shootImage.image = UIImage(named: "Shoot")
    }
    
    func setupConstraints() {
        self.addSubview(sceneView)
        sceneView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sceneView.addSubview(beatsSpheresLabel)
        beatsSpheresLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(5)
        }
        
        sceneView.addSubview(aimImage) 
        aimImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(32)
        }
        
        sceneView.addSubview(shootImage)
        shootImage.snp.makeConstraints {
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            $0.width.equalTo(shootImage.snp.height).multipliedBy(1.156)
            $0.width.equalTo(128)
        }
    }
}
