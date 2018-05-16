//
//  ScanViewController.swift
//  QRCodeScanner_Example
//
//  Created by Tao on 2018/5/15.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import UIKit
import SimpleQRCodeScanner

class ScanViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scanner.resultBlock = { [weak self] code in
            print(code)
            self?.navigationController?.popViewController(animated: true)
        }
    }
    

    @IBOutlet weak var scanner: SimpleQRCodeScannerView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.scanner.start()

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.scanner.stop()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
