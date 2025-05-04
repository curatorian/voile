alias Voile.Repo
alias Voile.Schema.Metadata
alias Voile.Schema.Metadata.Property
alias Voile.Schema.Metadata.ResourceClass

vocabulary_1 = Repo.get!(Metadata.Vocabulary, 1)
vocabulary_2 = Repo.get!(Metadata.Vocabulary, 2)
vocabulary_3 = Repo.get!(Metadata.Vocabulary, 3)
vocabulary_4 = Repo.get!(Metadata.Vocabulary, 4)

resource_class = [
  %{
    information: "A resource that acts or has the power to act.",
    label: "Agent",
    local_name: "Agent",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A group of agents.",
    label: "Agent Class",
    local_name: "AgentClass",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A book, article, or other documentary resource.",
    label: "Bibliographic Resource",
    local_name: "BibliographicResource",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A digital resource format.",
    label: "File Format",
    local_name: "FileFormat",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A rate at which something recurs.",
    label: "Frequency",
    local_name: "Frequency",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "The extent or range of judicial, law enforcement, or other authority.",
    label: "Jurisdiction",
    local_name: "Jurisdiction",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A legal document giving official permission to do something with a Resource.",
    label: "License Document",
    local_name: "LicenseDocument",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A system of signs, symbols, sounds, gestures, or rules used in communication.",
    label: "Linguistic System",
    local_name: "LinguisticSystem",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A spatial region or named place.",
    label: "Location",
    local_name: "Location",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A location, period of time, or jurisdiction.",
    label: "Location, Period, or Jurisdiction",
    local_name: "LocationPeriodOrJurisdiction",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A file format or physical medium.",
    label: "Media Type",
    local_name: "MediaType",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A media type or extent.",
    label: "Media Type or Extent",
    local_name: "MediaTypeOrExtent",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A process that is used to engender knowledge, attitudes, and skills.",
    label: "Method of Instruction",
    local_name: "MethodOfInstruction",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A method by which resources are added to a collection.",
    label: "Method of Accrual",
    local_name: "MethodOfAccrual",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "An interval of time that is named or defined by its start and end dates.",
    label: "Period of Time",
    local_name: "PeriodOfTime",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A physical material or carrier.",
    label: "Physical Medium",
    local_name: "PhysicalMedium",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A material thing.",
    label: "Physical Resource",
    local_name: "PhysicalResource",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information:
      "A plan or course of action by an authority, intended to influence and determine decisions, actions, and other matters.",
    label: "Policy",
    local_name: "Policy",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information:
      "A statement of any changes in ownership and custody of a resource since its creation that are significant for its authenticity, integrity, and interpretation.",
    label: "Provenance Statement",
    local_name: "ProvenanceStatement",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information:
      "A statement about the intellectual property rights (IPR) held in or over a Resource, a legal document giving official permission to do something with a resource, or a statement about access rights.",
    label: "Rights Statement",
    local_name: "RightsStatement",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "A dimension or extent, or a time taken to play or execute.",
    label: "Size or Duration",
    local_name: "SizeOrDuration",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information:
      "A basis for comparison; a reference point against which other things can be evaluated.",
    label: "Standard",
    local_name: "Standard",
    owner_id: nil,
    vocabulary_id: 1
  },
  %{
    information: "An aggregation of resources.",
    label: "Collection",
    local_name: "Collection",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "Data encoded in a defined structure.",
    label: "Dataset",
    local_name: "Dataset",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A non-persistent, time-based occurrence.",
    label: "Event",
    local_name: "Event",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A visual representation other than text.",
    label: "Image",
    local_name: "Image",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information:
      "A resource requiring interaction from the user to be understood, executed, or experienced.",
    label: "Interactive Resource",
    local_name: "InteractiveResource",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A system that provides one or more functions.",
    label: "Service",
    local_name: "Service",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A computer program in source or compiled form.",
    label: "Software",
    local_name: "Software",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A resource primarily intended to be heard.",
    label: "Sound",
    local_name: "Sound",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A resource consisting primarily of words for reading.",
    label: "Text",
    local_name: "Text",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "An inanimate, three-dimensional object or substance.",
    label: "Physical Object",
    local_name: "PhysicalObject",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A static visual representation.",
    label: "Still Image",
    local_name: "StillImage",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information:
      "A series of visual representations imparting an impression of motion when shown in succession.",
    label: "Moving Image",
    local_name: "MovingImage",
    owner_id: nil,
    vocabulary_id: 2
  },
  %{
    information: "A scholarly academic article, typically published in a journal.",
    label: "Academic Article",
    local_name: "AcademicArticle",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A written composition in prose, usually nonfiction, on a specific topic, forming an independent part of a book or other publication, as a newspaper or magazine.",
    label: "Article",
    local_name: "Article",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "An audio document; aka record.",
    label: "audio document",
    local_name: "AudioDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "An audio-visual document; film, video, and so forth.",
    label: "audio-visual document",
    local_name: "AudioVisualDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "Draft legislation presented for discussion to a legal body.",
    label: "Bill",
    local_name: "Bill",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A written or printed work of fiction or nonfiction, usually on sheets of paper fastened or bound together within covers.",
    label: "Book",
    local_name: "Book",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A section of a book.",
    label: "Book Section",
    local_name: "BookSection",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A written argument submitted to a court.",
    label: "Brief",
    local_name: "Brief",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A chapter of a book.",
    label: "Chapter",
    local_name: "Chapter",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A collection of statutes.",
    label: "Code",
    local_name: "Code",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A document that simultaneously contains other documents.",
    label: "Collected Document",
    local_name: "CollectedDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A collection of Documents or Collections",
    label: "Collection",
    local_name: "Collection",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A meeting for consultation or discussion.",
    label: "Conference",
    local_name: "Conference",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A collection of legal cases.",
    label: "Court Reporter",
    local_name: "CourtReporter",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document (noun) is a bounded physical representation of body of information designed with the capacity (and usually intent) to communicate. A document may manifest symbolic, diagrammatic or sensory-representational information.",
    label: "Document",
    local_name: "Document",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "a distinct part of a larger document or collected document.",
    label: "document part",
    local_name: "DocumentPart",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "The status of the publication of a document.",
    label: "Document Status",
    local_name: "DocumentStatus",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "An edited book.",
    label: "Edited Book",
    local_name: "EditedBook",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A written communication addressed to a person or organization and transmitted electronically.",
    label: "Email",
    local_name: "Email",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: nil,
    label: "Event",
    local_name: "Event",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A passage selected from a larger work.",
    label: "Excerpt",
    local_name: "Excerpt",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "aka movie.",
    label: "Film",
    local_name: "Film",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "An instance or a session in which testimony and arguments are presented, esp. before an official, as a judge in a lawsuit.",
    label: "Hearing",
    local_name: "Hearing",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A document that presents visual or diagrammatic information.",
    label: "Image",
    local_name: "Image",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A formalized discussion between two or more people.",
    label: "Interview",
    local_name: "Interview",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "something that is printed or published and distributed, esp. a given number of a periodical",
    label: "Issue",
    local_name: "Issue",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A periodical of scholarly journal Articles.",
    label: "Journal",
    local_name: "Journal",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A document accompanying a legal case.",
    label: "Legal Case Document",
    local_name: "LegalCaseDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document containing an authoritative determination (as a decree or judgment) made after consideration of facts or law.",
    label: "Decision",
    local_name: "LegalDecision",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A legal document; for example, a court decision, a brief, and so forth.",
    label: "Legal Document",
    local_name: "LegalDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A legal document proposing or enacting a law or a group of laws.",
    label: "Legislation",
    local_name: "Legislation",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A written or printed communication addressed to a person or organization and usually transmitted by mail.",
    label: "Letter",
    local_name: "Letter",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A periodical of magazine Articles. A magazine is a publication that is issued periodically, usually bound in a paper cover, and typically contains essays, stories, poems, etc., by many writers, and often photographs and drawings, frequently specializing in a particular subject or area, as hobbies, news, or sports.",
    label: "Magazine",
    local_name: "Magazine",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A small reference book, especially one giving instructions.",
    label: "Manual",
    local_name: "Manual",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "An unpublished Document, which may also be submitted to a publisher for publication.",
    label: "Manuscript",
    local_name: "Manuscript",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A graphical depiction of geographic features.",
    label: "Map",
    local_name: "Map",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A loose, thematic, collection of Documents, often Books.",
    label: "Multivolume Book",
    local_name: "MultiVolumeBook",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A periodical of documents, usually issued daily or weekly, containing current news, editorials, feature articles, and usually advertising.",
    label: "Newspaper",
    local_name: "Newspaper",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "Notes or annotations about a resource.",
    label: "Note",
    local_name: "Note",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document describing the exclusive right granted by a government to an inventor to manufacture, use, or sell an invention for a certain number of years.",
    label: "Patent",
    local_name: "Patent",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A public performance.",
    label: "Performance",
    local_name: "Performance",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A group of related documents issued at regular intervals.",
    label: "Periodical",
    local_name: "Periodical",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A communication between an agent and one or more specific recipients.",
    label: "Personal Communication",
    local_name: "PersonalCommunication",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A personal communication manifested in some document.",
    label: "Personal Communication Document",
    local_name: "PersonalCommunicationDocument",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A compilation of documents published from an event, such as a conference.",
    label: "Proceedings",
    local_name: "Proceedings",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "An excerpted collection of words.",
    label: "Quote",
    local_name: "Quote",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document that presents authoritative reference information, such as a dictionary or encylopedia .",
    label: "Reference Source",
    local_name: "ReferenceSource",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document describing an account or statement describing in detail an event, situation, or the like, usually as the result of observation, inquiry, etc..",
    label: "Report",
    local_name: "Report",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A loose, thematic, collection of Documents, often Books.",
    label: "Series",
    local_name: "Series",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A slide in a slideshow",
    label: "Slide",
    local_name: "Slide",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A presentation of a series of slides, usually presented in front of an audience with written text and images.",
    label: "Slideshow",
    local_name: "Slideshow",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A document describing a standard",
    label: "Standard",
    local_name: "Standard",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A bill enacted into law.",
    label: "Statute",
    local_name: "Statute",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A document created to summarize research findings associated with the completion of an academic degree.",
    label: "Thesis",
    local_name: "Thesis",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "The academic degree of a Thesis",
    label: "Thesis degree",
    local_name: "ThesisDegree",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A web page is an online document available (at least initially) on the world wide web. A web page is written first and foremost to appear on the web, as distinct from other online resources such as books, manuscripts or audio documents which use the web primarily as a distribution mechanism alongside other more traditional methods such as print.",
    label: "Webpage",
    local_name: "Webpage",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information: "A group of Webpages accessible on the Web.",
    label: "Website",
    local_name: "Website",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A seminar, discussion group, or the like, that emphasizes zxchange of ideas and the demonstration and application of techniques, skills, etc.",
    label: "Workshop",
    local_name: "Workshop",
    owner_id: nil,
    vocabulary_id: 3
  },
  %{
    information:
      "A foaf:LabelProperty is any RDF property with texual values that serve as labels.",
    label: "Label Property",
    local_name: "LabelProperty",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "A person.",
    label: "Person",
    local_name: "Person",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "A document.",
    label: "Document",
    local_name: "Document",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An organization.",
    label: "Organization",
    local_name: "Organization",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "A class of Agents.",
    label: "Group",
    local_name: "Group",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An agent (eg. person, group, software or physical artifact).",
    label: "Agent",
    local_name: "Agent",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "A project (a collective endeavour of some kind).",
    label: "Project",
    local_name: "Project",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An image.",
    label: "Image",
    local_name: "Image",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "A personal profile RDF document.",
    label: "PersonalProfileDocument",
    local_name: "PersonalProfileDocument",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An online account.",
    label: "Online Account",
    local_name: "OnlineAccount",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An online gaming account.",
    label: "Online Gaming Account",
    local_name: "OnlineGamingAccount",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An online e-commerce account.",
    label: "Online E-commerce Account",
    local_name: "OnlineEcommerceAccount",
    owner_id: nil,
    vocabulary_id: 4
  },
  %{
    information: "An online chat account.",
    label: "Online Chat Account",
    local_name: "OnlineChatAccount",
    owner_id: nil,
    vocabulary_id: 4
  }
]

