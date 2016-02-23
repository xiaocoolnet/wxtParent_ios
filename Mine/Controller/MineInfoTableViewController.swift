//
//  MineInfoTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//

import UIKit

class MineInfoTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    var actionSheet: UIAlertController!
    var data = NSData()
    var hud = MBProgressHUD()
    var phone:String?
    var imageUrl:String?
    var imageCache = Dictionary<String,UIImage>()
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var avatorImage: UIImageView!
    
    @IBOutlet weak var avatorBtn: UIButton!
    
    @IBOutlet weak var guanXiLabel: UILabel!
    
    @IBOutlet weak var guanXiBtn: UIButton!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var phoneBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        let avatarUrl = NSURL(string: self.imageUrl!)
        let request: NSURLRequest = NSURLRequest(URL: avatarUrl!)
        //异步获取
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?)-> Void in
            if(data != nil){
                let imgTmp = UIImage(data: data!)
                self.imageCache[self.imageUrl!] = imgTmp
                self.avatorImage.image = imgTmp
                self.avatorImage.alpha = 1.0
            }
        })
        avatorBtn.layer.borderWidth = 1.0
        phoneNumber.text = phone!
        avatorBtn.layer.borderColor = UIColor(red: 155.0/255.0, green: 229.0/255.0, blue: 180.0/255.0, alpha: 1.0).CGColor
        guanXiBtn.layer.borderWidth = 1.0
        guanXiBtn.layer.borderColor = UIColor(red: 155.0/255.0, green: 229.0/255.0, blue: 180.0/255.0, alpha: 1.0).CGColor
        phoneBtn.layer.borderWidth = 1.0
        phoneBtn.layer.borderColor = UIColor(red: 155.0/255.0, green: 229.0/255.0, blue: 180.0/255.0, alpha: 1.0).CGColor
        avatorBtn.addTarget(self, action: Selector("UpdatePicture"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func UpdatePicture(){
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) {
            (UIAlertAction) -> Void in
            //                navigationController?.popViewControllerAnimated(true)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let GoCameraAl = UIAlertAction(title: "相机", style: UIAlertActionStyle.Default) {
            (UIAlertAction) -> Void in
            self.GoCamera()
        }
        let GoImageAl = UIAlertAction(title: "图库", style: UIAlertActionStyle.Default) {
            (UIAlertAction) -> Void in
            self.GoImage()
        }
        
        
        actionSheet = UIAlertController(title: "选择图片", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(GoCameraAl)
        actionSheet.addAction(GoImageAl)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    //相机
    func GoCamera(){
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        //picker.delegate = self
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
        
    }
    //相册
    func GoImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.presentViewController(pickerImage, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        print("choose--------->>")
        print(info)
        
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        if(img.size.width>200 || img.size.height>200)
        {
            data = UIImageJPEGRepresentation(img, 0.1)!
        }
        else
        {
            data = UIImageJPEGRepresentation(img, 0.3)!
        }
        if (data.length>104850)
        {
            self.hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            self.hud.mode = MBProgressHUDMode.Text
            self.hud.margin = 10
            self.hud.removeFromSuperViewOnHide = true
            self.hud.labelText = "图片大于1M，请重新选择"
            self.hud.hide(true, afterDelay: 1)
            return
            
        }
        
        avatorImage.image = img
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    //取消之后
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    
    @IBAction func saveBtnAction(sender: AnyObject) {
        print("你点击了保存按钮")
    }


    // MARK: - Table view data source

    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
