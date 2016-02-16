//
//  ServerTableViewController.swift
//  WXT_Parents
//
//  Created by 李春波 on 16/2/16.
//  Copyright © 2016年 北京校酷网络科技有限公司. All rights reserved.
//


import UIKit

class ServerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "客服"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let forFooterView = UIView(frame: CGRectMake(0, self.view.frame.size.width-49, self.view.frame.size.height, 49))
        let footerBt = UIButton(frame: CGRectMake(0, 0, self.view.frame.size.width, 49))
        forFooterView.addSubview(footerBt)
        
        footerBt.setTitle("拨打电话", forState: UIControlState.Normal)
        footerBt.backgroundColor = UIColor(red: 155.0/255.0, green: 229.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        footerBt.addTarget(self, action:Selector("call:"), forControlEvents: UIControlEvents.TouchUpInside)
        return forFooterView
    }
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 49
    }
    func call(sender:UIButton){
        let url1 = NSURL(string: "tel://4009660095")
        UIApplication.sharedApplication().openURL(url1!)
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
