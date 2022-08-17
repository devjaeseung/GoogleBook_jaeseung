//
//  WebViewController.swift
//  GoogleBook_jaeseung
//
//  Created by jaeseung lim on 2022/08/18.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    private let infoLink: String
    
    private let webView = WKWebView()
    
    init(infoLink: String) {
        self.infoLink = infoLink
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        setupWebView()
    }
    

    func setupWebView() {
        guard let linkURL = URL(string: infoLink) else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        view = webView
        
        let urlRequest = URLRequest(url: linkURL)
        webView.load(urlRequest)
    }

}
