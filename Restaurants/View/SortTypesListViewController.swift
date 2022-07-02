//
//  SortListViewController.swift
//  Restaurants
//
//  Created by Alok Sinha on 2022-06-28.
//

import UIKit

final class SortTypesListViewController: UITableViewController {
    
    let viewModel: SortTypeListViewModel
    
    var selectSortType:((SortType)-> Void)?
    
    init(viewModel: SortTypeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = viewModel.title
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.accessibilityIdentifier = AccessibilityIdentifiers.tableView
        tableView.register(RestaurantListTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.cell)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sortTypes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.cell, for: indexPath)
        cell.textLabel?.text = viewModel.sortTypes[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectSortType?(viewModel.sortTypes[indexPath.row])
    }
}


private extension SortTypesListViewController {
    enum ReuseIdentifier {
        static let cell = "RestaurantListTableViewCell"
    }
}
