//
//  ARViewController.swift
//  Signal Beacon
//
//  Created by David Gallub on 11/4/17.
//  Copyright © 2017 Amatrine. All rights reserved.
//

import ARKit
import Firebase

class  ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var ARSceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for camera permissions
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {_ in
            
        })
        
        // Set up ARSceneView
        ARSceneView.delegate = self
        ARSceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create and run the ARSceneView session
        let configuration = ARWorldTrackingConfiguration()
        ARSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the session when page is closed
        ARSceneView.session.pause()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
}
