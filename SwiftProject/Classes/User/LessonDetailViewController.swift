//
//  LessonDetailViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/6/1.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit
import BMPlayer
import Alamofire
import SVProgressHUD
import Photos
import SafariServices
import MonkeyKing
import Kingfisher

class LessonDetailViewController: UIViewController {
    
    var data:VideoModel?

    var controlView:PlayerControlView!
    
    var player:BMPlayer!
    
    var titleView:VideoDetailView?
    
    var isfullScreen:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
    
        controlView = PlayerControlView()
        
        controlView.backButton.isHidden = true
        
        player = BMPlayer(customControlView: controlView)
        
        // options to show header view (which include the back button, title and definition change button) , default .Always，options: .Always, .HorizantalOnly and .None
        BMPlayerConf.topBarShowInCase = .always
        // loader type, see detail：https://github.com/ninjaprox/NVActivityIndicatorView
        BMPlayerConf.loaderType  = .ballRotateChase
        // enable setting the brightness by touch gesture in the player
        BMPlayerConf.enableBrightnessGestures = true
        // enable setting the volume by touch gesture in the player
        BMPlayerConf.enableVolumeGestures = true
        // enable setting the playtime by touch gesture in the player
        BMPlayerConf.enablePlaytimeGestures = true
        
        
        let detailView = Bundle.main.loadNibNamed("VideoDetailView", owner: self, options: nil)?.first as! VideoDetailView
        titleView = detailView
        
        layoutViews()
        
        guard let m = data else {
            return
        }
        
        let asset = BMPlayerResource(url: m.VideoUrl.imgRequestUrl!)
        player.setVideo(resource: asset)
        
        
        titleView?.titleLab.text = m.Title
        if m.Price == 0 {
            titleView?.priceLab.text = "免费"
        }else{
            titleView?.priceLab.text = String(format: "￥%.2f", m.Price)
        }
        titleView?.numLab.text = "播放量: " + "\(m.PlayCount)"
        
