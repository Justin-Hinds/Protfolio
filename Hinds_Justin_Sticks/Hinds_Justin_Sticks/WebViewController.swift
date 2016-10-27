//
//  WebViewController.swift
//  Hinds_Justin_Sticks
//
//  Created by Justin Hinds on 8/16/16.
//  Copyright © 2016 Justin Hinds. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    let postWebView: UIWebView = {
        let webview = UIWebView()
        var  postURL = URL(string: "http://apple.com")
        let urlstring = "http://apple.com"
        let request = URLRequest(url: postURL!)
        webview.loadRequest(request)
        webview.translatesAutoresizingMaskIntoConstraints = false
        return webview
    }()
    
    override func viewDidLoad() {
        setUpWebView()
    }
    func setUpWebView() {
        view.addSubview(postWebView)
        postWebView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        postWebView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        postWebView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        postWebView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
