//
//  ASrouter.swift
//  ASRouterDemo
//
//  Created by Think on 16/04/2018.
//  Copyright © 2018 Think. All rights reserved.
//

import UIKit


final class ASRouter {
    private var routes = [String: Any]()
    
    static let shared = ASRouter()
    private init() { }
    
    /* public method */
    
    typealias routeBlock = ([String: Any]) -> ()
    
    enum ASRouterType {
        case none
        case controller
        case block
    }
    
    /// map route string to controller class
    ///
    /// - Parameters:
    ///   - route: route string
    ///   - controllerClass: controller class
    func map(route: String, toControllerClass controllerClass: UIViewController.Type) {
        self.buildRoutes(route: route, value: controllerClass)
    }
    
    
    /// match controller with route string
    ///
    /// - Parameter route: route string
    /// - Returns: controller to be routed
    func matchController(_ route: String) -> UIViewController? {
        guard let params = self.params(inRoute: route) else {
            return nil
        }
        
        guard let controllerClass = params["controller_class"], let clsType = controllerClass as? UIViewController.Type else {
            return nil
        }
        
        let vc = clsType.init()
        guard var routerVC = vc as? ASRouterProtocol else {
            assert(false, "No implementation ASRouterProtocol ...")
            return vc
        }
        
        routerVC.params = params
        return routerVC as? UIViewController
    }
    
    
    /// map route string to block
    ///
    /// - Parameters:
    ///   - route: route string
    ///   - block: block to be routed
    func map<T>(route: String, toBlock block: T) {
        self.buildRoutes(route: route, value: block)
    }
    
    
    /// call block with route
    ///
    /// - Parameter route: route string
    func callBlock(route: String) {
        guard let param = self.params(inRoute: route), let block = param["block"] as? routeBlock else {
            return
        }
        block(param)
    }
    
    
    /// get route type
    ///
    /// - Parameter route: route string
    /// - Returns: route type
    func routeType(route: String) -> ASRouterType {
        guard let params = self.params(inRoute: route) else {
            return .none
        }
        
        if params["controller_class"] != nil {
            return .controller
        }
        if params["block"] != nil {
            return .block
        }
        return .none
    }
    
    /* private method */
    
    func buildRoutes(route: String, value: Any) {
        let pathComponents = self.pathComponents(fromRoute: route)
        let count = pathComponents.count
        guard count > 0  else { return }
        
        let typeValue = ["_" : value]
        
        var val = (count == 1) ? typeValue : [String: Any]()
        var index = count - 1
        while index > 0 {
            let tempKey = pathComponents[index]
            if (index == count - 1) {
                val = [tempKey : typeValue]
            } else {
                val = [tempKey : val]
            }
            
            index -= 1
        }
        
        routes[pathComponents.first!] = val
    }
    
    private func pathComponents(fromRoute route: String) -> Array<String> {
        var pathComponents = [String]()
        let url: URL = URL.init(string: route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        for pathComponent in url.pathComponents {
            if pathComponent == "/" { continue }
            if pathComponent.first == "?" { break }
            pathComponents.append(pathComponent.removingPercentEncoding!)
        }
        return pathComponents
    }
    
    private func appUrlSchemes() -> Array<String> {
        var urlSchemes = [String]()
        
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return urlSchemes
        }
        
        guard let typeArr = infoDictionary["CFBundleURLTypes"] as? Array<Any> else {
            return urlSchemes
        }

        for type in typeArr {
            guard let schemes = type as? Dictionary<String, Any> else {
                return urlSchemes
            }
            let schemeArr = schemes["CFBundleURLSchemes"] as? Array<String>
            if let scheme = schemeArr?.first! {
                urlSchemes.append(scheme)
            }
        }
        return urlSchemes
    }
    
    private func filterAppUrlScheme(_ string: String) -> String {
        // filter out the app URL compontents.
        let urlSchemeArr = appUrlSchemes()
        
        for urlScheme in urlSchemeArr {
            if string.hasPrefix("\(urlScheme):") {
                //MARK: did not finish
                //FIXME: not finish
                
                let index = string.index(string.startIndex, offsetBy: (urlScheme.count + 2))
                return String(string[index..<string.endIndex])
            }
        }
        return string
    }
    
    private func params(inRoute route: String) -> Dictionary<String, Any>? {
        var params = Dictionary<String, Any>()
        params["route"] = filterAppUrlScheme(route)
        var subRoutes = routes
        
        let pathComponents = self.pathComponents(fromRoute: params["route"] as! String)
        for pathComponent in pathComponents {
            var found = false
            let subRoutesKeys = subRoutes.keys
            for key in subRoutesKeys {
                if subRoutesKeys.contains(pathComponent) {
                    found = true
                    subRoutes = subRoutes[pathComponent] as! [String : Any]
                    break
                }
                else if key.hasPrefix(":") {
                    found = true
                    subRoutes = subRoutes[key] as! [String : Any]
                    let index = key.index(key.startIndex, offsetBy: 1)
                    let tempKey = String(key[index..<key.endIndex])
                    params[tempKey] = pathComponent
                    break
                }
            }
            if found == false {
                return nil
            }
        }
        
        // Extract Params From Query.
        if let index = route.index(of: "?") {
            let start = route.index(index, offsetBy: 1)
            let paramsString = route[start...]
            let paramsStringArr = paramsString.components(separatedBy: "&")
            for tempParam in paramsStringArr {
                let paramArr = tempParam.components(separatedBy: "=")
                if paramArr.count > 1 {
                    let key = paramArr[0], value = paramArr[1]
                    params[key] = value
                }
            }
        }
        
        guard let cla = subRoutes["_"] else {
            return nil
        }
        
        if cla is UIViewController.Type {
            params["controller_class"] = subRoutes["_"]
        } else {
            params["block"] = subRoutes["_"]
        }
        
        return params
    }
}

protocol ASRouterProtocol {
    var params: [String: Any]? { get set }
}


