//
//  WebViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/26.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var path:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let p = path else {
            return
        }
        
        let web = UIWebView()
        let request = URLRequest(url: p)
        web.loadRequest(request)
        
        view.addSubview(web)
        
        web.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
            } else {
                $0.edges.equalToSuperview()
            }
        }
    }
    

    

}
