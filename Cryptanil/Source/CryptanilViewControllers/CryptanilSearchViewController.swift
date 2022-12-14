//
//  SearchViewController.swift
//  Cryptanil
//
//  Created by Hayk Movsesyan on 03.10.22.
//

import UIKit

protocol CryptanilSearchViewControllerDelegate: AnyObject {
    func selected(wallet: WalletInfo)
}

final class CryptanilSearchViewController: UIViewController {
    
    private var navBar: UINavigationBar!
    private var tableView: UITableView!
    private var searchBar: UISearchBar!
    var wallets: [WalletInfo] = [] {
        willSet {
            searchWallets = newValue
        }
    }
    private var searchWallets = [WalletInfo]()
    weak var delegate: CryptanilSearchViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerKeyboardNotifications()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        view.backgroundColor = CryptanilColors.background
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
    }
    
    private func setupNavigationBar() {
        navBar = UINavigationBar()
        navBar.backgroundColor = CryptanilColors.background
        view.addSubview(navBar)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let navItem = UINavigationItem(title: "Crypto types".cryptanilLocalized())
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel".cryptanilLocalized(), style: .done, target: self, action: #selector(close))
        navBar.setItems([navItem], animated: false)
    }
    
    @objc func close() {
        self.dismiss(animated: true)
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search crypto type".cryptanilLocalized()
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: navBar.trailingAnchor).isActive = true
        let separatorView = UIView()
        separatorView.backgroundColor = .separator
        searchBar.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.heightAnchor.constraint(equalToConstant: 0.33).isActive = true
        separatorView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor).isActive = true
        separatorView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func updateUI() {
        tableView?.reloadData()
    }
}

extension CryptanilSearchViewController {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
        tableView.contentInset = contentInset
        tableView.verticalScrollIndicatorInsets.bottom = keyboardFrame.size.height - view.safeAreaInsets.bottom
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        tableView.verticalScrollIndicatorInsets.bottom = 0
        tableView.contentInset = contentInset
    }
}

extension CryptanilSearchViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchWallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchWallets[indexPath.row].coin
        cell.textLabel?.textColor = CryptanilColors.black
        cell.backgroundColor = CryptanilColors.inputBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selected(wallet: searchWallets[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchWallets = wallets
        } else {
            searchWallets = wallets.filter({$0.coin.uppercased().contains(searchText.uppercased())})
        }
        updateUI()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchWallets = wallets
        updateUI()
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
}
