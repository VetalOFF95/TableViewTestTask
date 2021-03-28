//
//  FilterVM.swift
//  TableViewTestTask
//
//  Created by  Vitalii on 28.03.2021.
//

import Foundation

class FilterVM {
    
    let filterData = FilterData()
    var countries = [Country]()
    
    public func getNumberOfCategories() -> Int {
        return filterData.categories.count + 1
    }
    
    public func getNumberOfCountries() -> Int {
        return countries.count + 1
    }
    
    public func getCategory(at index: Int) -> String {
        if index == 0 {
            return ""
        } else {
            return filterData.categories[index - 1]
        }
    }
    
    public func getCountry(at index: Int) -> String {
        if index == 0 {
            return ""
        } else {
            return countries[index - 1].name
        }
    }
    
    public func prepareCountriesData() {        
        for code in filterData.countries {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue : code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: .identifier, value: id)
            
            if let name = name {
                countries.append(Country(code: code, name: name))
            }
        }
        countries.sort { $0.name < $1.name
        }
    }
    
    public func getCountryCode(by name: String) -> String{
        var code = ""
        for country in countries {
            if country.name == name {
                code = country.code
            }
        }
        return code
    }
}
