//
//  DetailedViewController.swift
//  Theater
//
//  Created by Tarang khanna on 1/16/16.
//  Copyright © 2016 Tarang khanna. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var descriptionPassed:String = ""
    var titlePassed:String? = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        descriptionLabel.text = descriptionPassed
        titleLabel.text = titlePassed
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
