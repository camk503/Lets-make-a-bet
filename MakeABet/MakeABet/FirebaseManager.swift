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
    @Published var artistScore: [[String : Float]] = [["score" : 0.0], ["multiplier" : 0.0]]
    
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
            // This means artist recently made it on chart
            return "up"
        }
        
    }
    
    func updateArtistScores(topArtists: [Artist])
    {
        topArtists.forEach { artist in
            let docRef = db.collection("scores").document(artist.name)
                docRef.getDocument { (document, error) in
                if let _ = error
                {
                    print("Error getting document for \(artist.name)")
                }
                else
                {
                    if let document = document, document.exists
                    {
                        //let score = document.get("score") as! Float
                        let lastUpdate = document.get("lastUpdated") as! String
                        let lastPosition = document.get("lastPosition") as! Int
                        let score = document.get("score") as! Float
                        
                        self.db.collection("charts").getDocuments { (querySnapshot, error) in
                            if let error = error
                            {
                                print("Error getting documents from charts: \(error)")
                            }
                            else
                            {
                                let documents = querySnapshot!.documents
                                for (index, chartDoc) in documents.enumerated()
                                {
                                    if chartDoc.documentID == lastUpdate
                                    {
                                        //If it's been at least a week since the last update, update the artist's score
                                        if documents.count - 7 >= index
                                        {
                                            var newDocIndex = index + 7
                                            var updatedDoc = false
                                            while !(updatedDoc)
                                            {
                                                let newDoc = documents[newDocIndex]
                                                let artistNames = newDoc.get("artistNames") as! [String]
                                                if let artistIndex = artistNames.firstIndex(of: artist.name)
                                                {
                                                    updatedDoc = true
                                                    let position = artistIndex + 1
                                                    let scoreAddition = self.calculateArtistScore(position: position, lastPosition: lastPosition)
                                                    let newScore = score + scoreAddition
                                                    Task
                                                    {
                                                        do
                                                        {
                                                            try await docRef.setData([
                                                                "score": newScore,
                                                                "lastPosition": position,
                                                                "lastUpdated": newDoc.documentID
                                                            ],
                                                            merge: true)
                                                                
                                                        }
                                                        catch
                                                        {
                                                            print ("caught update document")
                                                        }
                                                    }
                                                    
                                                }
                                                else
                                                {
                                                    newDocIndex += 7
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else
                    {
                        self.db.collection("charts").getDocuments { (querySnapshot, error) in
                            if let error = error
                            {
                                print("Error getting documents from charts: \(error)")
                            }
                            else
                            {
                                let documents = querySnapshot!.documents
                                let initDoc = documents[5]
                                let artistNames = initDoc.get("artistNames") as! [String]
                                if let artistIndex = artistNames.firstIndex(of: artist.name)
                                {
                                    let position = artistIndex + 1
                                    let score = self.calculateArtistScore(position: position, lastPosition: 50)
                                    Task
                                    {
                                        do
                                        {
                                            try await docRef.setData([
                                                "score": score,
                                                "lastPosition": position,
                                                "lastUpdated": initDoc.documentID
                                            ],
                                            merge: true)
                                                
                                        }
                                        catch
                                        {
                                            print ("caught create document")
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    Task
                                    {
                                        do
                                        {
                                            try await docRef.setData([
                                                "score": 0.0,
                                                "lastPosition": 50,
                                                "lastUpdated": initDoc.documentID
                                            ],
                                            merge: true)
                                                
                                        }
                                        catch
                                        {
                                            print ("caught create document")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func calculateArtistScore(position: Int, lastPosition: Int) -> Float
    {
        var baseScore: Int = 0
        var multiplier: Float = 1.0
        
        if position > 50 || position < 1
        {
            print("Invalid position")
        }
        else if position == 1
        {
            baseScore = 125
            if lastPosition <= 10 && !(lastPosition < 1)
            {
                if lastPosition <= 5
                {
                    if lastPosition == 1
                    {
                        multiplier = 3.0
                    }
                    else
                    {
                        multiplier = 2.0
                    }
                }
                else
                {
                    multiplier = 1.5
                }
            }
        }
        else if position <= 5
        {
            baseScore = 100 - (10 * (position - 2))
            if lastPosition <= 10 && !(lastPosition < 1)
            {
                if lastPosition <= 5
                {
                    multiplier = 2.0
                }
                else
                {
                    multiplier = 1.5
                }
            }
        }
        else if position <= 10
        {
            baseScore = 70 - (5 * (position - 5))
            if lastPosition <= 10 && !(lastPosition < 1)
            {
                multiplier = 1.5
            }
        }
        else
        {
            baseScore = 50 - position + 1
        }
        
        return Float(baseScore) * multiplier
    }
}
