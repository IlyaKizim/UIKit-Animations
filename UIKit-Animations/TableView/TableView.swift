//
//  TableView.swift
//  UIKit-Animations
//
//  Created by Кизим Илья on 28.02.2024.
//

import UIKit

final class TableView: UIViewController {
    
    //MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(CustomTableViewCell.self, forCellReuseIdentifier: Constant.identifier)
        return table
    }()
    
    private lazy var shuffleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Constant.shuffle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var data: [Int] = Array(1...30)
    private var dataSource: UITableViewDiffableDataSource<Int, Int>?
    
    private lazy var dissmis: UIButton = {
        let button = UIButton(type: .close)
        button.frame = .init(x: 10, y: 50, width: 30, height: 30)
        button.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

//MARK: - setupUI

private extension TableView {
    func setupUI() {
        view.backgroundColor = .white
        configureDataSource()
        applySnapshot()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.delegate = self
        addSubviews()
        setConstraints()
    }
    
    func addSubviews() {
        view.addSubview(shuffleButton)
        view.addSubview(tableView)
        view.addSubview(dissmis)
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: shuffleButton.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shuffleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            shuffleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - ConfigurationDataSource

extension TableView {
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Int>(tableView: tableView, cellProvider: { tableView, indexPath, data in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constant.identifier, for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
            cell.indexLabel.text = "\(data)"
            cell.indexLabel.textColor = .white
            cell.selectionStyle = .none
            return cell
        })
    }
    
    @objc private func shuffleButtonTapped() {
        data.shuffle()
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}


//MARK: - UITableViewDelegate

extension TableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CustomTableViewCell else {
            return
        }
        if cell.checkmarkImageView.isHidden {
            cell.addParticlesForDeleteCell()
            cell.indexLabel.textColor = .clear
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                cell.checkMarkIsHidden()
            }
        } else {
            cell.checkMarkIsHidden()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            if !cell.checkmarkImageView.isHidden {
                if var snapshot = self.dataSource?.snapshot() {
                    let selectedItem = snapshot.itemIdentifiers[indexPath.row]
                    snapshot.deleteItems([selectedItem])
                    snapshot.insertItems([selectedItem], beforeItem: snapshot.itemIdentifiers.first ?? 1)
                    self.dataSource?.apply(snapshot, animatingDifferences: true)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    cell.indexLabel.textColor = .white
                    cell.addParticlesAfterRemovingCell()
                }
            }
        }
    }
}