for resource <- resource_class do
  %ResourceClass{
    label: resource[:label],
    local_name: resource[:local_name],
    information: resource[:information],
    vocabulary_id:
      case resource[:vocabulary_id] do
        1 -> vocabulary_1.id
        2 -> vocabulary_2.id
        3 -> vocabulary_3.id
        4 -> vocabulary_4.id
        _ -> 1
      end
  }
  |> Repo.insert!()
end

properties_list = [
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "title",
    label: "Title",
    comment: "A name given to the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "creator",
    label: "Creator",
    comment: "An entity primarily responsible for making the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "subject",
    label: "Subject",
    comment: "The topic of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "description",
    label: "Description",
    comment: "An account of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "publisher",
    label: "Publisher",
    comment: "An entity responsible for making the resource available."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "contributor",
    label: "Contributor",
    comment: "An entity responsible for making contributions to the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "date",
    label: "Date",
    comment:
      "A point or period of time associated with an event in the lifecycle of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "type",
    label: "Type",
    comment: "The nature or genre of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "format",
    label: "Format",
    comment: "The file format, physical medium, or dimensions of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "identifier",
    label: "Identifier",
    comment: "An unambiguous reference to the resource within a given context."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "source",
    label: "Source",
    comment: "A related resource from which the described resource is derived."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "language",
    label: "Language",
    comment: "A language of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "relation",
    label: "Relation",
    comment: "A related resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "coverage",
    label: "Coverage",
    comment:
      "The spatial or temporal topic of the resource, the spatial applicability of the resource, or the jurisdiction under which the resource is relevant."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "rights",
    label: "Rights",
    comment: "Information about rights held in and over the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "audience",
    label: "Audience",
    comment: "A class of entity for whom the resource is intended or useful."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "alternative",
    label: "Alternative Title",
    comment: "An alternative name for the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "tableOfContents",
    label: "Table Of Contents",
    comment: "A list of subunits of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "abstract",
    label: "Abstract",
    comment: "A summary of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "created",
    label: "Date Created",
    comment: "Date of creation of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "valid",
    label: "Date Valid",
    comment: "Date (often a range) of validity of a resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "available",
    label: "Date Available",
    comment: "Date (often a range) that the resource became or will become available."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "issued",
    label: "Date Issued",
    comment: "Date of formal issuance (e.g., publication) of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "modified",
    label: "Date Modified",
    comment: "Date on which the resource was changed."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "extent",
    label: "Extent",
    comment: "The size or duration of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "medium",
    label: "Medium",
    comment: "The material or physical carrier of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isVersionOf",
    label: "Is Version Of",
    comment:
      "A related resource of which the described resource is a version, edition, or adaptation."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "hasVersion",
    label: "Has Version",
    comment:
      "A related resource that is a version, edition, or adaptation of the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isReplacedBy",
    label: "Is Replaced By",
    comment: "A related resource that supplants, displaces, or supersedes the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "replaces",
    label: "Replaces",
    comment:
      "A related resource that is supplanted, displaced, or superseded by the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isRequiredBy",
    label: "Is Required By",
    comment:
      "A related resource that requires the described resource to support its function, delivery, or coherence."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "requires",
    label: "Requires",
    comment:
      "A related resource that is required by the described resource to support its function, delivery, or coherence."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isPartOf",
    label: "Is Part Of",
    comment:
      "A related resource in which the described resource is physically or logically included."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "hasPart",
    label: "Has Part",
    comment:
      "A related resource that is included either physically or logically in the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isReferencedBy",
    label: "Is Referenced By",
    comment:
      "A related resource that references, cites, or otherwise points to the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "references",
    label: "References",
    comment:
      "A related resource that is referenced, cited, or otherwise pointed to by the described resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "isFormatOf",
    label: "Is Format Of",
    comment:
      "A related resource that is substantially the same as the described resource, but in another format."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "hasFormat",
    label: "Has Format",
    comment:
      "A related resource that is substantially the same as the pre-existing described resource, but in another format."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "conformsTo",
    label: "Conforms To",
    comment: "An established standard to which the described resource conforms."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "spatial",
    label: "Spatial Coverage",
    comment: "Spatial characteristics of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "temporal",
    label: "Temporal Coverage",
    comment: "Temporal characteristics of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "mediator",
    label: "Mediator",
    comment:
      "An entity that mediates access to the resource and for whom the resource is intended or useful."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "dateAccepted",
    label: "Date Accepted",
    comment: "Date of acceptance of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "dateCopyrighted",
    label: "Date Copyrighted",
    comment: "Date of copyright."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "dateSubmitted",
    label: "Date Submitted",
    comment: "Date of submission of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "educationLevel",
    label: "Audience Education Level",
    comment:
      "A class of entity, defined in terms of progression through an educational or training context, for which the described resource is intended."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "accessRights",
    label: "Access Rights",
    comment:
      "Information about who can access the resource or an indication of its security status."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "bibliographicCitation",
    label: "Bibliographic Citation",
    comment: "A bibliographic reference for the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "license",
    label: "License",
    comment: "A legal document giving official permission to do something with the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "rightsHolder",
    label: "Rights Holder",
    comment: "A person or organization owning or managing rights over the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "provenance",
    label: "Provenance",
    comment:
      "A statement of any changes in ownership and custody of the resource since its creation that are significant for its authenticity, integrity, and interpretation."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "instructionalMethod",
    label: "Instructional Method",
    comment:
      "A process, used to engender knowledge, attitudes and skills, that the described resource is designed to support."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "accrualMethod",
    label: "Accrual Method",
    comment: "The method by which items are added to a collection."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "accrualPeriodicity",
    label: "Accrual Periodicity",
    comment: "The frequency with which items are added to a collection."
  },
  %{
    owner_id: nil,
    vocabulary_id: 1,
    local_name: "accrualPolicy",
    label: "Accrual Policy",
    comment: "The policy governing the addition of items to a collection."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "affirmedBy",
    label: "affirmedBy",
    comment: "A legal decision that affirms a ruling."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "annotates",
    label: "annotates",
    comment: "Critical or explanatory note for a Document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "authorList",
    label: "list of authors",
    comment:
      "An ordered list of authors. Normally, this list is seen as a priority list that order authors by importance."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "citedBy",
    label: "cited by",
    comment: "Relates a document to another document that cites the\nfirst document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "cites",
    label: "cites",
    comment:
      "Relates a document to another document that is cited\nby the first document as reference, comment, review, quotation or for\nanother purpose."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "contributorList",
    label: "list of contributors",
    comment:
      "An ordered list of contributors. Normally, this list is seen as a priority list that order contributors by importance."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "court",
    label: "court",
    comment:
      "A court associated with a legal document; for example, that which issues a decision."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "degree",
    label: "degree",
    comment: "The thesis degree."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "director",
    label: "director",
    comment: "A Film director."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "distributor",
    label: "distributor",
    comment: "Distributor of a document or a collection of documents."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "editor",
    label: "editor",
    comment:
      "A person having managerial and sometimes policy-making responsibility for the editorial part of a publishing firm or of a newspaper, magazine, or other publication."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "editorList",
    label: "list of editors",
    comment:
      "An ordered list of editors. Normally, this list is seen as a priority list that order editors by importance."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "interviewee",
    label: "interviewee",
    comment: "An agent that is interviewed by another agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "interviewer",
    label: "interviewer",
    comment: "An agent that interview another agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "issuer",
    label: "issuer",
    comment:
      "An entity responsible for issuing often informally published documents such as press releases, reports, etc."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "organizer",
    label: "organizer",
    comment:
      "The organizer of an event; includes conference organizers, but also government agencies or other bodies that are responsible for conducting hearings."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "owner",
    label: "owner",
    comment: "Owner of a document or a collection of documents."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "performer",
    label: "performer",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "presentedAt",
    label: "presented at",
    comment: "Relates a document to an event; for example, a paper to a conference."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "presents",
    label: "presents",
    comment: "Relates an event to associated documents; for example, conference to a paper."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "producer",
    label: "producer",
    comment: "Producer of a document or a collection of documents."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "recipient",
    label: "recipient",
    comment: "An agent that receives a communication document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "reproducedIn",
    label: "reproducedIn",
    comment: "The resource in which another resource is reproduced."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "reversedBy",
    label: "reversedBy",
    comment: "A legal decision that reverses a ruling."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "reviewOf",
    label: "review of",
    comment: "Relates a review document to a reviewed thing (resource, item, etc.)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "status",
    label: "status",
    comment: "The publication status of (typically academic) content."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "subsequentLegalDecision",
    label: "subsequentLegalDecision",
    comment:
      "A legal decision on appeal that takes action on a case (affirming it, reversing it, etc.)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "transcriptOf",
    label: "transcript of",
    comment: "Relates a document to some transcribed original."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "translationOf",
    label: "translation of",
    comment: "Relates a translated document to the original document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "translator",
    label: "translator",
    comment: "A person who translates written document from one language to another."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "abstract",
    label: "abstract",
    comment: "A summary of the resource."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "argued",
    label: "date argued",
    comment: "The date on which a legal case is argued before a court. Date is of format xsd:date"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "asin",
    label: "asin",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "chapter",
    label: "chapter",
    comment: "An chapter number"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "coden",
    label: "coden",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "content",
    label: "content",
    comment:
      "This property is for a plain-text rendering of the content of a Document. While the plain-text content of an entire document could be described by this property."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "doi",
    label: "doi",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "eanucc13",
    label: "eanucc13",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "edition",
    label: "edition",
    comment:
      "The name defining a special edition of a document. Normally its a literal value composed of a version number and words."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "eissn",
    label: "eissn",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "gtin14",
    label: "gtin14",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "handle",
    label: "handle",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "identifier",
    label: "identifier",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "isbn",
    label: "isbn",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "isbn10",
    label: "isbn10",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "isbn13",
    label: "isbn13",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "issn",
    label: "issn",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "issue",
    label: "issue",
    comment: "An issue number"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "lccn",
    label: "lccn",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "locator",
    label: "locator",
    comment:
      "A description (often numeric) that locates an item within a containing document or collection."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "numPages",
    label: "number of pages",
    comment: "The number of pages contained in a document"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "numVolumes",
    label: "number of volumes",
    comment:
      "The number of volumes contained in a collection of documents (usually a series, periodical, etc.)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "number",
    label: "number",
    comment: "A generic item or document number. Not to be confused with issue number."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "oclcnum",
    label: "oclcnum",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "pageEnd",
    label: "page end",
    comment: "Ending page number within a continuous page range."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "pageStart",
    label: "page start",
    comment: "Starting page number within a continuous page range."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "pages",
    label: "pages",
    comment:
      "A string of non-contiguous page spans that locate a Document within a Collection. Example: 23-25, 34, 54-56. For continuous page ranges, use the pageStart and pageEnd properties."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "pmid",
    label: "pmid",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "prefixName",
    label: "prefix name",
    comment: "The prefix of a name"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "section",
    label: "section",
    comment: "A section number"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "shortDescription",
    label: "shortDescription",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "shortTitle",
    label: "short title",
    comment: "The abbreviation of a title."
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "sici",
    label: "sici",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "suffixName",
    label: "suffix name",
    comment: "The suffix of a name"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "upc",
    label: "upc",
    comment: nil
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "uri",
    label: "uri",
    comment: "Universal Resource Identifier of a document"
  },
  %{
    owner_id: nil,
    vocabulary_id: 3,
    local_name: "volume",
    label: "volume",
    comment: "A volume number"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "mbox",
    label: "personal mailbox",
    comment:
      "A  personal mailbox, ie. an Internet mailbox associated with exactly one owner, the first owner of this mailbox. This is a 'static inverse functional property', in that  there is (across time and change) at most one individual that ever has any particular value for foaf:mbox."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "mbox_sha1sum",
    label: "sha1sum of a personal mailbox URI name",
    comment:
      "The sha1sum of the URI of an Internet mailbox associated with exactly one owner, the  first owner of the mailbox."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "gender",
    label: "gender",
    comment: "The gender of this Agent (typically but not necessarily 'male' or 'female')."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "geekcode",
    label: "geekcode",
    comment: "A textual geekcode for this person, see http:\/\/www.geekcode.com\/geek.html"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "dnaChecksum",
    label: "DNA checksum",
    comment: "A checksum for the DNA of some thing. Joke."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "sha1",
    label: "sha1sum (hex)",
    comment: "A sha1sum hash, in hex."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "based_near",
    label: "based near",
    comment: "A location that something is based near, for some broadly human notion of near."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "title",
    label: "title",
    comment: "Title (Mr, Mrs, Ms, Dr. etc)"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "nick",
    label: "nickname",
    comment:
      "A short informal nickname characterising an agent (includes login identifiers, IRC and other chat nicknames)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "jabberID",
    label: "jabber ID",
    comment: "A jabber ID for something."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "aimChatID",
    label: "AIM chat ID",
    comment: "An AIM chat ID"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "skypeID",
    label: "Skype ID",
    comment: "A Skype ID"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "icqChatID",
    label: "ICQ chat ID",
    comment: "An ICQ chat ID"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "yahooChatID",
    label: "Yahoo chat ID",
    comment: "A Yahoo chat ID"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "msnChatID",
    label: "MSN chat ID",
    comment: "An MSN chat ID"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "name",
    label: "name",
    comment: "A name for some thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "firstName",
    label: "firstName",
    comment: "The first name of a person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "lastName",
    label: "lastName",
    comment: "The last name of a person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "givenName",
    label: "Given name",
    comment: "The given name of some person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "givenname",
    label: "Given name",
    comment: "The given name of some person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "surname",
    label: "Surname",
    comment: "The surname of some person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "family_name",
    label: "family_name",
    comment: "The family name of some person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "familyName",
    label: "familyName",
    comment: "The family name of some person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "phone",
    label: "phone",
    comment:
      "A phone,  specified using fully qualified tel: URI scheme (refs: http:\/\/www.w3.org\/Addressing\/schemes.html#tel)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "homepage",
    label: "homepage",
    comment: "A homepage for some thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "weblog",
    label: "weblog",
    comment: "A weblog of some thing (whether person, group, company etc.)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "openid",
    label: "openid",
    comment: "An OpenID for an Agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "tipjar",
    label: "tipjar",
    comment: "A tipjar document for this agent, describing means for payment and reward."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "plan",
    label: "plan",
    comment: "A .plan comment, in the tradition of finger and '.plan' files."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "made",
    label: "made",
    comment: "Something that was made by this agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "maker",
    label: "maker",
    comment: "An agent that  made this thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "img",
    label: "image",
    comment:
      "An image that can be used to represent some thing (ie. those depictions which are particularly representative of something, eg. one's photo on a homepage)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "depiction",
    label: "depiction",
    comment: "A depiction of some thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "depicts",
    label: "depicts",
    comment: "A thing depicted in this representation."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "thumbnail",
    label: "thumbnail",
    comment: "A derived thumbnail image."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "myersBriggs",
    label: "myersBriggs",
    comment: "A Myers Briggs (MBTI) personality classification."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "workplaceHomepage",
    label: "workplace homepage",
    comment: "A workplace homepage of some person; the homepage of an organization they work for."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "workInfoHomepage",
    label: "work info homepage",
    comment: "A work info homepage of some person; a page about their work for some organization."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "schoolHomepage",
    label: "schoolHomepage",
    comment: "A homepage of a school attended by the person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "knows",
    label: "knows",
    comment:
      "A person known by this person (indicating some level of reciprocated interaction between the parties)."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "interest",
    label: "interest",
    comment: "A page about a topic of interest to this person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "topic_interest",
    label: "topic_interest",
    comment: "A thing of interest to this person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "publications",
    label: "publications",
    comment: "A link to the publications of this person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "currentProject",
    label: "current project",
    comment: "A current project this person works on."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "pastProject",
    label: "past project",
    comment: "A project this person has previously worked on."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "fundedBy",
    label: "funded by",
    comment: "An organization funding a project or person."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "logo",
    label: "logo",
    comment: "A logo representing some thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "topic",
    label: "topic",
    comment: "A topic of some page or document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "primaryTopic",
    label: "primary topic",
    comment: "The primary topic of some page or document."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "focus",
    label: "focus",
    comment: "The underlying or 'focal' entity associated with some SKOS-described concept."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "isPrimaryTopicOf",
    label: "is primary topic of",
    comment: "A document that this thing is the primary topic of."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "page",
    label: "page",
    comment: "A page or document about this thing."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "theme",
    label: "theme",
    comment: "A theme."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "account",
    label: "account",
    comment: "Indicates an account held by this agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "holdsAccount",
    label: "account",
    comment: "Indicates an account held by this agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "accountServiceHomepage",
    label: "account service homepage",
    comment: "Indicates a homepage of the service provide for this online account."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "accountName",
    label: "account name",
    comment: "Indicates the name (identifier) associated with this online account."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "member",
    label: "member",
    comment: "Indicates a member of a Group"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "membershipClass",
    label: "membershipClass",
    comment: "Indicates the class of individuals that are a member of a Group"
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "birthday",
    label: "birthday",
    comment: "The birthday of this Agent, represented in mm-dd string form, eg. '12-31'."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "age",
    label: "age",
    comment: "The age in years of some agent."
  },
  %{
    owner_id: nil,
    vocabulary_id: 4,
    local_name: "status",
    label: "status",
    comment:
      "A string expressing what the user is happy for the general public (normally) to know about their current activity."
  }
]

for property <- properties_list do
  %Property{
    owner_id: property[:owner_id],
    vocabulary_id:
      case property[:vocabulary_id] do
        1 -> vocabulary_1.id
        2 -> vocabulary_2.id
        3 -> vocabulary_3.id
        4 -> vocabulary_4.id
      end,
    local_name: property[:local_name],
    label: property[:label],
    information: property[:c]
  }
  |> Repo.insert!()
end
