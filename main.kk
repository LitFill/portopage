module main

import std/os/path
import std/os/file
import html/html/html
import html/html/style-builder

fun add-id(id-str)
    add-attr("id", id-str)

fun some-stylesheet ()
    stylesheet
        add-rule
            add-selector(".red")
            add-property("color","red")
        add-rule
            add-selector(".blue")
            add-property("color","blue")

fun main-p () : _ component
    html
        add-attr("lang", "id")
        head
            meta-charset()
            meta-viewport()
            title
                "Title :: Hello Koka".text

            stylesheet("https://cdn.jsdelivr.net/npm/water.css@2/out/water.css")
            stylesheet("./style.css")
        body
            main
                h1
                    "LitFill".text
                project-section ()

struct project
    name : string
    desc : string
    link : project-link

type project-link
    GitHub(repo : string)
    Custom(raw-link : string)

fun project-link/show(pr) match pr
    GitHub(repo) -> "https://github.com/" ++ repo ++ ".git"
    Custom(link) -> link

val projects = [
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

fun project-section ()
    section
        p
            "My Projects:".text
        ul
            projects.foreach fn(pr)
                li
                    a(pr.link.show)
                        code
                            pr.name.text
                    p
                        pr.desc.text

fun main ()
    "=== Generating HTML ===".println
    val html-str = "<!DOCTYPE html>\n" ++ main-p().show
    html-str.println
    "index.html".path.write-text-file(html-str)

    println("")
    "=== Generating CSS ===".println
    val css-str = some-stylesheet().show
    css-str.println
    "style.css".path.write-text-file(css-str)
