module lib/project

pub struct project
    name : string
    desc : string
    link : project-link

pub type project-link
    GitHub(repo : string)
    Custom(raw-link : string)

pub fun project-link/show(pr) match pr
    GitHub(repo) -> "https://github.com/" ++ repo ++ ".git"
    Custom(link) -> link

pub val projects = [
    Project("rayt",
            "Ray tracer in Haskell",
            "LitFill/rayt".GitHub),
    Project("fractran-koka",
            "Fractan language implemented in Koka",
            "LitFill/fractran-koka".GitHub),
    Project("gyrum",
            "Mercury language project scaffolder",
            "LitFill/gyrum".GitHub),
]

