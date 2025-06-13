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
#let color-accent = rgb("#333333")

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
  h(0.1em)
  "L"
  h(-0.3em)
  text(size: 0.75em, baseline: -0.2em, "A")
  h(-0.1em)
  "T"
  h(-0.12em)
  text(size: 0.75em, baseline: 0.2em, "E")
  h(-0.08em)
  "X"
  h(0.1em)
}

// Simple TeX logo (Quarto-compatible)
#let TeX = {
  "T"
  h(-0.12em)
  text(size: 0.75em, baseline: 0.2em, "E")
  h(-0.08em)
  "X"
}

// Reference entry
#let reference-entry(
  name: "",
  title: "",
  subtitle: "",
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
      #if subtitle != "" [
        #linebreak()
        #subtitle
      ]
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
            subtitle: if "subtitle" in ref { ref.subtitle } else { "" },
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
            subtitle: if "subtitle" in ref { ref.subtitle } else { "" },
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
    size: 11pt,
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
#let justified-header(primary, secondary, amount: none) = {
  set block(
    above: 0.7em,
    below: 0.7em,
  )
  pad[
    #__justify_align[
      #set text(
        size: 11pt,
        weight: "bold",
        fill: color-darkgray,
      )
      #primary
      #if amount != none [
        #text(weight: "bold")[ (#amount)]
      ]
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 11pt,
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
  indent: false,
  amount: none
) = {
  let left-margin = if indent { 1em } else { 0em }
  
  pad(left: left-margin)[
    #justified-header(title, location, amount: amount)
    #secondary-justified-header(if organization != "" { organization } else { description }, dates)
    #if description != "" and organization != "" [
      #v(0.2em)
      #pad(
        left: 1em,
        text(size: 11pt, fill: color-gray)[
          - #description
        ]
      )
    ]
  ]
  
  if details.len() > 0 {
    v(0.3em)
    pad(left: left-margin)[
      #set text(
        size: 11pt,
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
  
  if coauthor-mark [
    #text(fill: color-accent)[⋆ ]
  ]
  
  if authors != "" [
    #text(weight: "medium")[#authors]#if title != "" [, ]
  ]
  
  if title != "" [
    "#title"#if venue != "" [, ]
  ]
  
  if venue != "" [
    #text(style: "italic", fill: color-gray)[#venue]
  ]
  
  if year != "" [
    #if venue != "" [ ]
    #text(fill: color-darkgray)[(#year)]
  ]
  
  if doi != "" [
    , doi: #link("https://doi.org/" + doi)[#text(fill: color-accent)[#doi]]
  ] else if url != "" [
    , #link(url)[#text(fill: color-accent)[link]]
  ]
  
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
  urls: (),
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
  set text(size: 11pt, fill: color-darknight)
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
  let parts = authors-str.split(regex(" and |, and | & "))
  let formatted-parts = ()
  
  for part in parts {
    let clean-part = part.trim()
    if clean-part.contains(bold-name) or bold-name.contains(clean-part) {
      formatted-parts.push(text(weight: "bold")[#clean-part])
    } else {
      formatted-parts.push(clean-part)
    }
  }
  
  formatted-parts.join(" and ")
}

// Function to format a single publication in APSA style
#let format-publication(
  entry,
  number: none,
  bold-name: "Cameron Wimpy",
  show-alphabetical: true
) = {
  set text(size: 10pt, fill: color-darknight)
  set par(leading: 0.65em, hanging-indent: 2em)
  
  let prefix = ""
  if number != none {
    prefix = str(number) + ". "
  }
  
  let citation = ""
  
  if "author" in entry {
    citation = citation + bold-author-name(str(entry.author), bold-name)
  }
  
  if "year" in entry {
    citation = citation + ". " + str(entry.year) + ". "
  } else {
    citation = citation + ". "
  }
  
  if entry.type == "article" or entry.type == "essay" {
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
    if "pages" in entry {
      citation = citation + ": " + str(entry.pages).replace("--", "–") + "."
    } else {
      citation = citation + "."
    }
  } else if entry.type == "incollection" {
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
      citation = citation + str(entry.address) + ": " + str(entry.publisher) + "."
    }
    if "pages" in entry {
      citation = citation + " " + str(entry.pages).replace("--", "–") + "."
    }
  } else if entry.type == "book" {
    if "title" in entry {
      citation = citation + text(style: "italic")[#str(entry.title)] + ". "
    }
    if "address" in entry and "publisher" in entry {
      citation = citation + str(entry.address) + ": " + str(entry.publisher) + "."
    }
  } else if entry.type == "inproceedings" or entry.type == "conference" {
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    citation = citation + "Paper presented at "
    if "booktitle" in entry {
      citation = citation + str(entry.booktitle)
    }
    if "address" in entry {
      citation = citation + ", " + str(entry.address) + "."
    } else {
      citation = citation + "."
    }
  } else if entry.type == "techreport" or entry.type == "misc" {
    if "title" in entry {
      citation = citation + "\"" + str(entry.title) + ".\" "
    }
    if "institution" in entry {
      citation = citation + str(entry.institution) + "."
    }
  }
  
  if show-alphabetical and "note" in entry and str(entry.note).contains("equal") {
    citation = citation + text(fill: color-accent, weight: "bold")[#super[\*]]
  }
  
  [#prefix#citation]
  
  v(0.4em)
}

// Function to process and display publications
#let display-publications(
  bib-file: "",
  categories: (),
  bold-name: "Cameron Wimpy",
  reverse-numbering: true
) = {
  let all-pubs = (
    (
      type: "article",
      author: "Cameron Wimpy and Guy D. Whitten",
      title: "What is and what may never be: Economic voting in developing democracies",
      journal: "Social Science Quarterly",
      year: "2017",
      volume: "98",
      number: "3",
      pages: "1099--1111",
      doi: "10.1111/ssqu.12444"
    ),
    (
      type: "incollection",
      author: "Cameron Wimpy and Marlette Jackson and Kenneth J. Meier",
      title: "Administrative capacity and health care in Africa: Path dependence as a contextual variable",
      booktitle: "Context and Government Performance: Public Management in Comparative Perspective",
      editor: "Amanda Rutherford and Claudia Avellaneda and Kenneth J. Meier",
      address: "Washington DC",
      publisher: "Georgetown University Press",
      year: "2017",
      pages: "27--48"
    ),
    (
      type: "article",
      author: "Cameron Wimpy",
      title: "Political failure and bureaucratic potential in Africa",
      journal: "Journal of Policy Studies",
      year: "2021",
      volume: "36",
      number: "4",
      pages: "15--25",
      doi: "10.52372/kjps36402"
    ),
  )
  
  let sorted-pubs = all-pubs.sorted(key: (pub) => {
    let year = if "year" in pub { int(str(pub.year)) } else { 0 }
    let title = if "title" in pub { str(pub.title) } else { "" }
    (-year, title)
  })
  
  if categories.len() > 0 {
    for category in categories {
      let cat-type = category.at(0)
      let cat-title = category.at(1)
      
      let cat-pubs = sorted-pubs.filter(pub => {
        if cat-type == pub.type { true } else { false }
      })
      
      if cat-pubs.len() > 0 {
        text(size: 11pt, weight: "bold", fill: color-darkgray)[#cat-title]
        v(0.3em)
        
        for (i, pub) in cat-pubs.enumerate() {
          let num = if reverse-numbering { cat-pubs.len() - i } else { i + 1 }
          format-publication(pub, number: num, bold-name: bold-name)
        }
        
        v(0.5em)
      }
    }
  } else {
    for (i, pub) in sorted-pubs.enumerate() {
      let num = if reverse-numbering { sorted-pubs.len() - i } else { i + 1 }
      format-publication(pub, number: num, bold-name: bold-name)
    }
  }
}

// Function to process and display publications from data
#let display-publications-from-data(
  publications: (),
  categories: (),
  bold-name: "Cameron Wimpy",
  reverse-numbering: true
) = {
  let all-pubs = if type(publications) == array { publications } else { () }
  
  if all-pubs.len() == 0 {
    text(fill: red)[Error: No publications data received. Check R chunk output.]
    return
  }
  
  let sorted-pubs = all-pubs.sorted(key: (pub) => {
    let year = if "year" in pub { int(str(pub.year)) } else { 0 }
    let title = if "title" in pub { str(pub.title) } else { "" }
    (-year, title)
  })
  
  if categories.len() > 0 {
    for category in categories {
      let cat-type = category.at(0)
      let cat-title = category.at(1)
      
      let cat-pubs = sorted-pubs.filter(pub => {
        if cat-type == pub.type { true } else { false }
      })
      
      if cat-pubs.len() > 0 {
        text(size: 11pt, weight: "bold", fill: color-darkgray)[#cat-title]
        v(0.3em)
        
        for (i, pub) in cat-pubs.enumerate() {
          let num = if reverse-numbering { cat-pubs.len() - i } else { i + 1 }
          format-publication(pub, number: num, bold-name: bold-name)
        }
        
        v(0.5em)
      }
    }
  } else {
    for (i, pub) in sorted-pubs.enumerate() {
      let num = if reverse-numbering { sorted-pubs.len() - i } else { i + 1 }
      format-publication(pub, number: num, bold-name: bold-name)
    }
  }
}

// Function to display publications from a .bib file
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
  
  set bibliography(style: "apa", title: none)
  bibliography(bib-file)
  
  v(1em)
  text(size: 9pt, fill: color-gray, style: "italic")[
    Note: Publications are displayed using Typst's built-in bibliography. 
    For custom APSA formatting with hanging indents, use the R chunk approach.
  ]
}

//------------------------------------------------------------------------------
// Document Setup
//------------------------------------------------------------------------------

#set document(
  title: "$name$ - CV", 
  author: "$name$"
)

#set text(
  font: font-text,
  size: 11pt,
  lang: "en",
  fill: color-darkgray,
  fallback: true
)

#set par(
  justify: true,
  leading: 0.65em
)

