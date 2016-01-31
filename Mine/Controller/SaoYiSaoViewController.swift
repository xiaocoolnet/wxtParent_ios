//
//  SaoYiSaoViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/1/31.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit
import AVFoundation

class SaoYiSaoViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let session = AVCaptureSession()
    var layer: AVCaptureVideoPreviewLayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "二维码扫描"
        self.view.backgroundColor = UIColor.grayColor()
        let labIntroudction = UILabel(frame:CGRectMake(0, 80, 290, 50))
        labIntroudction.center.x = self.view.bounds.width / 2
        labIntroudction.textAlignment = NSTextAlignment.Center
        labIntroudction.backgroundColor = UIColor.clearColor()
        labIntroudction.numberOfLines = 2
        labIntroudction.textColor = UIColor.whiteColor()
        labIntroudction.text = "请扫描学校指定地点的二维码"
        self.view.addSubview(labIntroudction)
        let imageView = UIImageView(frame:CGRectMake(0, 140, self.view.frame.width-20, 300))
        imageView.center.x = self.view.bounds.width / 2
        imageView.image = UIImage(named:"pick_bg")
        self.view.addSubview(imageView)
    }
    
    func backClick(){
        
    }
    func turnTorchOn(){
        
    }
    func pickPicture(){
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupCamera()
        self.session.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func setupCamera(){
        self.session.sessionPreset = AVCaptureSessionPresetHigh
        var error : NSError?
        let input   : AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            }
        } catch _ {
            //Error handling, if needed
        }
        if (error != nil) {
            print(error!.description)
            return
        }
        
        layer = AVCaptureVideoPreviewLayer(session: session)
        layer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        layer!.frame = CGRectMake(self.view.bounds.width / 2 - 140,150,280,280);
        //layer!.contentsCenter.origin.x = self.view.bounds.width / 2
        print(layer!.contentsCenter.origin.x)
        self.view.layer.insertSublayer(self.layer!, atIndex: 0)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        if session.canAddOutput(output) {
            session.addOutput(output)
            output.metadataObjectTypes = [AVMetadataObjectTypeQRCode];
        }
        
        session.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject], fromConnection connection: AVCaptureConnection!){
        var stringValue:String?
        if metadataObjects.count > 0 {
            var metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metadataObject.stringValue
        }
        self.session.stopRunning()
        print("code is \(stringValue)")
        
        //        let alertController = UIAlertController(title: "二维码", message: "扫到的二维码内容为:\(stringValue)", preferredStyle: UIAlertControllerStyle.Alert)
        //        alertController.addAction(UIAlertAction(title: "确认", style: UIAlertActionStyle.Default, handler: nil))
        //        self.presentViewController(alertController, animated: true, completion: nil)
        var alertView = UIAlertView()
        alertView.delegate=self
        alertView.title = "二维码"
        alertView.message = "扫到的二维码内容为:\(stringValue)"
        alertView.addButtonWithTitle("确认")
        alertView.show()
    }
}
