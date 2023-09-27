//
//  GameViewController.swift
//  ARShooter
//
//  Created by Dmitry Apenko on 06.09.2023.
//

import UIKit
import ARKit

class GameViewController: GenericViewController<GameView>, ARSCNViewDelegate {
    
    private var audioPlayer: AVAudioPlayer?
    
    private var sphereModel: SphereModel?
    private var sphereNode: SCNNode?
    
    private var gameTimer: Timer?
    private var elapsedTime: TimeInterval = 60
    private var beforeStartTime: TimeInterval = 3
    
    private var counter: Int = 0
    private var beatsSpheresCounter: Int = 0 {
        didSet {
            rootView.beatsSpheresLabel.text = "\(beatsSpheresCounter)"
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        rootView.sceneView.scene.background.contents = UIImage(named: "Space")
        createSphere()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setup()
        createSphereNode()
        timerBeforeGameStart()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetSpheres()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rootView.sceneView.frame = view.bounds
    }
    
    func setup() {
        let configuration = ARWorldTrackingConfiguration()
        rootView.sceneView.session.run(configuration)
        rootView.sceneView.delegate = self
    }
    
    func resetSpheres() {
        rootView.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        counter = 0
        beatsSpheresCounter = 0
    }
    
    func createSphere() {
        sphereModel = SphereModel(radius: 0.2)
    }
    
    func createSphereNode() {
        guard let sphereModel = sphereModel else { return }
        
        let virtualObjectScene = SCNScene()
        
        let sphereShape = SCNSphere(radius: CGFloat(sphereModel.radius))
        sphereNode = SCNNode(geometry: sphereShape)
        sphereNode?.name = "Sphere"
        sphereNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Sphere")
        sphereNode?.geometry?.firstMaterial?.emission.contents = UIImage(named: "Clouds")
        
        for child in virtualObjectScene.rootNode.childNodes {
            sphereNode?.addChildNode(child)
        }
        
        let rotationAction = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
        let repeatAction = SCNAction.repeatForever(rotationAction)
        sphereNode?.runAction(repeatAction)
        
        rootView.sceneView.scene.rootNode.addChildNode(sphereNode!)
        
        setRandomPosition(minDistance: 3, maxDistance: 5)
    }
    
    func setRandomPosition(minDistance: Float, maxDistance: Float) {
        let distance = Float.random(in: minDistance...maxDistance)
        
        let horizontalAngle = randomRotationAngle()
        let verticalAngle = randomRotationAngle()
        
        let xPosition = distance * cos(horizontalAngle) * cos(verticalAngle)
        let yPosition = distance * sin(verticalAngle)
        let zPosition = distance * sin(horizontalAngle) * cos(verticalAngle)
        
        setPosition(x: xPosition, y: yPosition, z: zPosition)
    }
    
    func setPosition(x: Float, y: Float, z: Float) {
        sphereNode?.position = SCNVector3(x, y, z)
    }
    
    private func randomRotationAngle() -> Float {
        return Float.random(in: 0..<360) * .pi / 180
    }
    
    func fingerGestureRecognizer() {
        let tapGestureRecongizer = UITapGestureRecognizer.init(target: self, action: #selector(tappedByFinger(recognizer:)))
        rootView.sceneView.addGestureRecognizer(tapGestureRecongizer)
    }
    
    @objc func tappedByFinger(recognizer: UIGestureRecognizer) {
        guard let sceneView = recognizer.view as? SCNView else { return }
        let touchLocation = recognizer.location(in: sceneView)
        let hit = sceneView.hitTest(touchLocation, options: nil)
        counter += 1
        
        if !hit.isEmpty {
            let node = hit[0].node
            if node.name == "Sphere" {
                node.removeFromParentNode()
                beatsSpheresCounter += 1
            }
        }
    }
    
    func shootImageGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleShootImageTap(_:)))
        rootView.shootImage.isUserInteractionEnabled = true
        rootView.shootImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleShootImageTap(_ recognizer: UITapGestureRecognizer) {
        shootSound()
        
        let screenCenter = CGPoint(x: rootView.sceneView.bounds.midX, y: rootView.sceneView.bounds.midY)
        
        counter += 1
        
        if let hitNode = checkForTarget(at: screenCenter) {
            hitNode.removeFromParentNode()
            beatsSpheresCounter += 1
        }
    }
    
    func shootSound() {
        guard let pathToSound = Bundle.main.path(forResource: "odinochnyiy-vyistrel-iz-multika", ofType: "wav") else { return }
        let url = URL(fileURLWithPath: pathToSound)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Звук не найден: \(ViewControllerError.invalidSound)")
        }
    }
    
    func checkForTarget(at point: CGPoint) -> SCNNode? {
        let hitTestResults = rootView.sceneView.hitTest(point, options: nil)
        
        guard let hitResult = hitTestResults.first else { return nil }
        
        let node = hitResult.node
        
        guard node.name == "Sphere" else { return nil }
        
        return node
    }
    
    func timerBeforeGameStart() {
        rootView.beatsSpheresLabel.isHidden = true
        rootView.aimImage.isHidden = true
        rootView.shootImage.isHidden = true
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.beforeStartTime -= 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            self?.timerStop()
            self?.timerStart()
        }
    }
    
    func timerStart() {
        rootView.beatsSpheresLabel.isHidden = false
        rootView.aimImage.isHidden = false
        rootView.shootImage.isHidden = false
        
        fingerGestureRecognizer()
        shootImageGestureRecognizer()
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.createSphereNode()
            self?.elapsedTime -= 1
        }
        
        Timer.scheduledTimer(withTimeInterval: 60, repeats: false) { [weak self] _ in
            self?.timerStop()
            self?.inizializeResultsScreen()
        }
    }
    
    func timerStop() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    func inizializeResultsScreen() {
        let result = Results(shootsCount: counter, beatsSpheresCount: beatsSpheresCounter)
        let resultViewController = ResultViewController(parameters: result)
        
        self.navigationController?.pushViewController(resultViewController, animated: true)
    }
}