#set page(
  paper: "us-letter",
  margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
  footer: context [
    #set text(fill: color-lightgray, size: 8pt)
    #grid(
      columns: (1fr, 1fr, 1fr),
      align(left)[Revised #datetime.today().display("[month repr:long] [year]")],
      align(center)[Cameron Wimpy · CV],
      align(right)[#counter(page).display("1 / 1", both: true)]
    )
  ]
)

#show heading.where(level: 1): it => section(it.body)

#show heading: it => {
  block(breakable: false, it)
  v(0.3em, weak: true)
}

#show link: it => {
  set text(fill: color-accent)
  it
}

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
  
  #set text(size: 9pt, weight: "regular", style: "normal", fill: color-darkgray)
  #grid(
    columns: (1fr, 1fr, 1fr),
    column-gutter: 0.5em,
    align: (left, left, left),
    [
      #fa-icon("location-dot") $address$ \
      #fa-icon("envelope") #link("mailto:$email$")[#text(fill: color-darkgray)[$email$]] \
      #fa-icon("orcid", font: "Font Awesome 6 Brands") #link("$orcidurl$")[#text(fill: color-darkgray)[$orcidhandle$]]
    ],
    [
      #h(2em) #fa-icon("phone") $phone$ \
      #h(2em) #fa-icon("earth-americas") #link("$websiteurl$")[#text(fill: color-darkgray)[$websitedisplay$]] \
      #h(2em) #fa-icon("linkedin", font: "Font Awesome 6 Brands") #link("$linkedin$")[#text(fill: color-darkgray)[$linkedinhandle$]]
    ],
    [
      #h(-0.5em) #fa-icon("x-twitter", font: "Font Awesome 6 Brands") #link("$twitter$")[#text(fill: color-darkgray)[\@$twitterhandle$]] \
      #h(-0.5em) #fa-icon("github", font: "Font Awesome 6 Brands") #link("$github$")[#text(fill: color-darkgray)[$githubhandle$]] \
      #h(-0.5em) #ai-icon("google-scholar") #link("$google-scholar$")[#text(fill: color-darkgray)[$google-scholarhandle$]]
    ]
  )
]

#v(1em)

$body$