//
//  UserSettingViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/5.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import Alamofire
import Photos

class UserSettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


class UserSettingTableViewController: UITableViewController{
    
    @IBOutlet weak var headerImgV: UIImageView!
    
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var phoneLab: UILabel!
    
    @IBOutlet weak var changeImgBtn: UIButton!
    var model:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "账户设置"
        
        guard let m = model else{
            return
        }
        if let purl = URL(string:m.PortraitUrl) {
            headerImgV.kf.setImage(with:purl, placeholder:UIImage(named: "account_avatar"))
        }else{
            headerImgV.image = UIImage(named: "account_avatar")
        }
        headerImgV.layer.cornerRadius = 47.5
        headerImgV.layer.masksToBounds = true
        
        nameLab.text = m.Name
        phoneLab.text = m.Phone
        self.changeImgBtn.isHidden = true
    }
    
    @IBAction func changeHeaderImg(_ sender: Any) {
        
        //MARK: APP启动时候，判断用户是否授权使用相册
        PHPhotoLibrary.requestAuthorization({ (firstStatus) in
            let result = (firstStatus == .authorized)
            if result {
                
                let picker:UIImagePickerController = UIImagePickerController()
                picker.delegate = self
                picker.sourceType = .photoLibrary
                picker.allowsEditing = true
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    self.present(picker, animated: true, completion:nil)
                }
                
            } else {
                self.view.toast(message: "没有打开相册权限，请到设置中打开")
            }
        })
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 4 {
            
        }
        
    }
    
    

    
}

extension UserSettingTableViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var str = ""
        if #available(iOS 11.0, *) {
            if let s = info[.imageURL] as? URL {
                str = s.absoluteString
            }
        } else {
            if let s = info[.referenceURL] as? URL {
                str = s.absoluteString
            }
        }
        
        picker.dismiss(animated: true) {
//            let api = API.WxChangeHeadImg(key: UserHelper.UserKey.getValue!, imgurl: str)
//            Alamofire.request(api.url, method: .post, parameters: api.params).responseJSON { (json) in
//                print(json)
//            }
        }
        
    }
    
}
