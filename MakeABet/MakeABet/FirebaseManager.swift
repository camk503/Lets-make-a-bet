//
//  FirebaseManager.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 11/11/24.
//

// NEED TO IMPORT THIS MODULE
// MakeABet (App Store Icon at the top left) > Frameworks, Libraries, and Embedded Content > + > FirebaseFirestore
import FirebaseFirestore
import Foundation

class FirebaseManager : ObservableObject {
    @Published var pastChart : [String] = []
    private var db = Firestore.firestore() // Firestore database connection
    
    init() {
        getLastWeeksChart()
    }
    
    func getLastWeeksChart() {
        db.collection("charts").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents from charts: \(error)")
            } else {
                // Get document from 7 days ago
                let documents = querySnapshot!.documents
                let document = documents[documents.count - 7]
                
                // Clear previous chart data
                self.pastChart.removeAll()
                
                // Append artists from chart to array
                for (_, value) in document.data() {
                    if let values = value as? [String] {
                        for artistName in values {
                            self.pastChart.append(artistName)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Function checks past index of artist against current index to see if they moved up, down, or stayed in the same place
     */
    func updateMovement(for artistName: String, at currIndex: Int) -> String {
        if let pastIndex = pastChart.firstIndex(of: artistName) {
            if (pastIndex > currIndex) {
                return "up"
            } else if (pastIndex < currIndex) {
                return "down"
            } else {
                return "none"
            }
        } else {
            // Couldn't find index on past chart
            // This means artist recently made it on chart, meaning they went up
            return "up"
        }
        
    }
}
