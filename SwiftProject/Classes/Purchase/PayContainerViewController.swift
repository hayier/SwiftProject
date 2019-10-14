//
//  PayContainerViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/18.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PayContainerViewController: UIViewController {

    
    let backView:UIView = {
        let t = UIView()
        t.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return t
    }()
    
    let payContentView = UIView()
    
    let payViewController = PayViewController()
    
    var payFinishedDismiss:((_ orderNo:String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutViews()
        
        let nav = UINavigationController(rootViewController: payViewController)
        nav.navigationBar.isHidden = true
        self.addChild(nav)
        payContentView.addSubview(nav.view)
        
        nav.view.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        backView.addGestureRecognizer(tap)
        
        payViewController.completion = {[unowned self] (b) in
            self.dismiss(animated: false, completion: nil)
        }
        
        UIView.show(message: "")
        //假如不延迟  布局还没有完成  动画效果无法执行
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.getData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(payFinished(noti:)), name: NSNotification.Name("com.tongcheng.payFinished"), object: nil)
        
    }

    func layoutViews(){
        view.addSubview(backView)
        
        view.addSubview(payContentView)
        
        backView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        //固定height
        let height = UIScreen.main.bounds.size.height * 0.6
        payContentView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(height)
        }
    }
    
    @objc func dismissView(){
        payViewController.dismissView()
    }
    
    @objc func payFinished(noti:Notification){
        if let orderNo = noti.object as? String{
            if let f = payFinishedDismiss{
                f(orderNo)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension PayContainerViewController{
    
    func getData(){
        
        let api = API.GetUser(key: UserHelper.UserKey.getValue!)
        
        Alamofire.request(api.url, method: .get, parameters: api.params).responseJSON { (response) in
            switch response.result{
            case .success(let value):
                let json = JSON(value)
                let commomModel = CommonModel.deserialize(from: json.rawString())
                if commomModel?._success ?? false{
                    let data = json["_data"]
                    
                    UIView.dismiss(delay: 0, completion: {
                        
                    })
                    let model = UserModel.deserialize(from: data["C_User"].rawString())
                    self.payViewController.showView()
                    self.payViewController.model = model
                    
                }else{
                    
                    if let message = commomModel?._message {
                        UIView.show(message: message)
                    }
                    UIView.dismiss(delay: 2, completion: {
                        self.parent?.dismiss(animated: false, completion: nil)
                    })
                    
                }
            case .failure(let e):
                print(e)
                
            }
        }

    }
    
}
