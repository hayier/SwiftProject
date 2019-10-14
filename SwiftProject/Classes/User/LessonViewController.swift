//
//  LessonViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class LessonViewController: UIViewController {

    let tableView:UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.separatorColor = UIColor.HGray
        t.rowHeight = 120
        t.showsVerticalScrollIndicator = false
        t.allowsSelection = false
        t.sectionHeaderHeight = 40
        t.tableFooterView = UIView()
        return t
    }()
    
    let cellId = "LessonCell"
    
    var dataSource = [VideoDataItem]()
    
    var recommendVideo:VideoModel?
 
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "焕颜课程"
        
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "LessonCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        getData()
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    func tableViewAddHeader(){
        
        guard let model = recommendVideo else {
            return
        }
        
        let header = LessonHeader(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let fixedH:CGFloat = 220
        let width = UIScreen.main.bounds.width - 40
        header.descLab.text = model.Details
        header.imgv.kf.setImage(with: model.ImgUrl.imgRequestUrl)
        header.titleLab.text = model.Title
        header.priceLab.text = model.Price > 0 ? "￥\(model.Price)" : "免费"
        let height = header.descLab.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height + fixedH
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        tableView.tableHeaderView = header
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHeader))
        header.addGestureRecognizer(tap)
    }
    
    @objc func tapHeader(){
        
        let vc = LessonDetailViewController()
        vc.data = self.recommendVideo
        self.show(vc, sender: nil)
        
    }
    
}

extension LessonViewController:UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].SYSOpenVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! LessonCell
        let model = dataSource[indexPath.section].SYSOpenVideo[indexPath.row]
        cell.imgv.kf.setImage(with: model.ImgUrl.imgRequestUrl)
        cell.titleLab.text = model.Title
        cell.statusLab.text = model.Details
        if model.Price == 0 {
            cell.priceLab.text = "免费"
        }else{
            cell.priceLab.text = String(format: "￥%.2f",model.Price)
        }
        
        cell.see = {[unowned self] in
            let vc = LessonDetailViewController()
            vc.data = model
            self.show(vc, sender: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .white
        let lab = UILabel(frame: CGRect(x: 20, y: 5, width: 300, height: 30))
        v.addSubview(lab)
        lab.text = dataSource[section].TypeName
        return v
    }
}

extension LessonViewController:UITableViewDelegate{
    
}

extension LessonViewController{
    
    func getData(){
        
        let api = API.GetVideAll
        
        HRequest.getData(api: api){
      
            for data in $0.arrayValue{
                guard let model = VideoDataItem.deserialize(from: data.rawString()) else{
                    break
                }
                self.dataSource.append(model)
                let arr = model.SYSOpenVideo.filter{$0.Recommend==1}
                self.recommendVideo = arr.first
            }
            self.tableViewAddHeader()
            self.tableView.reloadData()
        }
    }
}

