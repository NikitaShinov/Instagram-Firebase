//
//  CameraController.swift
//  Instagram Firebase
//
//  Created by max on 07.04.2022.
//

import UIKit
import AVFoundation


class CameraController: UIViewController {
    
    let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "right_arrow_shadow"), for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let captureButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "capture_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhot), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        setupHUD()
        
    }
    
    fileprivate func setupHUD() {
        view.addSubview(captureButton)
        captureButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(dismissButton)
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
    }
    
    @objc private func handleCapturePhot() {
        print ("Capturing photo")
    }
    
    @objc private func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        //1 setup inputs
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print ("could not setup device: \(error)")
        }
        
        //2 setup outputs
        
        let output = AVCapturePhotoOutput()
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
    
        //3 setup output preview
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
}
