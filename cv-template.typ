// cv-template.typ - Clean version with hanging indent for publications

#import "@preview/fontawesome:0.5.0": *
#import "@preview/use-academicons:0.1.0": *

//------------------------------------------------------------------------------
// Style and Colors
//------------------------------------------------------------------------------

#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-gray = rgb("#5d5d5d")
#let color-lightgray = rgb("#999999")
#let color-accent = color-darkgray

#let font-header = ("Myriad Pro", "Arial", "Helvetica")
#let font-text = ("Myriad Pro", "Arial", "Helvetica")

//------------------------------------------------------------------------------
// Helper Functions
//------------------------------------------------------------------------------

// Layout utility
#let __justify_align(left_body, right_body) = {
  block[
    #box(width: 4fr)[#left_body]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

// Simple LaTeX logo (Quarto-compatible)
#let LaTeX = {
  h(0.1em)  // Space before
  "L"
  h(-0.3em)
  text(size: 0.75em, baseline: -0.2em, "A")  // A positioned correctly
  h(-0.1em)
  "T"
  h(-0.12em)
  text(size: 0.75em, baseline: 0.2em, "E")   // E positioned correctly
  h(-0.08em)
  "X"
  h(0.1em)  // Space after
}

// Simple TeX logo (Quarto-compatible)
#let TeX = {
  "T"
  h(-0.12em)
  text(size: 0.75em, baseline: 0.2em, "E")   // E positioned correctly
  h(-0.08em)
  "X"
}

// Reference entry
#let reference-entry(
  name: "",
  title: "",
  institution: "",
  address: "",
  phone: "",
  email: ""
) = {
  set text(size: 10pt)
  [
    #text(weight: "bold", fill: color-darkgray)[#name]
    #linebreak()
    #text(fill: color-gray)[
      #title
      #linebreak()
      #institution
      #if address != "" [
        #linebreak()
        #fa-icon("location-dot") #address
      ]
      #if phone != "" [
        #linebreak()
        #fa-icon("phone") #phone
      ]
      #if email != "" [
        #linebreak()
        #fa-icon("envelope") #link("mailto:" + email)[#text(fill: color-accent)[#email]]
      ]
    ]
  ]
  v(0.8em)
}

// Two-column references layout with toggle support
#let references-section(references, show-references: true) = {
  if show-references and references.len() > 0 {
    let num-refs = references.len()
    let left-refs = references.slice(0, calc.ceil(num-refs / 2))
    let right-refs = references.slice(calc.ceil(num-refs / 2))
    
    grid(
      columns: (1fr, 1fr),
      column-gutter: 2em,
      align: (left, left),
      [
        #for ref in left-refs [
          #reference-entry(
            name: ref.name,
            title: ref.title,
            institution: ref.institution,
            address: ref.address,
            phone: ref.phone,
            email: ref.email
          )
        ]
      ],
      [
        #for ref in right-refs [
          #reference-entry(
            name: ref.name,
            title: ref.title,
            institution: ref.institution,
            address: ref.address,
            phone: ref.phone,
            email: ref.email
          )
        ]
      ]
    )
  } else if not show-references {
    text(size: 11pt, style: "italic", fill: color-gray)[References available upon request.]
  }
}

// Header styles
#let secondary-right-header(body) = {
  set text(
    size: 10pt,
    weight: "thin",
    style: "italic",
    fill: color-accent,
  )
  body
}

#let tertiary-right-header(body) = {
  set text(
    weight: "light",
    size: 9pt,
    style: "italic",
    fill: color-gray,
  )
  body
}

// Justified headers
#let justified-header(primary, secondary, small: false) = {
  let header-size = if small { 11pt } else { 12pt }
  
  set block(
    above: 0.7em,
    below: 0.7em,
  )
  pad[
    #__justify_align[
      #set text(
        size: header-size,
        weight: "bold",
        fill: color-darkgray,
      )
      #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}

//------------------------------------------------------------------------------
// CV Functions
//------------------------------------------------------------------------------

// Section heading
#let section(title) = {
  set block(
    above: 1.5em,
    below: 1em,
  )
  set text(
    size: 16pt,
    weight: "regular",
  )
  
  stack(
    spacing: 0.3em,
    text(color-accent, weight: "bold")[#title],
    line(length: 100%)
  )
}

