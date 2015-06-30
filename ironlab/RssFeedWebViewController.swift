//
//  RssFeedWebViewController.swift
//  IronLab
//
//  Created by ghassane rihani on 05/06/2015.
//  Copyright (c) 2015 CSC CSC. All rights reserved.
//

import UIKit

class RssFeedWebViewController: UIViewController {
    
    var url: NSURL!
    @IBOutlet weak var rssFeedWebView: UIWebView! {
        didSet {
            rssFeedWebView.delegate = self
        }
    }
    
    var loadingIndicator = LoadingIndicator(frame: CGRectMake(25, 130, 270, 100))
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestObj = NSURLRequest(URL: url!)
        self.rssFeedWebView.loadRequest(requestObj)
        self.rssFeedWebView.delegate = self
        loadingIndicator.hidden = true
        self.rssFeedWebView.addSubview(loadingIndicator)
        self.rssFeedWebView.reload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func dismissWebView(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension RssFeedWebViewController: UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.loadingIndicator.show("Loading")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingIndicator.hide()
    }
}