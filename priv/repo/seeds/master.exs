alias Voile.Repo
alias Voile.Schema.Master.Creator

creator_list = [
  %{
    type: "Person",
    creator_name: "Valade, Janet",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    creator_name: "Siever, Ellen",
    creator_contact: nil,
    affiliation: "University of Washington"
  },
  %{
    creator_name: "Love, Robert",
    creator_contact: nil,
    affiliation: "University of North Carolina, Chapel Hill"
  },
  %{
    creator_name: "Robbins, Arnold",
    creator_contact: nil,
    affiliation: "University of Johns Hopkins"
  },
  %{
    creator_name: "Figgins, Stephen",
    creator_contact: nil,
    affiliation: "University North Carolina, Chapel Hill"
  },
  %{
    creator_name: "Weber, Aaron",
    creator_contact: nil,
    affiliation: "University Emory"
  },
  %{
    creator_name: "Kofler, Michael",
    creator_contact: nil,
    affiliation: "University Yale"
  },
  %{
    creator_name: "Kramer, David",
    creator_contact: nil,
    affiliation: "University Loyola Marymount"
  },
  %{
    creator_name: "Raymond, Eric",
    creator_contact: nil,
    affiliation: "University Massachusetts, Amherst"
  },
  %{
    creator_name: "Fogel, Karl",
    creator_contact: nil,
    affiliation: "University San Francisco State"
  },
  %{
    creator_name: "Douglas, Korry",
    creator_contact: nil,
    affiliation: "University Denver"
  },
  %{
    creator_name: "Douglas, Susan",
    creator_contact: nil,
    affiliation: "University Kent State"
  },
  %{
    creator_name: "Shklar, Leon",
    creator_contact: nil,
    affiliation: "University Georgia Tech"
  },
  %{
    creator_name: "Rosen, Richard",
    creator_contact: nil,
    affiliation: "University Florida"
  },
  %{
    creator_name: "Woychowsky, Edmond",
    creator_contact: nil,
    affiliation: "University Rutgers"
  },
  %{
    creator_name: "Taylor, Arlene G.",
    creator_contact: nil,
    affiliation: "University Texas, Austin"
  },
  %{
    creator_name: "Stueart, Robert D.",
    creator_contact: nil,
    affiliation: "University Rutgers"
  },
  %{
    creator_name: "Moran, Barbara B.",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    creator_name: "Morville, Peter",
    creator_contact: nil,
    affiliation: "University Georgia Tech"
  },
  %{
    creator_name: "Rosenfeld, Louis",
    creator_contact: nil,
    affiliation: "University Harvard"
  },
  %{
    creator_name: "Robinson, Mark",
    creator_contact: nil,
    affiliation: "University of California, Berkeley"
  },
  %{
    creator_name: "Bracking, Sarah",
    creator_contact: nil,
    affiliation: "University Virginia"
  },
  %{
    creator_name: "Huffington, Arianna Stassinopoulos",
    creator_contact: nil,
    affiliation: "University Johns Hopkins"
  },
  %{
    creator_name: "Hancock, Graham",
    creator_contact: nil,
    affiliation: "University Alaska, Anchorage"
  }
]

for creator <- creator_list do
  %Creator{
    type: "Person",
    creator_name: creator[:creator_name],
    creator_contact: creator[:creator_contact],
    affiliation: creator[:affiliation]
  }
  |> Repo.insert!()
end