// CV entry
#let cv-entry(
  title: "",
  organization: "",
  location: "",
  dates: "",
  description: "",
  details: (),
  small: false,  // Parameter for smaller font
  indent: false  // New parameter for indentation
) = {
  let desc-size = if small { 9pt } else { 10pt }
  let left-margin = if indent { 1em } else { 0em }
  
  pad(left: left-margin)[
    #justified-header(title, location, small: small)
    #secondary-justified-header(if organization != "" { organization } else { description }, dates)
    #if description != "" and organization != "" [
      #v(0.3em)
      #text(size: desc-size, fill: color-gray)[#description]
    ]
  ]
  
  // Details/bullet points
  if details.len() > 0 {
    v(0.3em)
    pad(left: left-margin)[
      #set text(
        size: desc-size,
        style: "normal",
        weight: "light",
        fill: color-darknight,
      )
      #set par(leading: 0.65em)
      #for detail in details {
        [- #detail]
        linebreak()
      }
    ]
  }
  
  v(0.5em)
}

// Publication entry
#let pub-entry(
  authors: "",
  title: "",
  venue: "",
  year: "",
  doi: "",
  url: "",
  note: "",
  coauthor-mark: false
) = {
  set text(size: 10pt, fill: color-darknight)
  
  // Co-authorship marker
  if coauthor-mark [
    #text(fill: color-accent)[⋆ ]
  ]
  
  // Authors
  if authors != "" [
    #text(weight: "medium")[#authors]#if title != "" [, ]
  ]
  
  // Title in quotes
  if title != "" [
    "#title"#if venue != "" [, ]
  ]
  
  // Venue in italics
  if venue != "" [
    #text(style: "italic", fill: color-gray)[#venue]
  ]
  
  // Year
  if year != "" [
    #if venue != "" [ ]
    #text(fill: color-darkgray)[(#year)]
  ]
  
  // DOI or URL
  if doi != "" [
    , doi: #link("https://doi.org/" + doi)[#text(fill: color-accent)[#doi]]
  ] else if url != "" [
    , #link(url)[#text(fill: color-accent)[link]]
  ]
  
  // Additional notes
  if note != "" [
    #linebreak()
    #text(size: 9pt, fill: color-lightgray, style: "italic")[#note]
  ]
  
  v(0.4em)
}

// Teaching entry
#let teaching-entry(
  course: "",
  institution: "",
  terms: "",
  urls: ()
) = {
  pad[
    #justified-header(course, terms)
    #secondary-justified-header(institution, "")
    #if urls.len() > 0 [
      #v(0.3em)
      #set text(size: 9pt, fill: color-accent)
      #for (i, url) in urls.enumerate() [
        #link(url)#if i < urls.len() - 1 [#linebreak()]
      ]
    ]
  ]
  v(0.3em)
}

// Service list
#let service-list(items) = {
  set text(size: 10pt, fill: color-darknight)
  block[
    #items.join("; ")
  ]
  v(0.5em)
}

//------------------------------------------------------------------------------
// Bibliography Functions
//------------------------------------------------------------------------------

