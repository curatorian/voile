# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Voile.Repo.insert!(%Voile.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Voile.Repo
alias Voile.Schema.Metadata

# Populate the Vocabulary
vocab = [
  %{
    id: 1,
    namespace_url: "http://purl.org/dc/terms/",
    prefix: "dcterms",
    label: "Dublin Core",
    information: "Basic resource metadata (DCMI Metadata Terms)"
  },
  %{
    id: 2,
    namespace_url: "http://purl.org/dc/dcmitype/",
    prefix: "dctype",
    label: "Dublin Core Type",
    information: "Basic resource types (DCMI Type Vocabulary)"
  },
  %{
    id: 3,
    namespace_url: "http://purl.org/ontology/bibo/",
    prefix: "bibo",
    label: "Bibliographic Ontology",
    information: "Bibliographic metadata (BIBO)"
  },
  %{
    id: 4,
    namespace_url: "http://xmlns.com/foaf/0.1/",
    prefix: "foaf",
    label: "Friend of a Friend",
    information: "Relationships between people and organizations (FOAF)"
  }
]

for vocabulary <- vocab do
  Metadata.create_vocabulary(vocabulary)
end

# Populate the Node List
node_list = [
  %{
    id: 1,
    name: "Fakultas Hukum",
    abbr: "FH",
    description: nil,
    image: nil
  },
  %{
    id: 2,
    name: "Fakultas Ekonomi dan Bisnis",
    abbr: "FEB",
    description: nil,
    image: nil
  },
  %{
    id: 3,
    name: "Fakultas Kedokteran",
    abbr: "FK",
    description: nil,
    image: nil
  },
  %{
    id: 4,
    name: "Fakultas Matematika dan Ilmu Pengetahuan Alam",
    abbr: "FMIPA",
    description: nil,
    image: nil
  },
  %{
    id: 5,
    name: "Fakultas Pertanian",
    abbr: "Faperta",
    description: nil,
    image: nil
  },
  %{
    id: 6,
    name: "Fakultas Kedokteran Gigi",
    abbr: "FKG",
    description: nil,
    image: nil
  },
  %{
    id: 7,
    name: "Fakultas Ilmu Sosial dan Ilmu Politik",
    abbr: "FISIP",
    description: nil,
    image: nil
  },
  %{
    id: 8,
    name: "Fakultas Ilmu Budaya",
    abbr: "FIB",
    description: nil,
    image: nil
  },
  %{
    id: 9,
    name: "Fakultas Psikologi",
    abbr: "FAPSI",
    description: nil,
    image: nil
  },
  %{
    id: 10,
    name: "Fakultas Peternakan",
    abbr: "FAPET",
    description: nil,
    image: nil
  },
  %{
    id: 11,
    name: "Fakultas Ilmu Komunikasi",
    abbr: "FIKOM",
    description: nil,
    image: nil
  },
  %{
    id: 12,
    name: "Fakultas Keperawatan",
    abbr: "FKEP",
    description: nil,
    image: nil
  },
  %{
    id: 13,
    name: "Fakultas Perikanan dan Ilmu Kelautan",
    abbr: "FPIK",
    description: nil,
    image: nil
  },
  %{
    id: 14,
    name: "Fakultas Teknologi Industri Pertanian",
    abbr: "FTIP",
    description: nil,
    image: nil
  },
  %{
    id: 15,
    name: "Sekolah Pascasarjana",
    abbr: "SPS",
    description: nil,
    image: nil
  },
  %{
    id: 16,
    name: "Fakultas Farmasi",
    abbr: "FARMASI",
    description: nil,
    image: nil
  },
  %{
    id: 17,
    name: "Fakultas Teknik Geologi",
    abbr: "FTG",
    description: nil,
    image: nil
  },
  %{
    id: 18,
    name: "Perpustakaan Pangandaran",
    abbr: "Pangandaran",
    description: nil,
    image: nil
  },
  %{
    id: 19,
    name: "Perpustakaan Garut",
    abbr: "Garut",
    description: nil,
    image: nil
  },
  %{
    id: 20,
    name: "Perpustakaan Pusat",
    abbr: "Kandaga",
    description: nil,
    image: nil
  },
  %{
    id: 21,
    name: "Fakultas Vokasi",
    abbr: "Vokasi",
    description: nil,
    image: nil
  }
]

for node <- node_list do
  Voile.Schema.System.create_node(node)
end
