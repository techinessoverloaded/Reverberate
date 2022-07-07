//
//  LanguageGenreSelectionViewController.swift
//  Reverberate
//
//  Created by arun-13930 on 07/07/22.
//

import UIKit

class LanguageGenreSelectionViewController: UIViewController
{
    private var safeArea: UILayoutGuide!
    
    private let doneButton: UIButton = {
        var dButtonConfig = UIButton.Configuration.borderless()
        dButtonConfig.title = "done"
        dButtonConfig.baseForegroundColor = .init(named: GlobalConstants.techinessColor)
        let dButton = UIButton(configuration: dButtonConfig)
        dButton.enableAutoLayout()
        return dButton
    }()
    
    private let languageLabel: UILabel = {
        let lLabel = UILabel(useAutoLayout: true)
        lLabel.text = "Select your favourite Languages"
        lLabel.textColor = .label
        lLabel.font = .systemFont(ofSize: 24, weight: .bold)
        return lLabel
    }()

    private let genreLabel: UILabel = {
        let gLabel = UILabel(useAutoLayout: true)
        gLabel.text = "Select your favourite Music Genres"
        gLabel.textColor = .label
        gLabel.font = .systemFont(ofSize: 24, weight: .bold)
        return gLabel
    }()
    
    private let languageCollectionView: UICollectionView = {
        let lCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        lCollectionView.enableAutoLayout()
        return lCollectionView
    }()
    
    private let genreCollectionView: UICollectionView = {
        let gCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        gCollectionView.enableAutoLayout()
        return gCollectionView
    }()
    
    private let availableLanguages: [[Int16]] = [[0, 1], [2, 3], [4, 5]]
    
    private let availableGenres: [[Int16]] = [[0, 1], [2, 3], [4]]
    
    private var selectedLanguages: [Int16] = []
    
    private var selectedGenres: [Int16] = []
    
    weak var delegate: LanguageGenreSelectionDelegate?
    
    override func loadView()
    {
        super.loadView()
        safeArea = view.safeAreaLayoutGuide
        languageCollectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        genreCollectionView.register(SelectionCardCVCell.self, forCellWithReuseIdentifier: SelectionCardCVCell.identifier)
        view.addSubview(doneButton)
        view.addSubview(languageLabel)
        view.addSubview(genreLabel)
        view.addSubview(languageCollectionView)
        view.addSubview(genreCollectionView)
        NSLayoutConstraint.activate([
            doneButton.topAnchor.constraint(equalTo: safeArea.topAnchor),
            doneButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            languageLabel.topAnchor.constraint(equalTo: doneButton.bottomAnchor),
            languageLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            languageCollectionView.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 10),
            languageCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            languageCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            languageCollectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            languageCollectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4),
            genreLabel.topAnchor.constraint(equalTo: languageCollectionView.bottomAnchor, constant: 15),
            genreLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            genreCollectionView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            genreCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            genreCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            genreCollectionView.widthAnchor.constraint(equalTo: safeArea.widthAnchor),
            genreCollectionView.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.4)
        ])
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        languageCollectionView.dataSource = self
        languageCollectionView.delegate = self
        languageCollectionView.allowsMultipleSelection = true
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.allowsMultipleSelection = true
        doneButton.addTarget(self, action: #selector(onDoneButtonTap(_:)), for: .touchUpInside)
        doneButton.isEnabled = false
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
    }
}

extension LanguageGenreSelectionViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if collectionView === languageCollectionView
        {
            let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
            cell.layer.borderWidth = 3
            selectedLanguages.append(availableLanguages[indexPath.section][indexPath.item])
            print(selectedLanguages)
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
            cell.layer.borderWidth = 3
            selectedGenres.append(availableGenres[indexPath.section][indexPath.item])
            print(selectedGenres)
        }
        if !selectedGenres.isEmpty && !selectedLanguages.isEmpty
        {
            doneButton.isEnabled = true
        }
        else
        {
            doneButton.isEnabled = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        if collectionView === languageCollectionView
        {
            let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
            cell.layer.borderWidth = 0
            selectedLanguages.remove(at: selectedLanguages.firstIndex(of: availableLanguages[indexPath.section][indexPath.item])!)
            print(selectedLanguages)
        }
        else
        {
            let cell = collectionView.cellForItem(at: indexPath) as! SelectionCardCVCell
            cell.layer.borderWidth = 0
            selectedGenres.remove(at: selectedGenres.firstIndex(of: availableGenres[indexPath.section][indexPath.item])!)
            print(selectedGenres)
        }
        if !selectedGenres.isEmpty && !selectedLanguages.isEmpty
        {
            doneButton.isEnabled = true
        }
        else
        {
            doneButton.isEnabled = false
        }
    }
}

extension LanguageGenreSelectionViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        if collectionView === languageCollectionView
        {
            return availableLanguages.count
        }
        else
        {
            return availableGenres.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView === languageCollectionView
        {
            return availableLanguages[section].count
        }
        else
        {
            return availableGenres[section].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if collectionView === languageCollectionView
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
            let language = Language(rawValue: availableLanguages[indexPath.section][indexPath.item])
            let (title, subtitle) = language!.titleAndLetter
            return cell.configureCell(title: title, centerText: subtitle, backgroundColor: language?.preferredBackgroundColor)
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectionCardCVCell.identifier, for: indexPath) as! SelectionCardCVCell
            let genre = MusicGenre(rawValue: availableLanguages[indexPath.section][indexPath.item])
            return cell.configureCell(title: nil, centerText: genre!.description, backgroundColor: genre?.preferredBackgroundColor)
        }
    }
}


extension LanguageGenreSelectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellWidth = (view.frame.width / 2.5) - 1
        return .init(width: cellWidth, height: cellWidth / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return .init(top: 10, left: 15, bottom: 10, right: 15)
    }
}

extension LanguageGenreSelectionViewController
{
    @objc func onDoneButtonTap(_ sender: UIButton)
    {
        delegate?.onSelectionConfirmation(selectedLanguages: selectedLanguages, selectedGenres: selectedGenres)
    }
}
