//
//  AddressListViewController.swift
//  SwiftProject
//
//  Created by tongcheng on 2019/5/6.
//  Copyright © 2019 icx. All rights reserved.
//

import UIKit

class AddressListViewController: UIViewController {

    let tableView:UITableView = {
        let t = UITableView(frame: .zero)
        t.backgroundColor = .HBackGray
        t.separatorColor = UIColor.groupTableViewBackground
        t.separatorInset = .zero
        t.rowHeight = 85
        t.showsVerticalScrollIndicator = false
        return t
    }()
    
    let cellId = "AddressCell"
    
    var dataSource = [Address]()
    
    var selectedAddress:((Address)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的地址"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "AddressCell", bundle: nil), forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        addTableViewHeader()
        
        getData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editAddress(noti:)), name: NSNotification.Name(rawValue: "com.Address.edit"), object: nil)
    }
    
    func addTableViewHeader(){
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        btn.setImage(UIImage(named: "address_icon1"), for: .normal)
        btn.setTitle("新建收货地址", for: .normal)
        btn.setTitleColor(.HTextBlack, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        tableView.tableHeaderView = btn
    }
    
    @objc func addAddress(){
        let vc = AddAdsViewController()
        vc.success = {
            self.getData()
        }
        show(vc, sender: nil)
    }
    
    @objc func editAddress(noti:Notification){
        let cell = noti.object as! AddressCell
        guard let idxPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let address = dataSource[idxPath.row]
        
        let vc = AddAdsViewController()
        vc.success = {
            self.getData()
        }
        vc.mail = address
        show(vc, sender: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension AddressListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddressCell
        let address = dataSource[indexPath.row]
        cell.nameLab.text = address.ContactName
        cell.phoneLab.text = address.ContactMobile
        let name = AddressModel.getCitiesName(pID: address.ProvinceID, cID: address.CityID, tID: address.AreaID)
        cell.addressLab.text = name.p + name.c + name.t + address.Address
        return cell
    }
    
    
}

extension AddressListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if selectedAddress != nil {
            selectedAddress!(dataSource[indexPath.row])
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if dataSource.count == 1 {
                view.toast(message: "必须保留一条地址")
            }else{
                deleteData(idx: indexPath.row, address: dataSource[indexPath.row])
            }
        }
    }
    
}


extension AddressListViewController{
    
    func getData(){
        
        let api = API.GeUserMailAll(key: UserHelper.UserKey.getValue!)
        
        HRequest.getData(api: api){
            let data = $0.arrayValue.map{
                return Address.deserialize(from: $0.rawString())
            }
            
            self.dataSource = data as! [Address]
            
            self.tableView.reloadData()
        }
    }
    
    func deleteData(idx:Int, address:Address){
        
        let api = API.UserMailAddorEdit(key: UserHelper.UserKey.getValue!, id:address.ID , ContactName: "0", ContactMobile: "0", ProvinceID: "0", CityID: "0", AreaID: "0", Address: "0", type: .delete)
        
        HRequest.getData(api: api) { (_) in
            
            self.dataSource.remove(at: idx)
            let idxPath = IndexPath(row: idx, section: 0)
            self.tableView.deleteRows(at: [idxPath], with: .automatic)
            
        }
        
    }
    
}
