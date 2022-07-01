//
//  RestaurantsViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-27.
//

import UIKit

final class RestaurantsListViewController: UITableViewController {
    
    private let searchController = UISearchController()
    
    private var sortsOptionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "filterIcon"), for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = Layout.cornerRadius
        button.accessibilityIdentifier = AccessibilityIdentifiers.sortOptions
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewModel: RestaurantsListViewModel

    var didStartSearch:((String)-> Void)?
    var didCancelSearch:(()-> Void)?
    var didTapSortOptions:(()-> Void)?
    
    init(viewModel: RestaurantsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        title = viewModel.title
        setupButton()
        setupSearchController()
        registerTableView()
        bind()
        viewModel.load()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func bind() {
        viewModel.onLoad = loadTableView
        viewModel.onUpdate = loadTableView
        viewModel.onFail = { [weak self] error in
            guard let self = self else {
                return
            }
            self.showError(error)
        }
    }
    
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func registerTableView() {
        tableView.accessibilityIdentifier = AccessibilityIdentifiers.tableView
        tableView.register(RestaurantListTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.cell)
    }
    
    private func loadTableView() {
        tableView.reloadData()
    }
    
    private func setupButton() {
        view.addSubview(sortsOptionButton)
        sortsOptionButton.widthAnchor.constraint(equalToConstant: Layout.width).isActive = true
        sortsOptionButton.heightAnchor.constraint(equalToConstant: Layout.height).isActive = true
        sortsOptionButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: Layout.trailing).isActive = true
        sortsOptionButton.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: Layout.bottom).isActive = true
        sortsOptionButton.addTarget(self, action: #selector(tapFilters), for: .touchUpInside)
    }
    
    @objc
    private func tapFilters() {
        didTapSortOptions?()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.cell, for: indexPath) as! RestaurantListTableViewCell
        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
        return cell
    }
}


extension RestaurantsListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        didStartSearch?(text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch?()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text , text.isEmpty else {
            return
        }
        didCancelSearch?()
    }
}


private extension RestaurantsListViewController {
    
    enum ReuseIdentifier {
        static let cell = "RestaurantTableViewCell"
    }
    
    enum Layout {
        static let height: CGFloat = 50.0
        static let width: CGFloat = 50.0
        static let trailing: CGFloat = -8
        static let bottom: CGFloat = -8
        static let cornerRadius: CGFloat = 25
    }
}