        titleView?.downBtn.addTarget(self, action: #selector(saveVideo), for: .touchUpInside)
        titleView?.shareBtn.addTarget(self, action: #selector(shareVideo), for: .touchUpInside)
        
        title = m.Title
        
        titleView?.fileNameLab.text = m.PPTName
        titleView?.xclFileName.text = m.FileName
        
        if m.PPTUrl.count < 10 {
            titleView?.pptBtn.superview?.isHidden = true
        }
        
        if m.FileUrl.count < 10 {
            titleView?.xclBtn.superview?.isHidden = true
        }
      
        titleView?.xclBtn.addTarget(self, action: #selector(openFile(btn:)), for: .touchUpInside)
        titleView?.pptBtn.addTarget(self, action: #selector(openFile(btn:)), for: .touchUpInside)
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreen), name: NSNotification.Name("Player.FullScreen.Notification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(fullScreen), name: NSNotification.Name("Player.Back.Notification"), object: nil)
    }
    
    func layoutViews(){
        
        view.addSubview(player)
        
        view.addSubview(titleView!)
        
        player.snp.makeConstraints {
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.left.right.equalToSuperview()
            $0.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
        }
        
        titleView!.snp.makeConstraints{
            $0.top.equalTo(player.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(150)
        }
        
    }
    
    @objc func fullScreen(){

        if !isfullScreen {
            
            isfullScreen = true
            
            controlView.fullscreenButton.isSelected = true
            
            navigationController?.setNavigationBarHidden(true, animated: true)
            
            controlView.backButton.isHidden = false
            
            titleView?.isHidden = true
            
            player.snp.remakeConstraints{
                $0.center.equalToSuperview()
                $0.size.equalTo(CGSize(width: self.view.frame.height, height: self.view.frame.width))
            }
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            UIView.animate(withDuration: 0.35) {
                self.view.layoutIfNeeded()
                self.player.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            }
            
        }else{
            
            isfullScreen = false
            
            controlView.fullscreenButton.isSelected = false
            
            navigationController?.setNavigationBarHidden(false, animated: true)
            
            controlView.backButton.isHidden = true
            
            self.setNeedsStatusBarAppearanceUpdate()
            
            player.snp.remakeConstraints{
                if #available(iOS 11.0, *) {
                    $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                } else {
                    $0.top.equalTo(self.topLayoutGuide.snp.bottom)
                }
                $0.left.right.equalToSuperview()
                $0.height.equalTo(player.snp.width).multipliedBy(9.0/16.0).priority(750)
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.view.layoutIfNeeded()
                self.player.transform = .identity
            }) { (completion) in
                self.titleView?.isHidden = false
            }
            
        }
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return isfullScreen
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    deinit {
        player.prepareToDealloc()
        NotificationCenter.default.removeObserver(self)
    }
}

extension LessonDetailViewController{
    
    @objc func shareVideo(){
        
        guard let m = data else {
            return
        }
        
        let sheet = UIAlertController(title: "分享", message: "把好东西分享给您的好友吧", preferredStyle: .actionSheet)
        
        let ac1 = UIAlertAction(title: "微信好友", style: .default) { (ac) in
            ImageDownloader.default.downloadImage(with: m.ImgUrl.imgRequestUrl!) { (image, error, url, data) in
                let info = MonkeyKing.Info(title: m.Title, description: m.Details, thumbnail: image, media: .video(m.VideoUrl.imgRequestUrl!))
                let message = MonkeyKing.Message.weChat(.session(info: info))
                
                MonkeyKing.deliver(message) { (result) in
                    
                }
            }
        }
        
        let ac2 = UIAlertAction(title: "微信朋友圈", style: .default) { (ac) in
            ImageDownloader.default.downloadImage(with: m.ImgUrl.imgRequestUrl!) { (image, error, url, data) in
                let info = MonkeyKing.Info(title: m.Title, description: m.Details, thumbnail: image, media: .video(m.VideoUrl.imgRequestUrl!))
                let message = MonkeyKing.Message.weChat(.timeline(info: info))
                
                MonkeyKing.deliver(message) { (result) in
                    
                }
            }
        }
        
        let ac3 = UIAlertAction(title: "取消", style: .cancel) { (ac) in
        
        }
        
        sheet.addAction(ac1)
        sheet.addAction(ac2)
        sheet.addAction(ac3)
        
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    @objc func saveVideo(){
        
        guard let url = data?.VideoUrl.imgRequestUrl else {

            self.view.toast(message: "视频内容错误，不能下载")

            return
        }
        
        //指定下载路径
        let destination:DownloadRequest.DownloadFileDestination = { _, response in
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentURL.appendingPathComponent(response.suggestedFilename!)
            print("url" + fileURL.absoluteString)
            return (fileURL,[.removePreviousFile,.createIntermediateDirectories])
            }
        
        Alamofire.download(url, to: destination)
            .downloadProgress(closure: { (progress) in
                SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "正在下载...")
            })
            .responseData(completionHandler: { (dresponse) in
        
            switch dresponse.result {
            case .success(_):
              
                if let file = dresponse.destinationURL{
                    
                    PHPhotoLibrary.shared().performChanges({
                        let requet = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: file)
                        requet?.creationDate = Date()
                    }, completionHandler: { (b, e) in
                        
                    })
                }
                
                SVProgressHUD.showProgress(1, status: "下载完成，在相册中查看")
                SVProgressHUD.dismiss(withDelay: 1.5)
         
            case .failure(let e):
                print(e)
                SVProgressHUD.dismiss()
            }
            
        })
    }
    
    @objc func openFile(btn:UIButton){
        
        guard let m = data else {
            return
        }
        
        var file = ""
        if btn == titleView?.pptBtn{
            file = m.PPTUrl
        }else{
            file = m.FileUrl
        }
        
        let web = SFSafariViewController(url: file.imgRequestUrl!)
        web.title = m.FileName
       
        //web.path = file.imgRequestUrl
        self.present(web, animated: true, completion: nil)
        
        
        /*
        //指定下载路径
        let destination:DownloadRequest.DownloadFileDestination = { _, response in
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            var str = file
            str.removeFirst()
            let fileURL = documentURL.absoluteString + str
            print("url" + fileURL)
            let url = URL(string: fileURL)
            return (url!,[.removePreviousFile,.createIntermediateDirectories])
        }
        
        Alamofire.download(m.PPTUrl.imgRequestUrl!, to: destination)
            .downloadProgress(closure: { (progress) in
                SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "正在下载...")
            })
            .responseData(completionHandler: { (dresponse) in
                
                switch dresponse.result {
                case .success(_):
                    
                    if let file = dresponse.destinationURL{
                        
                        PHPhotoLibrary.shared().performChanges({
                            let requet = PHAssetCreationRequest.creationRequestForAssetFromVideo(atFileURL: file)
                            requet?.creationDate = Date()
                        }, completionHandler: { (b, e) in
                            
                        })
                    }
                    
                    SVProgressHUD.showProgress(1, status: "下载完成")
                    SVProgressHUD.dismiss(withDelay: 1.5, completion: {
                        let web = WebViewController()
                        web.title = m.FileName
                        web.path = dresponse.destinationURL
                        self.show(web, sender: nil)
                    })
                    
                case .failure(let e):
                    print(e)
                    SVProgressHUD.dismiss()
                }
                
            })
        */
        
    }
    
}





extension LessonDetailViewController{
    


}


class PlayerControlView:BMPlayerControlView {
    
    override func onButtonPressed(_ button: UIButton) {
        //super.onButtonPressed(button)
        self.autoFadeOutControlViewWithAnimation()
       
        switch button.tag {
        case BMPlayerControlView.ButtonType.fullscreen.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name("Player.FullScreen.Notification"), object: button)
        case BMPlayerControlView.ButtonType.back.rawValue:
            NotificationCenter.default.post(name: NSNotification.Name("Player.Back.Notification"), object: button)
        default:
            super.onButtonPressed(button)
        }
        
    }
    
}
