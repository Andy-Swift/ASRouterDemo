//
//  SecondVC.swift
//  ASRouterDemo
//
//  Created by Think on 17/04/2018.
//  Copyright © 2018 Think. All rights reserved.
//

import UIKit

class SecondVC: UIViewController, ASRouterProtocol {
    
    var params: [String : Any]?
    let flag = "second vc"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.white
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
    
    deinit {
        print("second vc deinit ...")
    }

}

