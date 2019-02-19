//
//  QRCodeMaskView.swift
//  Pods-QRCodeScanner_Example
//
//  Created by Tao on 2018/5/16.
//

import UIKit

public class SimpleQRCodeMaskView: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public var scanRect :CGRect = CGRect.zero{
        didSet{
            self.setNeedsDisplay()
        }
    }

    override public func draw(_ rect: CGRect) {
        
        if let context  =  UIGraphicsGetCurrentContext() {
            context.setAllowsAntialiasing(true)

            context.setLineWidth(2)
            context.setStrokeColor(UIColor.white.cgColor)
            context.addRect(scanRect)
            context.strokePath()
            
            
            UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).set()
            context.addRect(rect)
            context.fillPath()
            context.setBlendMode(.clear)
            context.addRect(scanRect)
            context.fillPath()
            
        }
        
    }
    
    @objc public func addTimer(){
        self.timer?.invalidate()
        self.timer = Timer(fireAt: Date.distantPast, interval: 1.2, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    
    @objc public func removeTimer(){
        self.timer?.invalidate()
        self.scanLine.backgroundColor = UIColor.clear
        self.scanLine.frame = CGRect(x: self.scanRect.origin.x, y: self.scanRect.origin.y, width: self.scanRect.width, height: 1)
    }
    
    @objc public func timerFired(){
        self.scanLine.backgroundColor = UIColor.green
        UIView.animate(withDuration: 1, delay: 0, options: .curveLinear, animations: {
            self.scanLine.frame = CGRect(x: self.scanRect.origin.x, y: (self.scanRect.origin.y +  self.scanRect.height), width: self.scanRect.width, height: 1)
        }, completion: { finish in
            self.scanLine.backgroundColor = UIColor.clear
            self.scanLine.frame = CGRect(x: self.scanRect.origin.x, y: self.scanRect.origin.y, width: self.scanRect.width, height: 1)
        })
        
    }
    
    
    private var timer :Timer?
    private lazy var scanLine :UIImageView = {
        let line = UIImageView(frame: CGRect(x: self.scanRect.origin.x, y: self.scanRect.origin.y, width: self.scanRect.width, height: 1))
        line.backgroundColor = UIColor.green
        self.addSubview(line)
        return line;
    }()


}
