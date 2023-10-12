//
//  FilterSelectionViewModel.swift
//  NewsHub
//
//  Created by Anton Petrov on 12.10.2023.
//

import Foundation

final class FilterSelectionViewModel {
    // MARK: - Properties

    private var selectedCountryCategoryIndices: [Int: Int] = [:]
    private var selectedSources: Set<Int> = []
    private var newsSources: [Source]
    private(set) var newsRequest: NewsRequest
    private(set) var currentMode: FilteringMode = .filters

    var numberOfSections: Int {
        return currentMode == .filters ? FilterSection.allCases.count : 1
    }

    var segments: [String] {
        FilteringMode.allCases.map { $0.titles }
    }

    // MARK: - Initialization

    init(sources: [Source], request: NewsRequest) {
        newsSources = sources.filter { $0.name != nil && $0.id != nil }
        newsRequest = request
        if let selectedCountry = newsRequest.country, let index = Country.allCases.firstIndex(of: selectedCountry) {
            selectedCountryCategoryIndices[FilterSection.country.rawValue] = index
        }
        if let selectedCategory = newsRequest.category, let index = Category.allCases.firstIndex(of: selectedCategory) {
            selectedCountryCategoryIndices[FilterSection.category.rawValue] = index
        }
        for (index, source) in newsSources.enumerated() {
            if let id = source.id, newsRequest.sources.contains(id) {
                selectedSources.insert(index)
            }
        }
        if newsRequest.sources.isEmpty {
            currentMode = .filters
        } else {
            currentMode = .sources
        }
    }

    // MARK: - Modeling methods

    func titleForHeaderInSection(section: Int) -> String? {
        switch currentMode {
        case .filters:
            return FilterSection(rawValue: section)?.sectionTitle ?? ""
        case .sources:
            return LocalizedString.sources.localized
        }
    }

    func numberOfRowsInSection(section: Int) -> Int {
        switch currentMode {
        case .filters:
            return FilterSection(rawValue: section)?.rowCount ?? 0
        case .sources:
            return newsSources.count
        }
    }

    func titleForIndexPath(_ indexPath: IndexPath) -> String {
        switch currentMode {
        case .filters:
            return FilterSection(rawValue: indexPath.section)?.titleForRow(indexPath.row) ?? ""
        case .sources:
            return newsSources[indexPath.row].name ?? ""
        }
    }

    func isIndexPathSelected(_ indexPath: IndexPath) -> Bool {
        switch currentMode {
        case .filters:
            return selectedCountryCategoryIndices[indexPath.section] == indexPath.row
        case .sources:
            return selectedSources.contains(indexPath.row)
        }
    }

    func selectIndexPath(_ indexPath: IndexPath) {
        switch currentMode {
        case .filters:
            if let currentSelectedRow = selectedCountryCategoryIndices[indexPath.section],
               currentSelectedRow == indexPath.row {
                selectedCountryCategoryIndices[indexPath.section] = nil
                if indexPath.section == FilterSection.country.rawValue {
                    newsRequest.country = nil
                } else if indexPath.section == FilterSection.category.rawValue {
                    newsRequest.category = nil
                }
            } else {
                selectedCountryCategoryIndices[indexPath.section] = indexPath.row
                if indexPath.section == FilterSection.country.rawValue {
                    newsRequest.country = Country.allCases[indexPath.row]
                } else if indexPath.section == FilterSection.category.rawValue {
                    newsRequest.category = Category.allCases[indexPath.row]
                }
            }
            newsRequest.sources = []
            selectedSources = []
        case .sources:
            if selectedSources.contains(indexPath.row) {
                selectedSources.remove(indexPath.row)
                if let id = newsSources[indexPath.row].id {
                    newsRequest.sources.removeAll(where: { $0 == id })
                }
            } else {
                selectedSources.insert(indexPath.row)
                if let id = newsSources[indexPath.row].id {
                    newsRequest.sources.append(id)
                }
            }
            newsRequest.country = nil
            newsRequest.category = nil
            selectedCountryCategoryIndices = [:]
        }
    }

    func switchFilterMode(to index: Int) {
        currentMode = FilteringMode(rawValue: index) ?? .filters
    }

    func clearFilters() {
        selectedCountryCategoryIndices = [:]
        selectedSources = []
        newsRequest.country = nil
        newsRequest.category = nil
        newsRequest.sources = []
    }
}
