//
//  QRCodeScannerView.swift
//  Pods-QRCodeScanner_Example
//
//  Created by Tao on 2018/5/15.
//

import UIKit
import AVFoundation

public class SimpleQRCodeScannerView: UIView {

    @objc public var resultBlock: ((_ code: String) -> (Swift.Void))?
    
    @objc public var scanRect :CGRect = CGRect.zero{
        didSet{
            if let output = session.outputs.first as? AVCaptureMetadataOutput {
                output.rectOfInterest = CGRect(x: scanRect.origin.y/self.frame.size.height,
                                               y: scanRect.origin.x/self.frame.size.width,
                                               width: scanRect.size.height/self.frame.size.height,
                                               height: scanRect.size.width/self.frame.size.width)
            }
        }
    }
    
    @objc public func start(){
        guard self.ready else {
            self.delayHandling = true
            return
        }
        if !self.session.isRunning {
            self.session.startRunning()
            self.codeMaskView.scanRect = scanRect
            self.codeMaskView.addTimer()
        }
    }
    
    @objc public func stop(){
        self.session.stopRunning()
        self.codeMaskView.removeTimer()
    }
    
    
    
    private var ready :Bool = false
    private var delayHandling :Bool = false
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        config()
    }

    private func config(){
        AccessCameraPermission {  granted in
            guard granted else{return}
            self.loadScanner()
            guard self.delayHandling else{return}
            self.start()
        }
    }
    

    private let session = AVCaptureSession()
    private func loadScanner(){
        guard let device = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: device) else{return}
        let layer = AVCaptureVideoPreviewLayer(session: session)
        let output = AVCaptureMetadataOutput()
        session.addInput(input)
        session.addOutput(output)
        let queue = DispatchQueue(label: "Metadata refresh")
        output.setMetadataObjectsDelegate(self, queue: queue)
        output.metadataObjectTypes = [.qr]
        self.scanRect = CGRect(x: self.frame.width*0.15, y: self.frame.height*0.2, width: self.frame.width*0.7, height: self.frame.height*0.5)
        layer.videoGravity = .resizeAspectFill
        layer.frame = self.bounds
        self.layer.addSublayer(layer)
        self.ready = true
    }
    
    lazy private var codeMaskView :SimpleQRCodeMaskView = {
        let view = SimpleQRCodeMaskView(frame: self.frame)
        self.superview?.addSubview(view)
        return view;
    }()
    
}

extension SimpleQRCodeScannerView :AVCaptureMetadataOutputObjectsDelegate{
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {return}
        guard let code = object.stringValue, code.count > 0 else {return}
        
        DispatchQueue.main.async {
            self.stop()
            self.resultBlock?(code)
        }
    }
        

}


public func AccessCameraPermission(result : @escaping (Bool) -> Void){
    AVCaptureDevice.requestAccess(for: .video) { granted in
        DispatchQueue.main.async {
            result(granted)
        }
    }
}

