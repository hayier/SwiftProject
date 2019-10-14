//
//  TeamViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/21.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController {

    let tableView:UITableView = {
        let t = UITableView(frame: .zero)
        t.backgroundColor = UIColor.HBackGray
        t.allowsMultipleSelection = false
        t.separatorInset = UIEdgeInsets.zero
        t.separatorColor = UIColor.HGray
        t.rowHeight = 60
        return t
    }()
    
    let topView = MoneyTopView()
    
    let cellId = "TeamCell"
    
    var dataSource = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "我的团队"
        view.backgroundColor = .HBackGray
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TeamCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        layoutViews()
        
        getData()
        

        topView.sureBtn.setTitle("我的返利", for: .normal)
        topView.sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        
        tableView.tableFooterView = UIView()
        
    }
    
    func layoutViews(){
        view.addSubview(tableView)
        view.addSubview(topView)
        
        topView.snp.makeConstraints{
            $0.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            } else {
                $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            }
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom)
        }
        
    }
    
    @objc func sureBtnClick(){
        let vc = BaseListMoneyViewController()
        vc.type = .Commission
        show(vc, sender: nil)
    }
    
}

extension TeamViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension TeamViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TeamCell
        let model = dataSource[indexPath.row]
        cell.imgv.kf.setImage(with: URL(string:model.PortraitUrl))
        cell.nameLab.text = model.Name
        cell.idLab.text = model.Phone
        return cell
    }

}


extension TeamViewController{
    
    func getData(){
        
        let api = API.GeUserTeam(key: UserHelper.UserKey.getValue!)
        
        HRequest.getData(api: api){ (data) in
            
            let dataArr = data.arrayValue
            
            for json in dataArr {
                guard let model = UserModel.deserialize(from: json.rawString()) else{
                    continue
                }
                self.dataSource.append(model)
            }
            
            //无团队
            self.topView.lab1.text = "团队人数：\(self.dataSource.count)人"
            
            self.tableView.reloadData()
        }
    }
    
}