// Helper function to bold specific name in author list
#let bold-author-name(authors-str, bold-name) = {
  // Split by " and " and handle various formats
  let parts = authors-str.split(regex(" and |, and | & "))
  let formatted-parts = ()
  
  for part in parts {
    let clean-part = part.trim()
    // Check if this part contains the name to bold
    if clean-part.contains(bold-name) or bold-name.contains(clean-part) {
      formatted-parts.push(text(weight: "bold")[#clean-part])
    } else {
      formatted-parts.push(clean-part)
    }
  }
  
  // Rejoin with " and "
  formatted-parts.join(" and ")
}

// Function to format a single publication in APSA style with numbering and hanging indent
#let format-publication(
  entry,
  number: none,
  bold-name: "Cameron Wimpy",
  show-alphabetical: true
) = {
  set text(size: 10pt, fill: color-darknight)
  set par(leading: 0.65em, hanging-indent: 2em)
  
  // Build the number prefix (without asterisk)
  let prefix = ""
  if number != none {
    prefix = str(number) + ". "
  }
  
  // Build the full citation as one continuous text block
  let citation = ""
  
  // Authors - bold the specified name
  if "author" in entry {
    citation = citation + bold-author-name(str(entry.author), bold-name) + ". "
  }
  
  // Publication type specific formatting (APSA style)
  if entry.type == "article" {
    // Journal article - APSA format
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    if "journal" in entry {
      citation = citation + text(style: "italic")[#str(entry.journal)]
    }
    if "volume" in entry {
      citation = citation + " " + str(entry.volume)
    }
    if "number" in entry {
      citation = citation + " (" + str(entry.number) + ")"
    }
    if "year" in entry {
      citation = citation + ": "
    }
    if "pages" in entry {
      citation = citation + str(entry.pages).replace("--", "–") + "."
    }
  } else if entry.type == "incollection" {
    // Book chapter - APSA format
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    citation = citation + "In "
    if "booktitle" in entry {
      citation = citation + text(style: "italic")[#str(entry.booktitle)]
    }
    if "editor" in entry {
      let eds = if str(entry.editor).contains(" and ") { "eds" } else { "ed" }
      citation = citation + ", " + eds + ". by " + str(entry.editor) + ". "
    }
    if "address" in entry and "publisher" in entry {
      citation = citation + str(entry.address) + ": " + str(entry.publisher) + ", "
    }
    if "year" in entry {
      citation = citation + str(entry.year)
    }
    if "pages" in entry {
      citation = citation + ", " + str(entry.pages).replace("--", "–")
    }
    citation = citation + "."
  } else if entry.type == "book" {
    // Book - APSA format
    if "title" in entry {
      citation = citation + text(style: "italic")[#str(entry.title)] + ". "
    }
    if "address" in entry and "publisher" in entry {
      citation = citation + str(entry.address) + ": " + str(entry.publisher) + ", "
    }
    if "year" in entry {
      citation = citation + str(entry.year) + "."
    }
  } else if entry.type == "inproceedings" or entry.type == "conference" {
    // Conference paper - APSA format
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    citation = citation + "Paper presented at "
    if "booktitle" in entry {
      citation = citation + str(entry.booktitle)
    }
    if "address" in entry and "year" in entry {
      citation = citation + ", " + str(entry.address) + ", " + str(entry.year) + "."
    } else if "year" in entry {
      citation = citation + ", " + str(entry.year) + "."
    }
  } else if entry.type == "techreport" or entry.type == "misc" {
    // Technical report or misc - APSA format
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    if "institution" in entry {
      citation = citation + str(entry.institution) + ", "
    }
    if "year" in entry {
      citation = citation + str(entry.year) + "."
    }
  }
  
  // Add asterisk at the end for equal authorship
  if show-alphabetical and "note" in entry and str(entry.note).contains("equal") {
    citation = citation + text(fill: color-accent, weight: "bold")[#super[\*]]
  }
  
  // Output the complete citation with hanging indent
  [#prefix#citation]
  
  v(0.4em)
}

// Function to process and display publications by category
#let display-publications(
  bib-file: "",
  categories: (),
  bold-name: "Cameron Wimpy",
  reverse-numbering: true
) = {
  // For now, we use sample data - replace this with your actual publications
  let all-pubs = (
    (
      type: "article",
      author: "Cameron Wimpy and Sarah Johnson",
      title: "Power Dynamics in Contemporary American Politics",
      journal: "American Political Science Review",
      volume: "118",
      number: "3",
      year: "2024",
      pages: "456--478",
      doi: "10.1017/S0003055424000123",
      note: "equal authorship"
    ),
    (
      type: "article",
      author: "Cameron Wimpy",
      title: "Voting Behavior in the Digital Age: A Comprehensive Analysis of Modern Electoral Participation and Its Implications for Democratic Governance",
      journal: "Journal of Politics",
      volume: "86",
      number: "2", 
      year: "2024",
      pages: "234--256",
      doi: "10.1086/123456789"
    ),
    (
      type: "incollection",
      author: "Cameron Wimpy",
      title: "Political Institutions and Democratic Governance: Understanding the Complex Relationships Between Formal and Informal Rules",
      booktitle: "Handbook of American Politics",
      editor: "Robert Thompson and Jennifer Davis",
      publisher: "Oxford University Press",
      year: "2024",
      pages: "145--168",
      address: "New York"
    ),
    (
      type: "article",
      author: "Michael Anderson and Cameron Wimpy and Lisa Chen",
      title: "Cross-Party Collaboration in Legislative Settings",
      journal: "Political Research Quarterly",
      volume: "76",
      number: "4",
      year: "2023",
      pages: "567--589",
      doi: "10.1177/10659129231234567",
      note: "equal authorship"
    ),
    (
      type: "book",
      author: "Cameron Wimpy and Rachel Green",
      title: "American Political Behavior: Theory and Practice",
      publisher: "University of Chicago Press",
      year: "2022",
      address: "Chicago"
    )
  )
  
  // Sort by year (descending) then by title
  let sorted-pubs = all-pubs.sorted(key: (pub) => (-int(str(pub.year)), str(pub.title)))
  
  // Group by type if categories are specified
  if categories.len() > 0 {
    for category in categories {
      let cat-pubs = sorted-pubs.filter(pub => {
        if category.type == "article" and pub.type == "article" { true }
        else if category.type == "incollection" and pub.type == "incollection" { true }
        else if category.type == "book" and pub.type == "book" { true }
        else if category.type == "inproceedings" and pub.type == "inproceedings" { true }
        else if category.type == "conference" and pub.type == "conference" { true }
        else if category.type == "techreport" and pub.type == "techreport" { true }
        else if category.type == "misc" and pub.type == "misc" { true }
        else { false }
      })
      
      if cat-pubs.len() > 0 {
        // Category heading
        text(size: 11pt, weight: "bold", fill: color-darkgray)[#category.title]
        v(0.3em)
        
        // Publications in this category - restart numbering for each category
        for (i, pub) in cat-pubs.enumerate() {
          let num = if reverse-numbering {
            cat-pubs.len() - i  // Count down within this category
          } else {
            i + 1  // Count up within this category
          }
          format-publication(pub, number: num, bold-name: bold-name)
        }
        
        v(0.5em)
      }
    }
  } else {
    // Display all publications without categories
    for (i, pub) in sorted-pubs.enumerate() {
      let num = if reverse-numbering {
        sorted-pubs.len() - i
      } else {
        i + 1
      }
      format-publication(pub, number: num, bold-name: bold-name)
    }
  }
}

// Alternative function to accept publications as a parameter from Quarto
#let display-publications-from-data(
  publications: (),
  categories: (),
  bold-name: "Cameron Wimpy",
  reverse-numbering: true
) = {
  // Use publications directly if it's already an array, otherwise use empty array
  let all-pubs = if type(publications) == array { publications } else { () }
  
  // If we don't have publications, show a message
  if all-pubs.len() == 0 {
    text(fill: red)[Error: No publications data received. Check R chunk output.]
    return
  }
  
  // Sort by year (descending) then by title
  let sorted-pubs = all-pubs.sorted(key: (pub) => {
    let year = if "year" in pub { int(str(pub.year)) } else { 0 }
    let title = if "title" in pub { str(pub.title) } else { "" }
    (-year, title)
  })
  
  // Group by type if categories are specified
  if categories.len() > 0 {
    for category in categories {
      // Categories are arrays where [0] = type, [1] = title
      let cat-type = category.at(0)
      let cat-title = category.at(1)
      
      let cat-pubs = sorted-pubs.filter(pub => {
        if cat-type == "article" and pub.type == "article" { true }
        else if cat-type == "incollection" and pub.type == "incollection" { true }
        else if cat-type == "book" and pub.type == "book" { true }
        else if cat-type == "inproceedings" and pub.type == "inproceedings" { true }
        else if cat-type == "conference" and pub.type == "conference" { true }
        else if cat-type == "techreport" and pub.type == "techreport" { true }
        else if cat-type == "misc" and pub.type == "misc" { true }
        else { false }
      })
      
      if cat-pubs.len() > 0 {
        // Category heading
        text(size: 11pt, weight: "bold", fill: color-darkgray)[#cat-title]
        v(0.3em)
        
        // Publications in this category - restart numbering for each category
        for (i, pub) in cat-pubs.enumerate() {
          let num = if reverse-numbering {
            cat-pubs.len() - i  // Count down within this category
          } else {
            i + 1  // Count up within this category
          }
          format-publication(pub, number: num, bold-name: bold-name)
        }
        
        v(0.5em)
      }
    }
  } else {
    // Display all publications without categories
    for (i, pub) in sorted-pubs.enumerate() {
      let num = if reverse-numbering {
        sorted-pubs.len() - i
      } else {
        i + 1
      }
      format-publication(pub, number: num, bold-name: bold-name)
    }
  }
}

// Function to display publications from a .bib file using Typst's built-in bibliography
#let display-publications-from-bib(
  bib-file: "",
  bold-name: "Cameron Wimpy",
  reverse-numbering: true,
  categories: ()
) = {
  if bib-file == "" {
    text(fill: red)[Error: No bibliography file specified]
    return
  }
  
  // Set up the bibliography with no style (we'll format manually)
  set bibliography(style: "apa", title: none)
  
  // Show the bibliography entries
  // Note: This is a simplified approach - Typst's bibliography handling is still evolving
  bibliography(bib-file)
  
  // For now, add a note about manual formatting
  v(1em)
  text(size: 9pt, fill: color-gray, style: "italic")[
    Note: Publications are displayed using Typst's built-in bibliography. 
    For custom APSA formatting with hanging indents, use the R chunk approach above.
  ]
}

//------------------------------------------------------------------------------
// Document Setup
//------------------------------------------------------------------------------

// Set document properties
#set document(
  title: "$name$ - CV", 
  author: "$name$"
)

// Typography settings
#set text(
  font: font-text,
  size: 11pt,
  lang: "en",
  fill: color-darkgray,
  fallback: true
)

// Paragraph settings
#set par(
  justify: true,
  leading: 0.65em
)

// Page settings
#set page(
  paper: "us-letter",
  margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
  footer: context [
    #set text(fill: gray, size: 8pt)
    #grid(
      columns: (1fr, 1fr, 1fr),
      align: (left, center, right),
      [Page #counter(page).display() of #counter(page).final().first()],
      [],
      [Revised #datetime.today().display("[month repr:long] [year]")]
    )
  ]
)

// Heading styles
#show heading.where(level: 1): it => section(it.body)

// Prevent orphaned headings - keep headings with following content
#show heading: it => {
  // Add page break avoidance for headings
  block(breakable: false, it)
  v(0.3em, weak: true)
}

