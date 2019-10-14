//
//  AddAdsViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class AddAdsViewController: UIViewController {

    let kidVC = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "AddAdsTableViewController") as! AddAdsTableViewController
    
    var mail:Address?
    
    lazy var cities:[Province] = {
        return AddressModel.getCitys()
    }()
    
    var success:(()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .HBackGray
        
        addChild(kidVC)
        view.addSubview(kidVC.view)
        
        if let m = mail{
            title = "修改地址"
            kidVC.nameTf.text = m.ContactName
            kidVC.phoneTf.text = m.ContactMobile
            
            let name = AddressModel.getCitiesName(pID: m.ProvinceID,cID: m.CityID,tID: m.AreaID)
            
            kidVC.addressLab.text = String(format: "%@ %@ %@", name.p,name.c,name.t)
            kidVC.addressTV.text = m.Address
            kidVC.addressIds = (m.ProvinceID,m.CityID,m.AreaID)
            
        }else{
            title = "添加地址"
        }

        kidVC.mail = mail
        
        kidVC.tableView.separatorColor = UIColor.HBackGray
       
        kidVC.view.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.bottom.equalTo(-100)
        }
        
        let btn = UIButton()
        btn.setTitle("确认", for: .normal)
        btn.backgroundColor = .HBlue
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(sure), for: .touchUpInside)
        
        btn.snp.makeConstraints{
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
            $0.bottom.equalTo(-30)
            $0.height.equalTo(45)
        }
    }
    
    @objc func sure(){
        var api:API
        if kidVC.nameTf.text?.count == 0 {
            self.view.toast(message: "请输入联系人")
            return
        }
        if let phone = kidVC.phoneTf.text,
            !phone.validatePhone() {
            self.view.toast(message: "请输入联系电话")
            return
        }
        
        guard let ids = kidVC.addressIds else{
            self.view.toast(message: "请选择地区")
            return
        }
        
        if kidVC.addressTV.text?.count == 0 {
            self.view.toast(message: "请填写详细地址")
            return
        }
        
        let pID = "\(ids.p)"
        let cID = "\(ids.c)"
        let tID = "\(ids.a)"
        
        if mail == nil {
            api  = API.UserMailAddorEdit(key: UserHelper.UserKey.getValue!, id: 0, ContactName: kidVC.nameTf.text!, ContactMobile: kidVC.phoneTf.text!, ProvinceID: pID,CityID: cID,AreaID: tID, Address: kidVC.addressTV.text!, type: .add)
        }else {
            api  = API.UserMailAddorEdit(key: UserHelper.UserKey.getValue!, id: mail!.ID, ContactName: kidVC.nameTf.text!, ContactMobile: kidVC.phoneTf.text!, ProvinceID: pID,CityID: cID,AreaID: tID,  Address: kidVC.addressTV.text!, type: .edit)
        }
        
        HRequest.getData(api: api) { data in
            self.view.toast(message: "成功")
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                
                if self.success != nil {
                    self.success!()
                }
                
                self.navigationController?.popViewController(animated: true)
            })
            
        }
        
    }

}

class AddAdsTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var addressLab: UILabel!
    
    @IBOutlet weak var addressTV: IQTextView!
    
    lazy var vc = CitiesSelectViewController()
    
    var mail:Address?
    
    var addressIds:(p:Int,c:Int,a:Int)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = .HBackGray
        
        vc.selected = {[unowned self] (p,c,t) in
            let str = self.vc.cities[p].name + " " + self.vc.cities[p].child[c].name + " "
            self.addressLab.textColor = .HTextBlack
            guard let town = self.vc.cities[p].child[c].child else {
                self.addressLab.text = str
                self.addressIds = (self.vc.cities[p].id,self.vc.cities[p].child[c].id,0)
                return
            }
            self.addressLab.text = str + town[t].name
            self.addressIds = (self.vc.cities[p].id,self.vc.cities[p].child[c].id,town[t].id)
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.selectionStyle = .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            vc.mail = self.mail
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension AddAdsTableViewController:UIViewControllerTransitioningDelegate {
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let present = PresentationController(presentedViewController: presented, presenting: presenting)
        return present
    }
}
