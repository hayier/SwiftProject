//
//  ProductViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/30.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProductViewController: UIViewController {

    let scrollView:UIScrollView = {
        let t = UIScrollView()
        t.backgroundColor = .white
        return t
    }()
 
    let bottomView = UIView()
    let cartBtn = UIButton()
    let buyBtn = UIButton()
    
    let standardsVC = ProductStandardsViewController()
    
    var attrArr:[ProductAttrGroupItem]?
    var valueArr:[ProductAttrValueItem]?
    var product:Product?{
        didSet{
               fillProductView()
        }
    }
    var productCnt:Int = 0
    
    var detailImgs:[String] = [String]()
    
    var productId:Int?{
        didSet{
           
        }
    }
    
    var header:ProductDetailHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "产品详情"
        
        view.backgroundColor = .white
        
        layoutViews()
        
        addChild(standardsVC)
        view.addSubview(standardsVC.view)
        standardsVC.view.frame = view.bounds
        view.layoutIfNeeded()
        standardsVC.view.isHidden = true
        
        cartBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        buyBtn.addTarget(self, action: #selector(btnAction(btn:)), for: .touchUpInside)
        
        standardsVC.contentV.sureBtn.addTarget(self, action: #selector(sureAction(sender:)), for: .touchUpInside)
        
        getData()
    }
    
    func layoutViews(){
        
        view.addSubview(scrollView)
        view.addSubview(bottomView)
        bottomView.addSubview(cartBtn)
        bottomView.addSubview(buyBtn)
        
        cartBtn.setTitle("加入购物车", for: .normal)
        cartBtn.setTitleColor(.blue, for: .normal)
        cartBtn.layer.borderWidth = 1
        cartBtn.layer.borderColor = UIColor.blue.cgColor
        
        buyBtn.backgroundColor = .blue
        buyBtn.setTitle("立即购买", for: .normal)
        
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        scrollView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(bottomView.snp.top)
            $0.top.equalTo(0)
        }
        
        bottomView.snp.makeConstraints{
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        let iwidth = (view.frame.size.width - 100)*0.5
        
        cartBtn.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.width.equalTo(iwidth)
            $0.right.equalTo(buyBtn.snp.left).offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        buyBtn.snp.makeConstraints{
            $0.right.equalTo(-20)
            $0.height.equalTo(40)
            $0.width.equalTo(iwidth)
            $0.centerY.equalToSuperview()
        }
    }
    
    func fillProductView(){
        
        guard let model = product else {
            return
        }
        let str = model.ProductName
        let header = ProductDetailHeaderView(frame:view.bounds)
        header.title = str ?? ""
        header.serverImages = [model.ProductImg.imgRequestString!]
        header.priceLab.text = "￥\(model.Price)"
        header.expressLab.text = "￥\(model.Freight)"
        
        //需要计算高度来设置header高度
        let width = view.frame.size.width
        let height = view.frame.size.width + header.titleHeight + 85
        header.frame = CGRect(x: 0, y: 0, width:width, height:height)
        self.header = header
        scrollView.addSubview(header)
        
        let webView = UIWebView()
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        scrollView.addSubview(webView)
        guard let html = product?.ImgTxtContent.removingPercentEncoding else {
            return
        }
        
        guard let range = html.range(of: "http://localhost:49710") else{return}
        let htmlStr = html.replacingCharacters(in: range, with: "http://xxx.xxx.xxx")
        webView.loadHTMLString(htmlStr, baseURL: nil)
        webViewDidFinishLoad(webView)
    }
    
    @objc func btnAction(btn:UIButton){
        
        standardsVC.view.isHidden = false
        standardsVC.showView()
        standardsVC.completion = {[unowned self] (b) in
            self.standardsVC.view.isHidden = true
        }
        if btn == cartBtn{
            standardsVC.contentV.sureBtn.setTitle("加入购物车", for: .normal)
            standardsVC.completion = {[unowned self] (b) in
                self.standardsVC.view.isHidden = true
            }
        }else if btn == buyBtn{
            standardsVC.contentV.sureBtn.setTitle("立即购买", for: .normal)
        }
    }
    
    @objc func sureAction(sender:UIButton){
        standardsVC.dismissView()
        guard let title = sender.currentTitle else{ return }
        if title == "加入购物车"{
            addToCart()
        }else{
            let vc = OrderConfirmViewController()
            show(vc, sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
}

extension ProductViewController:UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //获取页面高度（像素）
        let clientheight_str = webView.stringByEvaluatingJavaScript(from: "document.body.clientHeight")
        guard let h = clientheight_str else {
            return
        }
        let floatHeight = CGFloat(Float(h)!)
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: floatHeight)
        //获取WebView最佳尺寸（点）
        let size = webView.sizeThatFits(webView.frame.size)
 
        //获取内容实际高度（像素）
        guard let height_str = webView.stringByEvaluatingJavaScript(from: "document.getElementById('webview_content_wrapper').clientHeight + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-top'))  + parseInt(window.getComputedStyle(document.getElementsByTagName('body')[0]).getPropertyValue('margin-bottom'))") else{return}
        guard let height = Float(height_str) else{return}
        //内容实际高度（像素）* 点和像素的比
        let oheight = CGFloat(height) * size.height / floatHeight;
        //再次设置WebView高度（点）
        webView.frame = CGRect(x: 0, y: header.frame.height, width: self.view.frame.width, height: oheight)

        print(header)
    }
    
}

extension ProductViewController {
    
    func getData(){
        guard let Id = productId else {
            return
        }
        
        Alamofire.request(API.GetGoodsDetail(id:Id).url,parameters: API.GetGoodsDetail(id:Id).params)
            .responseJSON { (response) in
                switch(response.result){
                case .success(let value):
                    let json = JSON(value)
                    let commomModel = CommonModel.deserialize(from: json.rawString())
                    if commomModel?._success ?? false{
                        
                        let pmodel = ProductDetailData.deserialize(from:json["_data"].rawString())
                        self.attrArr = pmodel?.productAttrGroup
                        self.valueArr = pmodel?.productAttrValue
                        self.product = pmodel?.product
                        self.productCnt = pmodel?.cnt ?? 0
                        
                        self.standardsVC.attrArr = self.attrArr
                        self.standardsVC.valueArr = self.valueArr
                        self.standardsVC.product = self.product
                        
                    }
                case .failure(_):
                    print("requet error")
                }
        }
    }
    
    func addToCart(){
        
        guard let key = UserHelper.UserKey.getValue else {
            //未登录
            UserHelper.showLogin()
            return
        }
        guard let value = standardsVC.selectedValue else {
            self.view.makeToast("未选择规格", duration: 1.0, position: nil)
            return
        }
        
        guard let cnt = Int(standardsVC.contentV.tf.text ?? "1") else { return }
        
        let api = API.AddToCart(key: key, ProductID: value.ProductID, GetCnt: cnt, GroupID: value.GroupID)
        
        Alamofire.request(api.url,parameters: api.params)
            .responseJSON { (response) in
                switch(response.result){
                case .success(let value):
                    let json = JSON(value)
                    let commomModel = CommonModel.deserialize(from: json.rawString())
                    if commomModel?._success ?? false{
                        self.view.makeToast(commomModel?._message, duration: 1.0, position: nil)
                    }
                case .failure(_):
                    print("requet error")
                }
        }
        
    }
    
}
