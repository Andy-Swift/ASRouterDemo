//
//  ViewController.swift
//  ASRouterDemo
//
//  Created by Think on 16/04/2018.
//  Copyright © 2018 Think. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        var tb = UITableView.init(frame: self.view.bounds)
        tb.delegate = self
        tb.dataSource = self
        tb.register(type(of: UITableViewCell()), forCellReuseIdentifier: "cell")
        return tb
    }()
    
    let dataArr = ["push to vc", "call block"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Home"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        // register route
        ASRouter.shared.map(route: "/user/:userId/", toControllerClass: SecondVC.self)
        
        let block: ([String: Any]) -> () = { params in
            print("hello \(params["name"]!)")
        }
        ASRouter.shared.map(route: "/hello/:name/", toBlock: block)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *  self code
     */
    
    func test() {
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = dataArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = dataArr[indexPath.row]
        print("Index: \(indexPath.row) Name: \(title)")
        switch indexPath.row {
        case 0:
            let vc = ASRouter.shared.matchController("hhrouter2://user/2/")
            if vc != nil {
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        default:
            if ASRouter.shared.routeType(route: "/hello/:name/") == .block {
                ASRouter.shared.callBlock(route: "/hello/Think/")
            }
            break
        }
    }
}

