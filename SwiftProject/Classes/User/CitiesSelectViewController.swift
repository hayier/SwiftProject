//
//  CitiesSelectViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/4.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class CitiesSelectViewController:UIViewController {
    
    lazy var toolbar:UIToolbar = {
        let tool = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        let cItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel))
        let fItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let sItem = UIBarButtonItem(title: "确定", style: .plain, target: self, action: #selector(sureSelect))
        tool.items = [cItem,fItem,sItem]
        return tool
    }()
    
    lazy var picker:UIPickerView = {
        let p = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        p.showsSelectionIndicator = true
        return p
    }()
    
    lazy var cities:[Province] = {
        return AddressModel.getCitys()
    }()
    
    var mail:Address?
    
    var selected:((Int,Int,Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        picker.delegate = self
        picker.dataSource = self
        
        layoutViews()
       
        picker.selectRow(0, inComponent: 0, animated: true)
        
    }
    
    func layoutViews(){
        
        view.addSubview(toolbar)
        view.addSubview(picker)
        
        
        toolbar.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        picker.snp.makeConstraints{
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
            
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240)
        }
        
    }

    @objc func cancel(){
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
    @objc func sureSelect(){
        
        let p = picker.selectedRow(inComponent: 0)
        let c = picker.selectedRow(inComponent: 1)
        let t = picker.selectedRow(inComponent: 2)
        
        if selected != nil {
            selected!(p,c,t)
        }
        
        self.dismiss(animated: true, completion: nil)
    
    }
    
}

extension CitiesSelectViewController:UIPickerViewDelegate{
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.picker.selectRow(0, inComponent: 1, animated: true)
            self.picker.selectRow(0, inComponent: 2, animated: true)
            self.picker.reloadAllComponents()
        case 1:
            self.picker.selectRow(0, inComponent: 2, animated: true)
            self.picker.reloadAllComponents()
        default:
            print(self.pickerView(pickerView, titleForRow: row, forComponent: component) ?? "nil")
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return cities[row].name
        case 1:
            let idx = picker.selectedRow(inComponent: 0)
            return cities[idx].child[row].name
        case 2:
            let idx0 = picker.selectedRow(inComponent: 0)
            let idx1 = picker.selectedRow(inComponent: 1)
            guard let town = cities[idx0].child[idx1].child else {
                return nil
            }
            if row >= town.count{
                return nil
            }else{
                return town[row].name
            }
            
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
       
        var lab = view as? UILabel
        
        if lab == nil {
            lab = UILabel()
            lab!.textColor = .black
            lab!.font = UIFont.systemFont(ofSize: 18)
            lab!.textAlignment = .center
            lab?.adjustsFontSizeToFitWidth = true
            lab?.minimumScaleFactor = 0.8
        }
        
        lab!.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        return lab!
    }
}

extension CitiesSelectViewController:UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return cities.count
        case 1:
            let idx = picker.selectedRow(inComponent: 0)
            return cities[idx].child.count
        case 2:
            let idx0 = picker.selectedRow(inComponent: 0)
            let idx1 = picker.selectedRow(inComponent: 1)
            guard let town = cities[idx0].child[idx1].child else {
                return 0
            }
            return town.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    

}


class PresentationController:UIPresentationController{
    
    //重写初始化方法：
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController:presentedViewController,presenting: presentingViewController)
    }
    //在大多数时候，我们希望底部弹出框出现时，先前的显示区域能够灰暗一些，来强调弹出框的显示区域是用户当前操作的首要区域。因此，我们给这个自定义的类添加一个遮罩：
    
    lazy var blackView: UIView = {
        let view = UIView()
        if let frame = self.containerView?.bounds {
            view.frame = frame
        }
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    //重写presentationTransitionWillBegin、dismissalTransitionWillBegin和dismissalTransitionDidEnd(_ completed: Bool)方法。在弹窗即将出现时把遮罩添加到containerView，并通过动画将遮罩的alpha设置为1；在弹窗即将消失时通过动画将遮罩的alpha设置为0；在弹框消失之后将遮罩从containerView上移除：
    
    override func presentationTransitionWillBegin() {
        blackView.alpha = 0
        containerView?.addSubview(blackView)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
        }
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            blackView.removeFromSuperview()
        }
    }
    
    //接下来，我们重写frameOfPresentedViewInContainerView这个属性。它决定了弹出框在屏幕中的位置，由于我们是底部弹出框，我们设定一个弹出框的高度controllerHeight，即可得出弹出框的frame：
    
    let controllerHeight:CGFloat = 240 + 44 + UIApplication.shared.statusBarFrame.height
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(x: 0, y: UIScreen.main.bounds.height-controllerHeight, width: UIScreen.main.bounds.width, height: controllerHeight)
    }
    
}
