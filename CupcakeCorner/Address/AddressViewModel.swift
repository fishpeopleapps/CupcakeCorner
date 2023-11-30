//
//  AddressViewModel.swift
//  CupcakeCorner
//
//  Created by Kimberly Brewer on 11/29/23.
//
// Tutorial: https://levelup.gitconnected.com/implementing-address-autocomplete-using-swiftui-and-mapkit-c094d08cda24
// TODO: Comment code
import Foundation
import MapKit

class AddressViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task { 
            @MainActor in
            results = completer.results.map {
                AddressResult(title: $0.title, subtitle: $0.subtitle)
            }
        }
    }
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    // TODO: Handle Errors
    }
}
