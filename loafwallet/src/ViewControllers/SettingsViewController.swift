//
//  SettingsViewController.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2017-03-30.
//  Copyright © 2017 breadwallet LLC. All rights reserved.
//
import UIKit
import LocalAuthentication

class SettingsViewController : UITableViewController, CustomTitleView {

  init(sections: [String], rows: [String: [Setting]], optionalTitle: String? = nil) {
        self.sections = sections
        if UserDefaults.isBiometricsEnabled {
            self.rows = rows
        } else {
            var tempRows = rows
            let biometricsLimit = LAContext.biometricType() == .face ? S.Settings.faceIdLimit : S.Settings.touchIdLimit
            tempRows["Manage"] = tempRows["Manage"]?.filter { $0.title != biometricsLimit }
            self.rows = tempRows
        }
        customTitle = optionalTitle ?? S.Settings.title
        titleLabel.text = optionalTitle ?? S.Settings.title
        super.init(style: .plain)
    }
 
    private let sections: [String]
    private var rows: [String: [Setting]]
    private let cellIdentifier = "CellIdentifier"
    let titleLabel = UILabel(font: .customBold(size: 26.0), color: .darkText)
    let customTitle: String
    private var walletIsEmpty = true

    override func viewDidLoad() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 48.0))
        headerView.backgroundColor = .whiteTint
        headerView.addSubview(titleLabel)
        titleLabel.constrain(toSuperviewEdges: UIEdgeInsetsMake(0, C.padding[2], 0, 0))
        tableView.register(SeparatorCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .whiteTint
        addCustomTitle()
        checkWalletStatus()
        addWalletObserver()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshTableData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[sections[section]]?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let setting = rows[sections[indexPath.section]]?[indexPath.row] {
            cell.textLabel?.text = setting.title
            cell.textLabel?.font = .customBody(size: 16.0)
            cell.textLabel?.textColor = .darkText

            let label = UILabel(font: .customMedium(size: 14.0), color: .grayTextTint)
            label.text = setting.accessoryText?()
            label.sizeToFit()
            cell.accessoryView = label
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        view.backgroundColor = .whiteTint
        let label = UILabel(font: .customBold(size: 14.0), color: .grayTextTint)
        view.addSubview(label)
        switch sections[section] {
        case "Wallet":
            label.text = S.Settings.wallet
        case "Manage":
            label.text = S.Settings.manage
        default:
            label.text = ""
        }
        let separator = UIView()
        separator.backgroundColor = .secondaryShadow
        view.addSubview(separator)
        separator.constrain([
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separator.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1.0) ])

        label.constrain([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: C.padding[2]),
            label.bottomAnchor.constraint(equalTo: separator.topAnchor, constant: -4.0) ])

        return view
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let setting = rows[sections[indexPath.section]]?[indexPath.row] {
            setting.callback()
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 47.0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScrollForCustomTitle(yOffset: scrollView.contentOffset.y)
    }

    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewWillEndDraggingForCustomTitle(yOffset: targetContentOffset.pointee.y)
    }
  
  
    private func refreshTableData() {
      var indexPaths: [IndexPath] = []
      sections.enumerated().forEach { i, key in
        rows[key]?.enumerated().forEach { j, setting in
          if setting.accessoryText != nil {
            indexPaths.append(IndexPath(row: j, section: i))
          }
        }
      }
      tableView.beginUpdates()
      tableView.reloadRows(at: indexPaths, with: .automatic)
      tableView.endUpdates()
    }
  
    private func checkWalletStatus() {
      if walletIsEmpty {
        var tempRows = rows
        tempRows["Wallet"] = tempRows["Wallet"]?.filter { $0.title != S.Settings.wipe}
        self.rows = tempRows
      } else {
        var tempRows = rows
        tempRows["Wallet"] = tempRows["Wallet"]?.filter { $0.title != S.Settings.wipeZeroBalance}
        self.rows = tempRows
      }
    }
  
    private func addWalletObserver() {
        NotificationCenter.default.addObserver(forName: .WalletBalanceChangedNotification, object: nil, queue: nil, using: { (note) in
          
            if let balance = note.userInfo?["balance"] as? Int {
              
              if balance == 0 {
                self.walletIsEmpty = true
              } else {
                self.walletIsEmpty = false
              }
              self.refreshTableData()
            }
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
