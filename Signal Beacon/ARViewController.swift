//
//  ARViewController.swift
//  Signal Beacon
//
//  Created by David Gallub on 11/4/17.
//  Copyright © 2017 Amatrine. All rights reserved.
//

import ARKit
import SpriteKit
import Firebase
import CoreLocation
import GLKit

class  ARViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet weak var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for camera permissions
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: {_ in
            
        })
        
        // Set up ARSceneView
        sceneView.delegate = self
        
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        let scene = SKScene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        sceneView.presentScene(scene)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Create anchor using the camera's current position
        if let currentFrame = sceneView.session.currentFrame {
            // Create a transform with a translation of 0.2 meters in front of the camera
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's
        // session.
        let labelNode = SKLabelNode(text: "Hello, Thomas")
        labelNode.fontSize = 6
        labelNode.fontColor = UIColor.green
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        return labelNode;
    }
    
    /**
     Precise bearing between two points.
     */
    func bearingBetween(startLocation: CLLocation, endLocation: CLLocation) -> Float {
        var azimuth: Float = 0
        let lat1 = GLKMathDegreesToRadians(
            Float(startLocation.coordinate.latitude)
        )
        let lon1 = GLKMathDegreesToRadians(
            Float(startLocation.coordinate.longitude)
        )
        let lat2 = GLKMathDegreesToRadians(
            Float(endLocation.coordinate.latitude)
        )
        let lon2 = GLKMathDegreesToRadians(
            Float(endLocation.coordinate.longitude)
        )
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        azimuth = GLKMathRadiansToDegrees(Float(radiansBearing))
        if(azimuth < 0) { azimuth += 360 }
        return azimuth
    }
    
    func convertGLKMatrix4Tosimd_float4x4(matrix: GLKMatrix4) -> float4x4{
        return float4x4(float4(matrix.m00,matrix.m01,matrix.m02,matrix.m03),
                        float4( matrix.m10,matrix.m11,matrix.m12,matrix.m13 ),
                        float4( matrix.m20,matrix.m21,matrix.m22,matrix.m23 ),
                        float4( matrix.m30,matrix.m31,matrix.m32,matrix.m33 ))
    }
    
    func getTransformGiven(currentLocation: CLLocation, pinLocation: CLLocation) -> matrix_float4x4 {
        let bearing = bearingBetween(
            startLocation: currentLocation,
            endLocation: pinLocation
        )
        let distance = 5
        let originTransform = matrix_identity_float4x4
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -1 * Float(distance)
        let rotationMatrix = GLKMatrix4RotateY(GLKMatrix4Identity, -1 * bearing)
        let transformMatrix = simd_mul(convertGLKMatrix4Tosimd_float4x4(matrix: rotationMatrix), translationMatrix)
        return simd_mul(originTransform, transformMatrix)
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
    }
}
