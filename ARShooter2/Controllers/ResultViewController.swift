//
//  ResultViewController.swift
//  ARShooter2
//
//  Created by Dmitry Apenko on 07.09.2023.
//

import UIKit

class ResultViewController: GenericViewController<ResultView> {

    private var shootsCount: Int = 0
    private var beatsSpheresCount: Int = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        setup()
    }
    
    convenience init(parameters: Results) {
        self.init()
            
        shootsCount = parameters.shootsCount
        beatsSpheresCount = parameters.beatsSpheresCount
    }
    
    init() {
        super.init(nibName: "ResultViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func restartButton() {
        initViewController()
    }
    
    func setup() {
        rootView.beatsCountLabel.text = "\(beatsSpheresCount)"
        rootView.shootsCountLabel.text = "\(shootsCount)"
        rootView.newGameButton.addTarget(self, action: #selector(restartButton), for: .touchUpInside)
    }
    
    func initViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}


