//
//  EventListViewController.swift
//  InnovaEventManagement
//
//  Created by Amitesh Mani Tiwari on 30/11/24.
//

import UIKit
import FirebaseFirestore

class EventListViewController: UIViewController {
    // UI Components
    private let tableView = UITableView()
    private let addButton = UIButton(type: .system)

    // ViewModel
    private let viewModel = EventViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchEvents() // Fetch events from Firestore
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Event List"

        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EventCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Add Button
        addButton.setTitle("+ Add Event", for: .normal)
        addButton.backgroundColor = .systemBlue
        addButton.tintColor = .white
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addEventTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),

            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupBindings() {
        viewModel.onEventsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    // Action for Add Button
    @objc private func addEventTapped() {
        let alert = UIAlertController(title: "New Event", message: "Enter event details", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Event Title" }
        alert.addTextField { $0.placeholder = "Event Description" }
        alert.addTextField { $0.placeholder = "Event Date (e.g., 2024-12-01)" }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let title = alert.textFields?[0].text,
                  let description = alert.textFields?[1].text,
                  let date = alert.textFields?[2].text else { return }

            self?.viewModel.addEvent(name: title, description: description, date: date)
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource and Delegate
extension EventListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = viewModel.events[indexPath.row]
        cell.textLabel?.text = "\(event.name) - \(event.date)"
        cell.detailTextLabel?.text = event.description
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event = viewModel.events[indexPath.row]
        print("Selected Event: \(event.name)")
    }
    
}