// Link styling
#show link: set text(color-accent)

//------------------------------------------------------------------------------
// Header
//------------------------------------------------------------------------------

#align(left)[
  #pad(bottom: 5pt)[
    #block[
      #set text(
        size: 32pt,
        style: "normal",
        font: font-header,
      )
      #text(weight: "bold")[$firstname$]
      #text(weight: "bold")[$lastname$]
    ]
  ]
  
  #set block(above: 0.75em, below: 0.75em)
  #set text(color-darkgray, size: 12pt, weight: "regular")
  #block[$affiliation$]
  
  #v(0.5em)
  
  // Three-column contact layout like Heiss
  #set text(size: 9pt, weight: "regular", style: "normal", fill: color-darkgray)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5em,
    align: (left, left, left),
    [
      // Column 1: Address, Email, ORCID
      #fa-icon("location-dot") $address$ \
      #fa-icon("envelope") #link("mailto:$email$")[#text(fill: color-darkgray)[$email$]] \
      #fa-icon("orcid", font: "Font Awesome 6 Brands") #link("$orcidurl$")[#text(fill: color-darkgray)[$orcidhandle$]]
    ],
    [
      // Column 2: Phone, Website, LinkedIn  
      #h(2em) #fa-icon("phone") $phone$ \
      #h(2em) #fa-icon("earth-americas") #link("$websiteurl$")[#text(fill: color-darkgray)[$websitedisplay$]] \
      #h(2em) #fa-icon("linkedin", font: "Font Awesome 6 Brands") #link("$linkedin$")[#text(fill: color-darkgray)[$linkedinhandle$]]
    ],
    [
      // Column 3: X, GitHub, Google Scholar
      #h(-0.5em) #fa-icon("x-twitter", font: "Font Awesome 6 Brands") #link("$twitter$")[#text(fill: color-darkgray)[\@$twitterhandle$]] \
      #h(-0.5em) #fa-icon("github", font: "Font Awesome 6 Brands") #link("$github$")[#text(fill: color-darkgray)[$githubhandle$]] \
      #h(-0.5em) #ai-icon("google-scholar") #link("$google-scholar$")[#text(fill: color-darkgray)[$google-scholarhandle$]]
    ]
  )
]

#v(1em)

$body$