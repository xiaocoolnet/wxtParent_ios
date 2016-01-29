//
//  ViewController.swift
//  Timeline
//
//  Created by Evan Dekhayser on 7/26/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit
import ImageSlideshow

class GrowingDiaryMainViewController: UIViewController {
	
    @IBOutlet weak var SelectItem: UISegmentedControl!
    
    
    @IBOutlet var content: UIView!
    enum TabIndex : Int {
        case FirstChildTab = 0
        case SecondChildTab = 1
    }
    var currentViewController: UIViewController?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("MyViewControllerId")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewControllerWithIdentifier("FriendsViewControllerId")
        return secondChildTabVC
    }()


	override func viewDidLoad() {
        super.viewDidLoad()
        SelectItem.selectedSegmentIndex = TabIndex.FirstChildTab.rawValue
        displayCurrentTab(0)
    }
    
    func displayCurrentTab(tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMoveToParentViewController(self)
            
            vc.view.frame = self.content.bounds
            self.content.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    func viewControllerForSelectedSegmentIndex(index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.FirstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.SecondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }

    
    @IBAction func switchTabs(sender: AnyObject) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    
    
}

