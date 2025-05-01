alias Voile.Repo
alias Voile.Schema.Master
alias Voile.Schema.Master.Creator

creator_list = [
  %{
    id: 1,
    type: "Person",
    creator_name: "Valade, Janet",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    id: 2,
    creator_name: "Siever, Ellen",
    creator_contact: nil,
    affiliation: "University of Washington"
  },
  %{
    id: 3,
    creator_name: "Love, Robert",
    creator_contact: nil,
    affiliation: "University of North Carolina, Chapel Hill"
  },
  %{
    id: 4,
    creator_name: "Robbins, Arnold",
    creator_contact: nil,
    affiliation: "University of Johns Hopkins"
  },
  %{
    id: 5,
    creator_name: "Figgins, Stephen",
    creator_contact: nil,
    affiliation: "University North Carolina, Chapel Hill"
  },
  %{
    id: 6,
    creator_name: "Weber, Aaron",
    creator_contact: nil,
    affiliation: "University Emory"
  },
  %{
    id: 7,
    creator_name: "Kofler, Michael",
    creator_contact: nil,
    affiliation: "University Yale"
  },
  %{
    id: 8,
    creator_name: "Kramer, David",
    creator_contact: nil,
    affiliation: "University Loyola Marymount"
  },
  %{
    id: 9,
    creator_name: "Raymond, Eric",
    creator_contact: nil,
    affiliation: "University Massachusetts, Amherst"
  },
  %{
    id: 10,
    creator_name: "Fogel, Karl",
    creator_contact: nil,
    affiliation: "University San Francisco State"
  },
  %{
    id: 11,
    creator_name: "Douglas, Korry",
    creator_contact: nil,
    affiliation: "University Denver"
  },
  %{
    id: 12,
    creator_name: "Douglas, Susan",
    creator_contact: nil,
    affiliation: "University Kent State"
  },
  %{
    id: 13,
    creator_name: "Shklar, Leon",
    creator_contact: nil,
    affiliation: "University Georgia Tech"
  },
  %{
    id: 14,
    creator_name: "Rosen, Richard",
    creator_contact: nil,
    affiliation: "University Florida"
  },
  %{
    id: 15,
    creator_name: "Woychowsky, Edmond",
    creator_contact: nil,
    affiliation: "University Rutgers"
  },
  %{
    id: 16,
    creator_name: "Taylor, Arlene G.",
    creator_contact: nil,
    affiliation: "University Texas, Austin"
  },
  %{
    id: 17,
    creator_name: "Stueart, Robert D.",
    creator_contact: nil,
    affiliation: "University Rutgers"
  },
  %{
    id: 18,
    creator_name: "Moran, Barbara B.",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    id: 19,
    creator_name: "Morville, Peter",
    creator_contact: nil,
    affiliation: "University Georgia Tech"
  },
  %{
    id: 20,
    creator_name: "Rosenfeld, Louis",
    creator_contact: nil,
    affiliation: "University Harvard"
  },
  %{
    id: 21,
    creator_name: "Robinson, Mark",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    id: 22,
    creator_name: "Bracking, Sarah",
    creator_contact: nil,
    affiliation: "University Virginia"
  },
  %{
    id: 23,
    creator_name: "Huffington, Arianna Stassinopoulos",
    creator_contact: nil,
    affiliation: "University Johns Hopkins"
  },
  %{
    id: 24,
    creator_name: "Hancock, Graham",
    creator_contact: nil,
    affiliation: "University Alaska, Anchorage"
  }
]

for creator <- creator_list do
  %Creator{
    id: creator_id,
    type: type,
    creator_name: creator_name,
    creator_contact: creator_contact,
    affiliation: affiliation
  }
  |> Master.create_creator()
end
