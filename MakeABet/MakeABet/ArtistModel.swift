//
//  ArtistModel.swift
//  MakeABet
//
//  Created by Hannah Sheridan on 10/23/24.
//


/* STRUCTS FOR TOP ARTISTS */
struct TopArtists : Decodable  {
    //let artists : [Artist]
    let artists : ArtistList
}

// Struct to represent JSON data for top artists
struct ArtistList : Decodable {
    let artist : [Artist]
}

// Nested Artist info
struct Artist : Decodable {
    let name : String
    let playcount : String
    let listeners : String
    let mbid : String
    let url : String
    let image : [Image]
}

// Nested Nested Image Info
struct Image : Decodable {
    let text : String
    let size : String
    
    // Text labelled as "#text"
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
        case size
    }
}

/* STRUCTS FOR ARTIST INFORMATION */
struct ArtistInfoResponse : Decodable {
    let artist : ArtistInfo
}

struct ArtistInfo : Decodable {
    let name : String
    // let mbid : String
    let url : String
    let image : [Image]
    let stats : Stats
    let tags : Tags
    let bio : Bio
}

struct Stats : Decodable {
    let listeners : String
    let playcount : String
}
struct Tags : Decodable {
    let tag : [Tag]
}
struct Tag : Decodable {
    let name : String
    let url : String
}

struct Bio : Decodable {
    let summary : String
    let content : String
}

/* STRUCTS FOR DEEZER IMAGES */
/*
struct DeezArtistList : Decodable {
    let data : DeezArtists
}*/
struct DeezArtists : Decodable {
    let data : [DeezArtistInfo]
}

struct DeezArtistInfo : Decodable {
    let id : Int
    let name : String
    let link : String
    let picture : String
    let picture_small : String
    let picture_medium : String
    let picture_big : String
}
